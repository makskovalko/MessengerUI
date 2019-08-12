//
//  TimeSeparatorPresenterBuilder.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Chatto

final class TimeSeparatorPresenterBuilder: ChatItemPresenterBuilderProtocol {
    func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is TimeSeparatorModel
    }
    
    func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(canHandleChatItem(chatItem))
        guard let timeSeparatorModel = chatItem as? TimeSeparatorModel else { fatalError() }
        return TimeSeparatorPresenter(timeSeparatorModel: timeSeparatorModel)
    }
    
    var presenterType: ChatItemPresenterProtocol.Type {
        return TimeSeparatorPresenter.self
    }
}
