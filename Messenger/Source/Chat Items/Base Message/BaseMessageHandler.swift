import Foundation
import Chatto
import ChattoAdditions

public protocol DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol { get }
}

class BaseMessageHandler {
    private let messageSender: DemoChatMessageSender
    private let messagesSelector: MessagesSelectorProtocol

    init(messageSender: DemoChatMessageSender, messagesSelector: MessagesSelectorProtocol) {
        self.messageSender = messageSender
        self.messagesSelector = messagesSelector
    }
    func userDidTapOnFailIcon(viewModel: DemoMessageViewModelProtocol) {
        print("userDidTapOnFailIcon")
        messageSender.sendMessage(viewModel.messageModel)
    }

    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
        print("userDidTapOnAvatar")
    }

    func userDidTapOnBubble(viewModel: DemoMessageViewModelProtocol) {
        guard viewModel.messageModel.type == "photo" else { return }
        messagesSelector.selectMessage(viewModel.messageModel)
    }

    func userDidBeginLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidBeginLongPressOnBubble")
    }

    func userDidEndLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidEndLongPressOnBubble")
    }

    func userDidSelectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidSelectMessage")
        messagesSelector.selectMessage(viewModel.messageModel)
    }

    func userDidDeselectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidDeselectMessage")
        messagesSelector.deselectMessage(viewModel.messageModel)
    }
}
