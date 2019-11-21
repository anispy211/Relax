//
//  ViewController.swift
//  Relax
//
//  Created by Aniruddha Kadam on 07/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var inputField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderWidth = 1.5
        inputField.layer.cornerRadius = 15
        inputField.layer.borderWidth = 1.5
        loginButton.layer.borderColor = #colorLiteral(red: 0.1837867498, green: 0.4883144498, blue: 0.8014778495, alpha: 1)
        inputField.layer.borderColor = #colorLiteral(red: 0.1837867498, green: 0.4883144498, blue: 0.8014778495, alpha: 1)
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        inputField.leftView = leftPadding
        inputField.leftViewMode = .always
    }
    
    @IBAction func onLoginButtonPressed() {
        // To Do: need to add an API call
        onLoginSuccess()
    }
    
    func onLoginSuccess() {
        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }

}

