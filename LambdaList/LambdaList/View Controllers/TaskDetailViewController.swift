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
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Actions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        //If editing task properties
        //Then Allow editing
        if editTask == true {
            editTask = false
            titleTextField.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            editButton?.title = "Edit"
            
            task?.taskName = titleTextField.text
            task?.taskDescription = descriptionTextView.text
            
            //Save Changes to CoreData
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("Error Saving changes to CoreData: \(error)")
            }
            
        } else {
            editTask = true
            titleTextField.isUserInteractionEnabled = true
            descriptionTextView.isUserInteractionEnabled = true
            editButton?.title = "Done"
        }
    }
    
    
    // MARK: - Properties
    var task: Task?
    var editTask = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
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
        dateLabel.text = "Date Created: " + dateFormatter.string(from: dateCreated)
        
        if tempTask.completed == true {
            taskStatusLabel.text = "Status: Complete"
        } else {
            taskStatusLabel.text = "Status: Incomplete"
        }
    }

}
