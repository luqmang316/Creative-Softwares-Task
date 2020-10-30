//
//  ViewController.swift
//  Creative Softwares Task
//
//  Created by Muhammad Luqman on 10/29/20.


enum TaskKyes: String {
    
    case id = "id"
    case name = "name"
    case priority = "priority"
    case dateTime = "dateTime"
    case isComplete = "isComplete"
}

enum NotificationCenterKey: String {
    
    case updateTableView = "updateTableView"
}

enum Priority: String {
    
    case Low = "Low"
    case Medium = "Medium"
    case Height = "Height"
}

import UIKit
import CoreData

class TaskListVewController: UIViewController {
    
    //MARK:-OutLets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var taskCounterlabel: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    
    @IBOutlet weak var lblTotalTask: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    var pendingTasks: [NSManagedObject] = []
    var completedTasks: [NSManagedObject] = []
    var isCompleted = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up UI
        setUpUI()
        
        // Register the Notification Center for reload tableview when tap on buttion and tableview cell
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView),name: NSNotification.Name (NotificationCenterKey.updateTableView.rawValue),object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let tasks = fetchAllTasks(isCompleted: false) else {
            return
        }
        self.pendingTasks = tasks
        self.tableView.reloadData()
        
    }
    
    private func setUpUI(){
        
        // Register custom table view cell..
        self.tableView.register(UINib(nibName: "OpenTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenTaskTableViewCell")
        tableView.tableFooterView = UIView()
        
        // Set corner radious of label..
        self.lblTotal.layer.cornerRadius = 10
        self.lblTotal.layer.masksToBounds = true
        
        //Set Day month and year on card
        let dateInString = Date().dateString(formate: "EEEE MMM d yyyy").split(separator: " ")
        lblDay.text = String(dateInString[0])
        lblMonth.text = String(dateInString[1] + ", " + dateInString[2])
        lblYear.text = String(dateInString[3])
        
    }
    
    @IBAction func btnAddTask(_ sender: Any) {
        
        self.promptForAnswer()
        
    }
    
    func fetchAllTasks(isCompleted: Bool) -> [NSManagedObject]? {
        
        if let  tasks = CoreDataManager.sharedManager.fetchAllTasks(isCompleted){
            let totalCount = CoreDataManager.sharedManager.getRecordsCount()
            self.lblTotal.text = (totalCount <= 1 ? "Task" : "Tasks")
            self.lblTotalTask.text = "\(totalCount)"
            return tasks
        }
        return nil
    }
    
    
    //MARK:-Alert view for task name
    
    func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter task name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add task", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            if let txt = answer.text, txt.count != 0{
                
                self.insertRecord(txt: txt)
                
            }
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    //MARK:-Insert the task..
    func insertRecord(txt: String) {
        
        let person = CoreDataManager.sharedManager.insertTask(id: UUID().uuidString, name: txt, priority: "", dateTime: Date(), isComplete: false)
        
        if person != nil {
            
            guard let tasks = fetchAllTasks(isCompleted: false) else {
                return
            }
            self.pendingTasks = tasks
            self.tableView.reloadData()
            
            //tasks.append(person!)
            //tableView.reloadData()
        }
        
    }
    
    //MARK:-Notification
    /// Update table view using Notification
    @objc func updateTableView(_ notification: Notification){
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK:-Button action
    @IBAction func btnPending(_ sender: Any) {
        
        isCompleted = false
        guard let tasks = fetchAllTasks(isCompleted: isCompleted) else {
            
            return
        }
        self.pendingTasks = tasks
        self.tableView.reloadData()
        self.updateBtnTitleColor(pendingColor: "1F1F1F", completedColor: "AFAFAF")
        
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        
        isCompleted = true
        
        guard let tasks = fetchAllTasks(isCompleted: isCompleted) else {
            
            return
        }
        
        self.completedTasks = tasks
        self.tableView.reloadData()
        self.updateBtnTitleColor(pendingColor: "AFAFAF", completedColor: "1F1F1F")
        
    }
    
    func updateBtnTitleColor(pendingColor: String, completedColor: String) {
        
        self.btnCompleted.setTitleColor(UIColor.colorFrom(hexString: completedColor, alpha: 1), for: .normal)
        self.btnPending.setTitleColor(UIColor.colorFrom(hexString: pendingColor, alpha: 1), for: .normal)
        
    }
    
}


//MARK:-UITableView delegate and date source
extension TaskListVewController: UITableViewDelegate, UITableViewDataSource, reloadtableView {
    
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isCompleted){
            
            return completedTasks.count
            
        }else{
            
            return pendingTasks.count
        }
        
    }
    
    // Show the custom cell..
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenTaskTableViewCell", for: indexPath) as? OpenTaskTableViewCell else {
            return UITableViewCell()
        }
        
        if(isCompleted){
            
            cell.task = completedTasks[indexPath.row]
            cell.btnCancle.isEnabled = false
            cell.btnLow.isEnabled = false
            cell.btnMedium.isEnabled = false
            cell.btnHeight.isEnabled = false
            cell.btnCalender.isEnabled = false
            
        }else{
            
            cell.task = pendingTasks[indexPath.row]
            cell.btnCancle.isEnabled = true
            cell.btnLow.isEnabled = true
            cell.btnMedium.isEnabled = true
            cell.btnHeight.isEnabled = true
            cell.btnCalender.isEnabled = true
            
        }
        
        cell.lblName?.text = cell.task.value(forKeyPath: TaskKyes.name.rawValue) as? String
        cell.lblDateTimeClose?.text = (cell.task.value(forKeyPath: TaskKyes.dateTime.rawValue) as? Date)?.dateString(formate: "MMM dd, hh:mm a")
        cell.lblDateTimeOpen?.text = (cell.task.value(forKeyPath: TaskKyes.dateTime.rawValue) as? Date)?.dateString(formate: "MMM dd, hh:mm a")
        
        cell.selectionStyle = .none
        cell.delegate = self
        
        if(cell.task.value(forKeyPath: TaskKyes.priority.rawValue) as? String == Priority.Low.rawValue){
            
            cell.btnLow.backgroundColor = UIColor.colorFrom(hexString: "5FCD8D", alpha: 1)
            cell.btnMedium.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)
            cell.btnHeight.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)
            
        }else if(cell.task.value(forKeyPath: TaskKyes.priority.rawValue) as? String == Priority.Medium.rawValue){
            
            cell.btnMedium.backgroundColor = UIColor.colorFrom(hexString: "FB8333", alpha: 1)
            cell.btnLow.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)
            cell.btnHeight.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)
            
        }else if(cell.task.value(forKeyPath: TaskKyes.priority.rawValue) as? String == Priority.Height.rawValue){
            
            cell.btnHeight.backgroundColor = UIColor.colorFrom(hexString: "FF6159", alpha: 1)
            cell.btnMedium.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)
            cell.btnLow.backgroundColor = UIColor.colorFrom(hexString: "CBCBCB", alpha: 1)

            
        }else{
            
            self.setColotToPriority(cell: cell)
        }
        
        return cell
    }
    
    func setColotToPriority(cell: OpenTaskTableViewCell) {
        
        cell.btnLow.backgroundColor = UIColor.colorFrom(hexString: "5FCD8D", alpha: 1)
        cell.btnMedium.backgroundColor = UIColor.colorFrom(hexString: "FB8333", alpha: 1)
        cell.btnHeight.backgroundColor = UIColor.colorFrom(hexString: "FF6159", alpha: 1)
    }
    
    // Called when did selected...
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? OpenTaskTableViewCell else{return}
        cell.buttonTapped(self)
        
    }
    
    // Reload tableview
    func reload(cell: UITableViewCell) {
        
        guard let tasks = fetchAllTasks(isCompleted: isCompleted) else {
            return
        }
        self.completedTasks = tasks
        self.tableView.reloadData()
    }
    
    
}


