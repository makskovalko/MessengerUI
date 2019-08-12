import UIKit
import Chatto
import ChattoAdditions

class DemoChatViewController: BaseChatViewController {
    private let viewModel: DemoChatViewModelProtocol
    private let messageSender: DemoChatMessageSender
    private let messagesSelector: MessagesSelectorProtocol
    private let dataSource: DemoChatDataSource
    private let baseMessageHandler: BaseMessageHandler
    private let chatItemPresenterBuilders: [ChatItemType: [ChatItemPresenterBuilderProtocol]]
    private var chatInputPresenter: AnyObject!
    
    init(viewModel: DemoChatViewModelProtocol,
         messagesSelector: MessagesSelectorProtocol,
         dataSource: DemoChatDataSource,
         chatItemsDecorator: ChatItemsDecoratorProtocol?,
         messageSender: DemoChatMessageSender,
         baseMessageHandler: BaseMessageHandler,
         chatItemPresenterBuilders: [ChatItemType: [ChatItemPresenterBuilderProtocol]]
    ) {
        self.viewModel = viewModel
        self.messagesSelector = messagesSelector
        self.dataSource = dataSource
        self.messageSender = messageSender
        self.baseMessageHandler = baseMessageHandler
        self.chatItemPresenterBuilders = chatItemPresenterBuilders
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatItemsDecorator = chatItemsDecorator
        self.chatDataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
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
        chatInputPresenter = BasicChatInputBarPresenter(
            chatInputBar: chatInputView,
            chatInputItems: createChatInputItems(),
            chatInputBarAppearance: appearance
        )
        
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        return chatItemPresenterBuilders
    }

    func addRandomIncomingMessage() {
        viewModel
            .onRandomIncomingMessage
            .onNext(dataSource.addRandomIncomingMessage())
    }
}

// MARK: - Create Input Items

private extension DemoChatViewController {
    func createChatInputItems() -> [ChatInputItemProtocol] {
        return [createTextInputItem(), createPhotoInputItem()]
    }
    
    func createPhotoInputItem() -> ChatInputItemProtocol {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [unowned self] image, resource in
            self.viewModel
                .onImageMessageAdded
                .onNext(self.dataSource.addPhotoMessage(image))
        }
        return item
    }
    
    func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        
        item.textInputHandler = { [unowned self] text in
            self.viewModel
                .onTextMessageAdded
                .onNext(self.dataSource.addTextMessage(text))
        }
        return item
    }
    
    func customInputItem() -> ContentAwareInputItem {
        let item = ContentAwareInputItem()
        item.textInputHandler = { [unowned self] text in
            self.viewModel
                .onTextMessageAdded
                .onNext(self.dataSource.addTextMessage(text))
        }
        return item
    }
}

// MARK: - Message Selector Delegate

extension DemoChatViewController: MessagesSelectorDelegate {
    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didSelectMessage: MessageModelProtocol
    ) {
        guard let messageModel = didSelectMessage
            as? DemoPhotoMessageModel else { return }
        viewModel
            .onDidSelectMessage
            .onNext(messageModel |> viewModel.showImagePreview)
    }

    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didDeselectMessage: MessageModelProtocol
    ) {
        viewModel
            .onDidDeselectMessage
            .onNext(enqueueModelUpdate(updateType: .normal))
    }
}

// MARK: - Dimensions

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
