import Foundation
import Chatto
import ChattoAdditions

final class DemoChatItemsDecorator: ChatItemsDecoratorProtocol {
    private struct Constants {
        static let shortSeparation: CGFloat = 3
        static let normalSeparation: CGFloat = 10
        static let timeIntervalThresholdToIncreaseSeparation: TimeInterval = 120
    }

    private let messagesSelector: MessagesSelectorProtocol
    
    init(messagesSelector: MessagesSelectorProtocol) {
        self.messagesSelector = messagesSelector
    }
    
    private func decoratedSendingChatItem(
        forMessage message: MessageModelProtocol
    ) -> DecoratedChatItem {
        return DecoratedChatItem(
            chatItem: SendingStatusModel(
                uid: "\(message.uid)-decoration-status",
                status: message.status
            ),
            decorationAttributes: nil
        )
    }
    
    private func decoratedTimeSeparatorChatItem(
        forMessage message: MessageModelProtocol
    ) -> DecoratedChatItem {
        return DecoratedChatItem(
            chatItem: TimeSeparatorModel(
                uid: "\(message.uid)-time-separator",
                date: message
                    .date
                    .toWeekDayAndDateString()
            ),
            decorationAttributes: nil
        )
    }
    
    func decoratedChatItem(
        _ chatItem: ChatItemProtocol,
        byIndex index: Int,
        chatItems: [ChatItemProtocol]
    ) -> [DecoratedChatItem] {
        guard let currentMessage = chatItem as? MessageModelProtocol else { return [] }
        
        let next: ChatItemProtocol? = index + 1 < chatItems.count
            ? chatItems[index + 1] : nil
        let prev: ChatItemProtocol? = index > 0
            ? chatItems[index - 1] : nil
        
        let bottomMargin = separationAfterItem(chatItem, next: next)
        
        let (showsTail, addTimeSeparator) = performCalculation(
            currentMessage: currentMessage,
            next: next,
            prev: prev
        )
        
        let messageDecorationAttributes = createMessageDecorationAttributes(
            isShowingTail: showsTail,
            currentMessage: currentMessage
        )
        
        func chatItemDecorationAttrs(
            from messageDecorationAttributes: BaseMessageDecorationAttributes
        ) -> ChatItemDecorationAttributes {
            return ChatItemDecorationAttributes(
                bottomMargin: bottomMargin,
                messageDecorationAttributes: messageDecorationAttributes
            )
        }
        
        func decoratedChatItem(
            from chatItemDecorationAttrs: ChatItemDecorationAttributes
        ) -> DecoratedChatItem {
            return DecoratedChatItem(
                chatItem: chatItem,
                decorationAttributes: chatItemDecorationAttrs
            )
        }
        
        var additionalItems = [DecoratedChatItem]()
        currentMessage |> showsStatusForMessage => {
            additionalItems += [
                currentMessage |> decoratedSendingChatItem
            ]
        }()
        
        return [
            addTimeSeparator
                ? currentMessage |> decoratedTimeSeparatorChatItem
                : nil,
            messageDecorationAttributes
                |> chatItemDecorationAttrs
                |> decoratedChatItem
            ].compactMap { $0 }
            + additionalItems
    }

    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        return chatItems
            .enumerated()
            .flatMap { [weak self] index, chatItem -> [DecoratedChatItem] in
                self?.decoratedChatItem(
                    chatItem,
                    byIndex: index,
                    chatItems: chatItems
                ) ?? []
        }
    }
    
    private func createMessageDecorationAttributes(
        isShowingTail: Bool,
        currentMessage: MessageModelProtocol
    ) -> BaseMessageDecorationAttributes {
        return BaseMessageDecorationAttributes(
            canShowFailedIcon: true,
            isShowingTail: isShowingTail,
            isShowingAvatar: isShowingTail,
            isShowingSelectionIndicator: messagesSelector.isActive
                && (currentMessage |> messagesSelector.canSelectMessage),
            isSelected: currentMessage |> messagesSelector.isMessageSelected
        )
    }

    private func separationAfterItem(
        _ current: ChatItemProtocol?,
        next: ChatItemProtocol?
    ) -> CGFloat {
        guard let nexItem = next else { return 0 }
        guard let currentMessage = current as? MessageModelProtocol,
            let nextMessage = nexItem as? MessageModelProtocol else {
                return Constants.normalSeparation
        }
        
        switch currentMessage {
        case _ where showsStatusForMessage(currentMessage):
            return 0
        case _ where currentMessage.senderId != nextMessage.senderId:
            return Constants.normalSeparation
        case _ where nextMessage
            .date
            .timeIntervalSince(currentMessage.date)
                > Constants.timeIntervalThresholdToIncreaseSeparation:
            return Constants.normalSeparation
        default:
            return Constants.shortSeparation
        }
    }
    
    private func performCalculation(
        currentMessage: MessageModelProtocol,
        next: ChatItemProtocol?,
        prev: ChatItemProtocol?
    ) -> (shouldShowsTail: Bool, shouldAddTimeSeparator: Bool) {
        let showsTail: Bool = {
            guard let nextMessage = next as? MessageModelProtocol else { return true }
            return currentMessage.senderId != nextMessage.senderId
        }()
        
        let addTimeSeparator: Bool = {
            guard let previousMessage = prev as? MessageModelProtocol else { return true }
            return !Calendar.current.isDate(
                currentMessage.date,
                inSameDayAs: previousMessage.date
            )
        }()
        
        return (showsTail, addTimeSeparator)
    }

    private func showsStatusForMessage(_ message: MessageModelProtocol) -> Bool {
        return ([.failed, .sending] as [MessageStatus]).contains(message.status)
    }
}
