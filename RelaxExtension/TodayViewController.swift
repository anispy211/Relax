//
//  TodayViewController.swift
//  RelaxExtension
//
//  Created by Aniruddha Kadam on 07/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit
import NotificationCenter


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var countLabel: UILabel?
    @IBOutlet var statusImageView: UIImageView?
    @IBOutlet var bgView: UIView?

    var serverStatusBean: ServerStateBean?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUIStatus(status: ServerStatus){
         switch status {
         case .good:
             countLabel?.text = "Relax"
             bgView?.backgroundColor = Constants.goodColor
             countLabel?.textColor = Constants.goodColor
             statusImageView?.image = #imageLiteral(resourceName: "check")
         case .warning:
             countLabel?.text = "Needs Attention"
             bgView?.backgroundColor = Constants.warningColor
             countLabel?.textColor = Constants.warningColor
             statusImageView?.image = #imageLiteral(resourceName: "warning")
         case .danger:
             countLabel?.text = "Critical"
             bgView?.backgroundColor = Constants.dangerColor
             countLabel?.textColor = Constants.dangerColor
             statusImageView?.image = #imageLiteral(resourceName: "danger")
         }
     }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func openApp() {
        let myAppUrl = NSURL(string: "relaxapp://some-context")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    func processResponse(serverStatusData: ServerStateBean) {
          serverStatusBean = serverStatusData
        updateUI()
          if let count = serverStatusData.count {
              
          }
      }
    
    func updateUI() {
           guard let serverBean = serverStatusBean else {
               return
           }
           
           if let severeity = serverBean.severity {
               switch severeity {
               case 0...3:
                   setupUIStatus(status: .good)
               case 4...7:
                   setupUIStatus(status: .warning)
               case 8...10:
                   setupUIStatus(status: .danger)
               default:
                       break
               }
           }
       }
     
}


extension TodayViewController {
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
           // self?.onLoginFailure()
        }
    }
    
    // MARK: - API CALL
    func doServerStatusRequest() {
        guard let authToken = User.shared.authToken else {
          //  onLoginFailure()
            return
        }
        AuthService.doServerStatusRequest(apiKey: authToken, successCompletion: { [weak self] (response) in
            if let resp = response {
                self?.processResponse(serverStatusData: resp)
            }
        }) { (error) in
            print(error as Any)
        }
    }
}
