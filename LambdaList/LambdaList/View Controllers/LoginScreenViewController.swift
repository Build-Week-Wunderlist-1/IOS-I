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
    @IBOutlet private weak var logInStatusLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autofillTextFields()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        // save to user defaults
        UserDefaults.standard.set(usernameTextField.text, forKey: "username")
        UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Methods

    private func autofillTextFields() {
        guard let username = UserDefaults.standard.object(forKey: "username") as? String,
            let password = UserDefaults.standard.object(forKey: "password") as? String else { return }
        
        usernameTextField.text = username
        passwordTextField.text = password
    }
    
    private func updateViews() {
        logInButton.layer.cornerRadius = 3
        signUpButton.layer.cornerRadius = 3
    }
    
}
