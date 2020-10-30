//
//  CoreDataManager.swift
//  Creative Softwares Task
//
//  Created by Muhammad Luqman on 10/30/20.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let entityName = "Task"
    
    //1
    static let sharedManager = CoreDataManager()
    private init() {} // Prevent clients from creating another instance.
    
    //2
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Database")
        
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //3
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func getManagedContext() -> NSManagedObjectContext {
        return CoreDataManager.sharedManager.persistentContainer.viewContext
    }
    
    /*Insert*/
    func insertTask(id: String, name: String, priority : String, dateTime: Date, isComplete: Bool)->Task? {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let managedContext = self.getManagedContext()
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         
         Retrieving an Entity with a Given Name here task
         */
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        
        task.setValue(id, forKeyPath: TaskKyes.id.rawValue)
        task.setValue(name, forKeyPath: TaskKyes.name.rawValue)
        task.setValue(priority, forKeyPath: TaskKyes.priority.rawValue)
        task.setValue(dateTime, forKeyPath: TaskKyes.dateTime.rawValue)
        task.setValue(isComplete, forKeyPath: TaskKyes.isComplete.rawValue)
        
        /*
         You commit your changes to task and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
            return task as? Task
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    func update(isCompleted: Bool, task: Task) {
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            /*
             With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
             */
            task.setValue(isCompleted, forKey: TaskKyes.isComplete.rawValue)
            
            print("\(task.value(forKey: TaskKyes.name.rawValue) ?? "")")
            print("\(task.value(forKey: TaskKyes.priority.rawValue) ?? "")")
            
            /*
             You commit your changes to task and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
             */
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    /*delete*/
    func delete(task : Task){
        
        let managedContext = self.getManagedContext()
        
        do {
            
            managedContext.delete(task)
            
        } catch {
            // Do something in response to error condition
            print(error)
        }
        
        do {
            try managedContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    func fetchAllTasks( _ isCompleted: Bool) -> [Task]?{
        
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = self.getManagedContext()
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all task entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            
            print(isCompleted)
            fetchRequest.predicate = NSPredicate(format: "\(TaskKyes.isComplete.rawValue) == %@", NSNumber(value: isCompleted))
            let sort = NSSortDescriptor(key: TaskKyes.dateTime.rawValue, ascending: false)
            fetchRequest.sortDescriptors = [sort]
            
            let people = try managedContext.fetch(fetchRequest)
            return people as? [Task]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func delete(priority: String) -> [Task]? {
        /*get reference to appdelegate file*/
        
        
        /*get reference of managed object context*/
        let managedContext = self.getManagedContext()
        
        /*init fetch request*/
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
        fetchRequest.predicate = NSPredicate(format: "\(TaskKyes.priority.rawValue) == %@" ,priority)
        do {
            
            /*managedContext.fetch(fetchRequest) will return array of task objects [taskObjects]*/
            let item = try managedContext.fetch(fetchRequest)
            var arrRemovedPeople = [Task]()
            for i in item {
                
                /*call delete method(aManagedObjectInstance)*/
                /*here i is managed object instance*/
                managedContext.delete(i)
                
                /*finally save the contexts*/
                try managedContext.save()
                
                /*update your array also*/
                arrRemovedPeople.append(i as! Task)
            }
            return arrRemovedPeople
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    /*In cases we need to flush data, we can call this method*/
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let objs = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            CoreDataManager.sharedManager.persistentContainer.viewContext.delete(obj)
        }
        
        try! CoreDataManager.sharedManager.persistentContainer.viewContext.save()
    }
    
    
    func getRecordsCount() -> Int{
        
        let managedContext = self.getManagedContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
}

//Note :  There are still alot of improvement that can be done in this class example - This class still does not uses dependency injection. This is on my list of tutorials. Hint -
//Tightly coupled - persistentContainer can not be initialized by other client classes with different model, as it is tightly coupled with "taskData".
//Not reusable - insert, update and delete only work with task, what if i have other entities and i want to perform insert, update and delete.

