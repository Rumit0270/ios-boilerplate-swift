//
//  UserViewController.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import UIKit
import SnapKit

class UserViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private final let TABLE_VIEW_ROW_HEIGHT = 100
    
    let userViewModel = UserViewModel()
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationWithTitle(localizedString("USERVC_NAV_TITLE"))
        userViewModel.users.bind { [weak self] (users) in
            guard let self = self else { return }
            self.users = users
        }
        userViewModel.setUsers()
        userViewModel.fetchUsers()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(UserTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = ColorConstants.mainBackgroundColor
    }
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UserTableViewCell()
        }
        
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TABLE_VIEW_ROW_HEIGHT)
    }
    
}
