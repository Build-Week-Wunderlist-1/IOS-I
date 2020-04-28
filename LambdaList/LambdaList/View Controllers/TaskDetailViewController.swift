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
    
    // TODO: ? - dependancy injection w / didSet/ call update views
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: ? - Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    // TODO: ? - updateViews

}
