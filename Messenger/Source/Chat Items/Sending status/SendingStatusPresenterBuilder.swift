//
//  SendingStatusPresenterBuilder.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Chatto

final class SendingStatusPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is SendingStatusModel ? true : false
    }
    
    func createPresenterWithChatItem(
        _ chatItem: ChatItemProtocol
        ) -> ChatItemPresenterProtocol {
        assert(canHandleChatItem(chatItem))
        return SendingStatusPresenter(
            statusModel: chatItem as! SendingStatusModel
        )
    }
    
    var presenterType: ChatItemPresenterProtocol.Type {
        return SendingStatusPresenter.self
    }
}
