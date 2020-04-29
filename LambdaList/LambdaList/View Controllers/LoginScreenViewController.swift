//
//  LoginScreenViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var logInStatusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: - Methods

}
