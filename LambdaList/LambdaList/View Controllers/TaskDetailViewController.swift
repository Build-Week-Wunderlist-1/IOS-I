//
//  TaskDetailViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Actions
    @IBOutlet weak var editButtonPressed: UIBarButtonItem!
    
    // MARK: - Properties
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: ? - Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            return dateFormatter
        }()
        
        guard let task = task else { return }
        
        titleTextField.text = task.taskName
        dateLabel.text = dateFormatter.string(from: task.createdDate!)
        taskStatusLabel.text?.append(task.completed == true ? " Complete" : " Incomplete")
        descriptionTextView.text = task.taskDescription ?? ""
    }

}
