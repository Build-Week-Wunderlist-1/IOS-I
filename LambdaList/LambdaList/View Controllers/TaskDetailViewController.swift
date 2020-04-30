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
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    // MARK: - Actions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        //If editing task properties
        //Then Allow editing
        if editTask == true {
            editTask = false
            previousTitle = titleTextField.text
            previousDescription = descriptionTextView.text
            titleTextField.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            editButton?.title = "Edit"
            titleTextField.backgroundColor = .clear
            descriptionTextView.backgroundColor = .clear
            
            task?.taskName = titleTextField.text
            task?.taskDescription = descriptionTextView.text
            
            //Did the user change the task?
            if previousTitle != titleTextField.text || previousDescription != descriptionTextView.text {

                if let task = task,
                    let taskController = taskController {

                    taskController.updateTask(task)
                }
            }
                
        } else {
            editTask = true
            titleTextField.backgroundColor = .systemGray5
            descriptionTextView.backgroundColor = .systemGray5
            titleTextField.isUserInteractionEnabled = true
            descriptionTextView.isUserInteractionEnabled = true
            editButton?.title = "Done"
        }
    }
    
    
    // MARK: - Properties
    var task: Task?
    var editTask = false
    var previousTitle: String?
    var previousDescription: String?
    var taskController: TaskController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        updateViews()
    }
    
    // MARK: - Methods
    func updateViews() {
        titleTextField.backgroundColor = .clear
        descriptionTextView.backgroundColor = .clear
        
        guard let tempTask = task, let taskName = tempTask.taskName,
            let taskDescription = tempTask.taskDescription,
            let dateCreated = tempTask.createdDate else {
            print("Something in task is nil")
            return
        }
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.dateFormat = "MMM d, h:mm a"
            return dateFormatter
        }()
        
        //Setting Properties
        titleTextField.text = taskName
        descriptionTextView.text = taskDescription
        dateLabel.text = "Date Created: " + dateFormatter.string(from: dateCreated)
        
        if tempTask.completed == true {
            taskStatusLabel.text = "Status: Complete"
        } else {
            taskStatusLabel.text = "Status: Incomplete"
        }
    }

}
