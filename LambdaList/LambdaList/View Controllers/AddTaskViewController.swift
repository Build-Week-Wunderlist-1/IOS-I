//
//  AddTaskViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    // MARK: - Properties
    
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Actions
    @IBAction func createTaskButtonPressed(_ sender: UIButton) {
        guard let titleText = titleTextField?.text, let descriptionText = descriptionTextView?.text else {
            return
        }
        
        let task = Task(taskName: titleText, taskDescription: descriptionText)
        
        //Save Locally
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving task in AddTaskViewController: \(error)")
        }
        
        //TODO - Send added task to the WebServer
        
        dismiss(animated: true)
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods

}
