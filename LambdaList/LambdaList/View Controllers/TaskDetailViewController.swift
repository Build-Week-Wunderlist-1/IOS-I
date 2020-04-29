//
//  TaskDetailViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var taskStatusLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // MARK: - Actions
    @IBOutlet private weak var editButtonPressed: UIBarButtonItem!
    
    // MARK: - Properties
    var task: Task?
    
    // TODO: ? - dependancy injection w / didSet/ call update views
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let tempTask = task, let taskName = tempTask.taskName, let taskDescription = tempTask.taskDescription, let dateCreated = tempTask.createdDate else {
            print("Something in task is nil")
            return
        }
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter
        }()
        
        //Setting Properties
        titleTextField.text = taskName
        descriptionTextView.text = taskDescription
        dateLabel.text = dateFormatter.string(from: dateCreated)
        
        if tempTask.completed == true {
            taskStatusLabel.text = "Status: Complete"
        } else {
            taskStatusLabel.text = "Status: Incomplete"
        }
    }

}
