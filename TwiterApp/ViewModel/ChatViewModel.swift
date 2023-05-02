//
//  ChatViewModel.swift
//  TwiterApp
//
//  Created by MZ01-MINCKAN on 2023/05/02.
//

import Foundation

struct ChatViewModel {
    let channel : Channel
    var timestamp : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: channel.timestamp)
    }
    
    init(channel: Channel) {
        self.channel = channel
    }
}
