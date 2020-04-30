//
//  AddTaskViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
///

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    var taskController: TaskController?
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // MARK: - Actions
    @IBAction func createTaskButtonPressed(_ sender: UIButton) {
        guard let titleText = titleTextField?.text,
            let descriptionText = descriptionTextView?.text,
            !titleText.isEmpty else { return }
        
        // Create Task object
        let task = Task(taskName: titleText, taskDescription: descriptionText)

        taskController?.createTask(task)

        dismiss(animated: true)
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
}
