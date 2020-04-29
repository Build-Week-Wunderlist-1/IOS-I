//
//  TaskDetailViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var taskStatusLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // MARK: - Actions
    @IBOutlet private weak var editButtonPressed: UIBarButtonItem!
    
    // MARK: - Properties
    
    // TODO: ? - dependancy injection w / didSet/ call update views
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: ? - Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    // TODO: ? - updateViews

}
