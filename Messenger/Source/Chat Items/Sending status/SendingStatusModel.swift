//
//  SendingStatusModel.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Chatto
import ChattoAdditions

final class SendingStatusModel: ChatItemProtocol {
    let uid: String
    let status: MessageStatus
    
    static var chatItemType: ChatItemType {
        return "decoration-status"
    }
    
    var type: String { return SendingStatusModel.chatItemType }
    
    init(uid: String, status: MessageStatus) {
        self.uid = uid
        self.status = status
    }
}
