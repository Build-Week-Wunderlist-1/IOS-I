//
//  LoginScreenViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    //LoginEnum
    enum LoginType {
        case login
        case signup
    }
    
    // MARK: - Properties
    var loginType: LoginType = .login
    
    var taskController = TaskController()
    
    // MARK: - Outlets
    @IBOutlet private weak var logInStatusLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        autofillTextFields()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UnlockView()
    }
    
    // MARK: - Actions
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        // save to user defaults
        UserDefaults.standard.set(usernameTextField.text, forKey: "username")
        UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        UserDefaults.standard.set(emailTextField.text, forKey: "email")
        
        //Toggle Button Images
        if rememberMeButton.currentImage == UIImage(systemName: "checkmark.square.fill") {
            rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        //Unwrap User Properties
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        if loginType == .login {
            //Logging In
            let user = User(username: username, password: password, email: nil)
            taskController.userSignin(user: user)
            dismiss(animated: true, completion: nil)
        } else {
            //Signing Up
            guard let email = emailTextField.text else {
                return
            }
            let user = User(username: username, password: password, email: email)
            taskController.userRegister(user: user)
            segmentedControl.selectedSegmentIndex = 0
            loginType = .login
            segmentedChanged()
            
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        segmentedChanged()
    }
    
    func UnlockView() {
        let userId = UserDefaults.standard.value(forKey: "userId")
        let token = UserDefaults.standard.value(forKey: "token")
        
        if userId != nil && token != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    private func autofillTextFields() {
        guard let username = UserDefaults.standard.object(forKey: "username") as? String,
            let password = UserDefaults.standard.object(forKey: "password") as? String,
            let email = UserDefaults.standard.object(forKey: "email") as? String else { return }
        
        emailTextField.text = email
        usernameTextField.text = username
        passwordTextField.text = password
    }
    
    private func updateViews() {
        logInButton.layer.cornerRadius = 3
        
        //Assign login type
        //Lock Email TextField if not signing up
        loginType = .login
        emailTextField.isUserInteractionEnabled = false
        emailTextField.isHidden = true
        logInButton.setTitle("Log In", for: .normal)
        emailLabel.isHidden = true
        logInStatusLabel.isHidden = true
    }
    
    func segmentedChanged() {
        //Assign login type
        //Lock Email TextField if not signing up
        if segmentedControl.selectedSegmentIndex == 0 {
            loginType = .login
            emailTextField.isUserInteractionEnabled = false
            emailTextField.isHidden = true
            logInButton.setTitle("Log In", for: .normal)
            emailLabel.isHidden = true
        } else {
            loginType = .signup
            emailTextField.isUserInteractionEnabled = true
            emailTextField.isHidden = false
            logInButton.setTitle("Sign Up", for: .normal)
            emailLabel.isHidden = false
        }
    }
}
