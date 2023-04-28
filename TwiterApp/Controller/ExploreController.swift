//
//  ExploreController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
    // MARK: - Properties
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isSendMsg: Bool? = false
    
    private var filteredUser = [User]() {
        didSet {tableView.reloadData()}
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        if self.presentingViewController != nil {
            isSendMsg = true
            navigationItem.title = "New Message"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        } else {
            isSendMsg = false
            navigationItem.title = "Explore"
        }
    }
    


    
    // MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
      
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: UITableViewDelegate/DataSource
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUser[indexPath.row] :users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channelFirestoreStream = ChannelFirestoreStream()
        let channel = channelFirestoreStream.createChannel(with: "")
        
        let user = inSearchMode ? filteredUser[indexPath.row] :users[indexPath.row]
        let controller = isSendMsg! ? ChatController(channel: channel) : ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UISearchResultsUpdating
extension ExploreController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredUser = users.filter({$0.username.contains(searchText)})
    }
}
