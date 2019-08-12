import UIKit
import Chatto
import ChattoAdditions

class DemoChatViewController: BaseChatViewController {
    var shouldUseAlternativePresenter: Bool = false

    var messageSender: DemoChatMessageSender!
    var chatInputPresenter: AnyObject!
    let messagesSelector = BaseMessagesSelector()

    var dataSource: DemoChatDataSource! {
        didSet {
            chatDataSource = dataSource
            messageSender = dataSource.messageSender
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(
            messageSender: messageSender,
            messagesSelector: messagesSelector
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
        messagesSelector.delegate = self
        chatItemsDecorator = DemoChatItemsDecorator(
            messagesSelector: messagesSelector
        )
    }
    
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString(
            "Send",
            comment: ""
        )
        appearance.textInputAppearance.placeholderText = NSLocalizedString(
            "Type a message",
            comment: ""
        )
        
        if shouldUseAlternativePresenter {
            let chatInputPresenter = ExpandableChatInputBarPresenter(
                inputPositionController: self,
                chatInputBar: chatInputView,
                chatInputItems: createChatInputItems(),
                chatInputBarAppearance: appearance)
            self.chatInputPresenter = chatInputPresenter
            self.keyboardEventsHandler = chatInputPresenter
            self.scrollViewEventsHandler = chatInputPresenter
        } else {
            chatInputPresenter = BasicChatInputBarPresenter(
                chatInputBar: chatInputView,
                chatInputItems: createChatInputItems(),
                chatInputBarAppearance: appearance
            )
        }
        
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()

        let compoundPresenterBuilder = CompoundMessagePresenterBuilder(
            viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
            interactionHandler: GenericMessageHandler(baseHandler: self.baseMessageHandler),
            accessibilityIdentifier: nil,
            contentFactories: [
                .init(DemoTextMessageContentFactory()),
                .init(DemoImageMessageContentFactory()),
                .init(DemoDateMessageContentFactory())
            ],
            compoundCellDimensions: .defaultDimensions,
            baseCellStyle: BaseMessageCollectionViewCellAvatarStyle()
        )

        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
            ChatItemType.compoundItemType: [compoundPresenterBuilder]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(createTextInputItem())
        
        items.append(createPhotoInputItem())
        if shouldUseAlternativePresenter {
            items.append(customInputItem())
        }
        
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image, _ in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }

    private func customInputItem() -> ContentAwareInputItem {
        let item = ContentAwareInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
}

extension DemoChatViewController: MessagesSelectorDelegate {
    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didSelectMessage: MessageModelProtocol
    ) { enqueueModelUpdate(updateType: .normal) }

    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didDeselectMessage: MessageModelProtocol
    ) { enqueueModelUpdate(updateType: .normal) }
}

extension CompoundBubbleLayoutProvider.Dimensions {
    static var defaultDimensions: CompoundBubbleLayoutProvider.Dimensions {
        return .init(
            spacing: 8,
            contentInsets: .init(
                top: 8,
                left: 8,
                bottom: 8,
                right: 8
            )
        )
    }
}
