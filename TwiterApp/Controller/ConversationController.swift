//
//  ConversationController.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/12.
//

import UIKit
import FirebaseFirestore

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UITableViewController {
    // MARK: - Properties
    var channels = [Channel]()
    
    private let channelStream = ChannelFirestoreStream()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        configureUI()
        setupListener()
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
    
    private func setupListener() {
        channelStream.subscribe { [weak self] result in
          
            switch result {
            case .success(let data):
                print("DEBUG: success - \(data)")
                self?.updateCell(to: data)
            case .failure(let error):
                print("DEBUG: error - \(error)")
            }
        }
    }
    
    private func updateCell(to data: [(Channel, DocumentChangeType)]) {
        data.forEach { (channel, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard channels.contains(channel) == false else {return}
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else {return}
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {return}
        channels[index] = channel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {return}
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension ConversationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.channel = channels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let controller = ChatController(channel: channel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
