//
//  ViewController.swift
//  Relax
//
//  Created by Aniruddha Kadam on 07/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var groupIdField: UITextField!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitle("", for: .selected)
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderWidth = 1.5
        inputField.layer.cornerRadius = 15
        inputField.layer.borderWidth = 1.5
        loginButton.layer.borderColor = #colorLiteral(red: 0.1837867498, green: 0.4883144498, blue: 0.8014778495, alpha: 1)
        inputField.layer.borderColor = #colorLiteral(red: 0.1837867498, green: 0.4883144498, blue: 0.8014778495, alpha: 1)
        groupIdField.layer.borderColor = #colorLiteral(red: 0.1837867498, green: 0.4883144498, blue: 0.8014778495, alpha: 1)
        groupIdField.layer.cornerRadius = 15
        groupIdField.layer.borderWidth = 1.5
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        inputField.leftView = leftPadding
        inputField.leftViewMode = .always
        let leftPadding1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        groupIdField.leftView = leftPadding1
        groupIdField.leftViewMode = .always
        activityView.isHidden = true
        activityView.stopAnimating()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
              view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    @IBAction func onLoginButtonPressed() {
        self.view.endEditing(true)
        // To Do: need to add an API call
        
        if validateInput() {
            guard let groupID = groupIdField.text, let phoneNumber = inputField.text else {
                return
            }
            activityView.isHidden = false
            activityView.startAnimating()
            loginButton.isSelected = true
            self.view.isUserInteractionEnabled = false
            loginRequest(groupdID: groupID, phoneNumber: phoneNumber)
        }
    }

    func validateInput() -> Bool {
        guard let groupID = groupIdField.text, !groupID.isEmpty else {
            let alert = UIAlertController(title: "Sorry", message: "Please enter group id", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        guard let phoneNumber = inputField.text, !phoneNumber.isEmpty else {
            let alert = UIAlertController(title: "Sorry", message: "Please enter valid phone number", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
            return false
        }
        
//        guard let deviceToken = User.shared.deviceToken, !deviceToken.isEmpty else {
//            openPushNotificationSettings()
//            return false
//        }
        
        return true
    }
    
    func openPushNotificationSettings() {
        let settingsButton = NSLocalizedString("Settings", comment: "")
        let cancelButton = NSLocalizedString("Cancel", comment: "")
        let message = NSLocalizedString("Your need to give a permission from notification settings.", comment: "")
        let goToSettingsAlert = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertController.Style.alert)

        goToSettingsAlert.addAction(UIAlertAction(title: settingsButton, style: .destructive, handler: { (action: UIAlertAction) in
            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(settingsUrl as URL)
                    }
                }
            }
        }))
        
        goToSettingsAlert.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: nil))
        self.present(goToSettingsAlert, animated: true, completion: nil)
    }

    // MARK: - API CALLBACKS
    func onLoginSuccess(_ serverStatus: ServerStateBean?) {
        loginButton.isSelected = false
        activityView.isHidden = true
        activityView.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
        mainVC.serverStatusBean = serverStatus
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func onLoginFailure() {
        loginButton.isSelected = false
        activityView.isHidden = true
        activityView.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let alert = UIAlertController(title: "Sorry", message: "Please check your credentails and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    // MARK: - API CALL
    func loginRequest(groupdID: String, phoneNumber: String) {
        var deviceToken = User.shared.deviceToken ?? ""
        if deviceToken.isEmpty {
            deviceToken = "ewrwrwec2342423"
        }
        
        AuthService.doSigninRequest(groupID: groupdID, phoneNumber: phoneNumber, deviceToken: deviceToken, successCompletion: { [weak self] (apiKey) in
            User.shared.authToken = apiKey
            self?.doServerStatusRequest()
        }) { [weak self] (error) in
            User.shared.authToken = ""
            self?.onLoginFailure()
        }
    }
    
    // MARK: - API CALL
    func doServerStatusRequest() {
        guard let authToken = User.shared.authToken else {
            onLoginFailure()
            return
        }
        AuthService.doServerStatusRequest(apiKey: authToken, successCompletion: { [weak self] (response) in
            self?.onLoginSuccess(response)
        }) { (error) in
            print(error as Any)
        }
    }
}
