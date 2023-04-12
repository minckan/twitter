//
//  NotificationController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       
        fetchNotifications()
       
    }
    
    // MARK: - API
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
            self.configureUI()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
     
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected")
    }
}

extension NotificationController: NotificationCellDelegate {
    func didTappedProfileImage(_ cell: NotificationCell) {
        print("???")
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
