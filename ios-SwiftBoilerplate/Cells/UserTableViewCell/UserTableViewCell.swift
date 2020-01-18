//
//  UserTableViewCell.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user: User? {
        didSet {
            updateLabels(for: user!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateLabels(for user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
    }

}

extension UserTableViewCell: NibLoadableView {}
extension UserTableViewCell: ReusableView {}
