//
//  ModulesAssembly.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/12/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

final class ModulesAssembly {
    static func createChatViewController() -> UIViewController {
        let messageSelector = BaseMessagesSelector()
        
        let dataSource = DemoChatDataSource(
            count: Constants.Chat.messageCount,
            pageSize: Constants.Chat.pageSize
        )
        
        let messageHandler = BaseMessageHandler(
            messageSender: dataSource.messageSender,
            messagesSelector: messageSelector
        )
        
        let viewModel = DemoChatViewModel()
        
        let viewController = ChatViewController(
            viewModel: viewModel,
            messagesSelector: messageSelector,
            dataSource: dataSource,
            chatItemsDecorator: messageSelector
                |> DemoChatItemsDecorator.init,
            messageSender: dataSource.messageSender,
            baseMessageHandler: messageHandler,
            chatItemPresenterBuilders: messageHandler
                |> createChatItemPresenterBuilders
        )
        
        viewModel.router = (viewController |> ChatRouter.init)
        
        messageSelector.delegate = viewController
        return viewController
    }
    
    static func createChatItemPresenterBuilders(
        baseMessageHandler: BaseMessageHandler
    ) -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        var textMessagePresenter: ChatItemPresenterBuilderProtocol {
            let textMessagePresenter = TextMessagePresenterBuilder(
                viewModelBuilder: DemoTextMessageViewModelBuilder(),
                interactionHandler: GenericMessageHandler(baseHandler: baseMessageHandler)
            )
            textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellDefaultStyle()
            return textMessagePresenter
        }
        
        var photoMessagePresenter: ChatItemPresenterBuilderProtocol {
            let photoMessagePresenter = PhotoMessagePresenterBuilder(
                viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
                interactionHandler: GenericMessageHandler(baseHandler: baseMessageHandler)
            )
            photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellDefaultStyle()
            return photoMessagePresenter
        }
        
        var compoundPresenterBuilder: ChatItemPresenterBuilderProtocol {
            return CompoundMessagePresenterBuilder(
                viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
                interactionHandler: GenericMessageHandler(baseHandler: baseMessageHandler),
                accessibilityIdentifier: nil,
                contentFactories: [
                    .init(DemoTextMessageContentFactory()),
                    .init(DemoImageMessageContentFactory()),
                    .init(DemoDateMessageContentFactory())
                ],
                compoundCellDimensions: .defaultDimensions,
                baseCellStyle: BaseMessageCollectionViewCellDefaultStyle()
            )
        }
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
            ChatItemType.compoundItemType: [compoundPresenterBuilder]
        ]
    }
}
