//
//  OpenTaskTableViewCell.swift
//  Creative Softwares Task
//
//  Created by Muhammad Luqman on 10/29/20.
//

import UIKit
import CoreData

protocol reloadtableView: AnyObject {
    
    func reload(cell: UITableViewCell)
}

class OpenTaskTableViewCell: UITableViewCell {
    
    weak var delegate:reloadtableView?
    
    //MARK:-OutLets
    @IBOutlet weak var hieght: NSLayoutConstraint!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var btnLow: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnHeight: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnCalender: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTimeOpen: UILabel!
    @IBOutlet weak var lblDateTimeClose: UILabel!
    
    var task = NSManagedObject()
    
    //MARK:-Button Action
    @IBAction func btnCancle(_ sender: Any) {
        
        CoreDataManager.sharedManager.update(isCompleted: true, task: self.task as! Task)
        delegate?.reload(cell: self)
    }
    
    @IBAction func btnCalender(_ sender: Any) {
        
    }
    
    @IBAction func btnLow(_ sender: Any) {

        self.task.setValue(Priority.Low.rawValue, forKey: TaskKyes.priority.rawValue)
        delegate?.reload(cell: self)
        
    }
    
    @IBAction func btnMedium(_ sender: Any) {
        
        self.task.setValue(Priority.Medium.rawValue, forKey: TaskKyes.priority.rawValue)
        delegate?.reload(cell: self)
    }
    
    @IBAction func btnHeight(_ sender: Any) {
        
        self.task.setValue(Priority.Height.rawValue, forKey: TaskKyes.priority.rawValue)
        delegate?.reload(cell: self)
    }
    
    @IBAction public func buttonTapped(_ sender: Any) {
        
        // Update checkbox image
        self.checkBox.isSelected = !self.checkBox.isSelected
        
        // hide and unhide bottom View
        self.bottomView.isHidden = self.checkBox.isSelected
        self.lblDateTimeClose.isHidden = !self.checkBox.isSelected
        
        // update constraint of cell
        self.hieght.constant = self.hieght.constant == 50 ?  122:50
        self.layoutIfNeeded()
        
        // Post notification to update tableview
        NotificationCenter.default.post(name: Notification.Name(NotificationCenterKey.updateTableView.rawValue), object: nil)
        
    }
    
    //MARK:-Initialization
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.lblDateTimeClose.isHidden = true
        
        self.buttonCornerRadius(button: self.btnLow)
        self.buttonCornerRadius(button: self.btnMedium)
        self.buttonCornerRadius(button: self.btnHeight)
        
        // Initialization code
    }
    
    
    private func buttonCornerRadius(button: UIButton){
        
        button.layer.cornerRadius = 15
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
