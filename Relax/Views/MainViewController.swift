//
//  MainViewController.swift
//  Relax
//
//  Created by Aniruddha Kadam on 21/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    @IBOutlet var severeityLabel: UILabel?
    @IBOutlet var numberOfItemLable: UILabel?

    
    @IBOutlet var countLabel: UILabel?
    @IBOutlet var serverStatusImageView: UIImageView?
    @IBOutlet var headerView: UIView?
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet var headerViewTopConstraint: NSLayoutConstraint?

    
    var serverStatusBean: ServerStateBean?

    var notificationsList: [ServerPendingItemBean]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "ServerStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "ServerStatusTableViewCell")
        hideheaderView()
        //setupUIStatus(status: .good)
        if let serverStatusbean = serverStatusBean {
                   processResponse(serverStatusData: serverStatusbean)
               } else {
                   doServerStatusRequest()
               }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    
   private func setupUIStatus(status: ServerStatus){
        switch status {
        case .good:
            severeityLabel?.text = "Relax,"
            self.view.backgroundColor = Constants.goodColor
            countLabel?.textColor = Constants.goodColor
            serverStatusImageView?.image = #imageLiteral(resourceName: "check")
        case .warning:
            severeityLabel?.text = "Needs Attention,"
            self.view.backgroundColor = Constants.warningColor
            countLabel?.textColor = Constants.warningColor
            serverStatusImageView?.image = #imageLiteral(resourceName: "warning")
        case .danger:
            severeityLabel?.text = "Critical,"
            self.view.backgroundColor = Constants.dangerColor
            countLabel?.textColor = Constants.dangerColor
            serverStatusImageView?.image = #imageLiteral(resourceName: "danger")
        }
    }
    
    func processResponse(serverStatusData: ServerStateBean) {
        serverStatusBean = serverStatusData
        notificationsList?.removeAll()
        if let count = serverStatusData.count , count > 0, let items = serverStatusData.items {
            notificationsList = items
            tableView?.reloadData()
        }
         updateUI()
    }
    
    func hideheaderView() {
        headerViewTopConstraint?.constant = 0
        headerViewHeightConstraint?.constant = 0
        headerView?.layoutIfNeeded()
        headerView?.isHidden = true
    }
    
    func showHeaderView() {
        headerViewTopConstraint?.constant = 10
        headerView?.addBorder(withColor: .clear, borderWidht: 1, cornerRadius: 6, clipToBounds: true)
        headerView?.addShadow(color: .clear, shadowRadiusValue: 2, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.5)
        headerView?.isHidden = false
        headerViewHeightConstraint?.constant = 55
        headerView?.layoutIfNeeded()
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
        
        if let itemCount = serverBean.count, itemCount > 0 {
            numberOfItemLable?.text = "\(itemCount) item(s) pending"
            countLabel?.text = "\(itemCount)"
            showHeaderView()
        } else {
            countLabel?.text = "0"
            hideheaderView()
            numberOfItemLable?.text = "0 item(s) pending"
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerStatusTableViewCell", for: indexPath) as! ServerStatusTableViewCell
        cell.selectionStyle = .none
        if let item = notificationsList?[indexPath.row] {
            cell.setData(serverStatus: item)
        }
        return cell
    }
}

extension MainViewController {
    // MARK: - API CALL
    func doServerStatusRequest() {
        
        guard let authToken = User.shared.authToken else {
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
