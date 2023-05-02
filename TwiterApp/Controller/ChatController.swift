//
//  ChatController.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/04/28.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import FirebaseAuth
import Photos

class ChatController : MessagesViewController {
    // MARK: - Properties
    lazy var cameraBarButtonItem: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .primary
        button.image = UIImage(systemName: "camera")
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    let receiverId: String
    
    private var user: User? {
        didSet {
            configure()
            confirmDelegate()
            listenToMessages()
            setupMessageInputBar()
            removeOutgoingMessageAvatars()
            addCamerabarButtonToMessageInputBar()
        }
    }
    var channel: Channel
    let chatFirestoreStream = ChatFirestoreStream()
    var messages = [Message]()
    
    private var isSendingPhoto = false {
         didSet {
           messageInputBar.leftStackViewItems.forEach { item in
             guard let item = item as? InputBarButtonItem else {
               return
             }
             item.isEnabled = !self.isSendingPhoto
           }
         }
       }
    
    // MARK: - Lifecycle
    init(uid: String, channel: Channel) {
        self.channel = channel
        self.receiverId = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    
    
    deinit {
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - API
    func fetchUser() {
        UserService.shared.fetchUser(uid: receiverId) { user in
            self.user = user
        }
    }
    // MARK: - Selectors
    @objc func didTapCameraButton() {
        
    }
    
    // MARK: - Helpers

    private func confirmDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
    
    func configure() {
        title = channel.receiverName
        navigationController?.navigationBar.prefersLargeTitles = false
//        messages = MessageService.shared.fetchMessages()
    }
    
    private func setupMessageInputBar() {
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.inputTextView.placeholder = "Aa"
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else {return}
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingCellTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addCamerabarButtonToMessageInputBar() {
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    }
    
    
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort()
        channel.latestMessage = message.content
        
        messagesCollectionView.reloadData()
    }
    
    private func listenToMessages() {
       
        guard let id = channel.id else {
            return
        }
        
        

        chatFirestoreStream.subscribe(id: id) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.loadImageAndUpdateCells(messages)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
            messages.forEach { message in
                var message = message
                if let url = message.downloadURL {
                    FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
                        guard let image = image else { return }
                        message.image = image
                        self?.insertNewMessage(message)
                    }
                } else {
                    insertNewMessage(message)
                }
            }
        }
    
}

extension ChatController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return Sender(senderId: Auth.auth().currentUser?.uid ?? "", displayName: UserDefaultManager.displayName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
    
    
}

extension ChatController : MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

extension ChatController : MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessageBackground
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
}

extension ChatController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let user = user else {return}
        let message = Message(user: user, withContent: text)
        
        chatFirestoreStream.save(message) { [weak self] error in
            if let error = error {
                print("DEBUG: error occurd -> \(error.localizedDescription)")
                return
            }
            self?.messagesCollectionView.scrollToLastItem()
        }
        inputBar.inputTextView.text.removeAll()
    }
}

extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let asset = info[.phAsset] as? PHAsset {
            let imageSize = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset,
                                                     targetSize: imageSize,
                                                     contentMode: .aspectFit,
                                                     options: nil) { image, _ in
                guard let image = image else { return }
                self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        FirebaseStorageManager.uploadImage(image: image, channel: channel) { [weak self] url in
            self?.isSendingPhoto = false
            guard let user = self?.user, let url = url else { return }
            
            var message = Message(user: user, withImage: image)
            message.downloadURL = url
            self?.chatFirestoreStream.save(message)
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

