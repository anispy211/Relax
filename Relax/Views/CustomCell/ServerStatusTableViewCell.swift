//
//  ServerStatusTableViewCell.swift
//  Relax
//
//  Created by Aniruddha Kadam on 24/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit

class ServerStatusTableViewCell: UITableViewCell {
    
    @IBOutlet var cardView: UIView?
    @IBOutlet var statusImageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var priorityLabel: UILabel?
    @IBOutlet var priorityLevel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView?.addBorder(withColor: .clear, borderWidht: 1, cornerRadius: 12, clipToBounds: true)
        cardView?.addShadow(color: .black, shadowRadiusValue: 2, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.5)
        resetCell()
    }
    
    func resetCell() {
        statusImageView?.image = nil
        nameLabel?.text = ""
        dateLabel?.text = ""
        priorityLabel?.text = "Priority"
        priorityLevel?.text = ""
    }

    func setData(serverStatus: ServerPendingItemBean) {
        resetCell() 
        nameLabel?.text = serverStatus.name
        dateLabel?.text = serverStatus.downtime
        priorityLabel?.text = "Priority"
        priorityLevel?.text = "\(serverStatus.severity ?? 0)"
        if let severeity = serverStatus.severity {
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
    
    private func setupUIStatus(status: ServerStatus){
        switch status {
        case .good:
            statusImageView?.image = #imageLiteral(resourceName: "check")
            nameLabel?.textColor = Constants.goodColor
            priorityLevel?.textColor = Constants.goodColor
        case .warning:
            statusImageView?.image = #imageLiteral(resourceName: "warning")
            nameLabel?.textColor = Constants.warningColor
            priorityLevel?.textColor = Constants.warningColor
        case .danger:
            statusImageView?.image = #imageLiteral(resourceName: "danger")
            nameLabel?.textColor = Constants.dangerColor
            priorityLevel?.textColor = Constants.dangerColor
        }
    }
}
