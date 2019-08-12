import Foundation
import Chatto
import RxSwift

final class DemoChatDataSource {
    private var nextMessageId: Int = 0
    private let preferredMaxWindowSize = 500
    private var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    private let disposedBag = DisposeBag()
    
    init(count: Int, pageSize: Int) {
        slidingWindow = SlidingDataSource(
            count: count,
            pageSize: pageSize
        ) { [weak self] () -> ChatItemProtocol in
            guard let sSelf = self else {
                return DemoChatMessageFactory
                    .makeRandomMessage("")
            }
            defer { sSelf.nextMessageId += 1 }
            return DemoChatMessageFactory
                .makeRandomMessage("\(sSelf.nextMessageId)")
        }
    }

    init(messages: [ChatItemProtocol], pageSize: Int) {
        slidingWindow = SlidingDataSource(
            items: messages,
            pageSize: pageSize
        )
    }

    lazy var messageSender: DemoChatMessageSender = {
        let sender = DemoChatMessageSender()
        
        sender.onMessageChanged.subscribe(onNext: { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }).disposed(by: disposedBag)
        
        return sender
    }()
}

// MARK: -  ChatDataSourceProtocol Implementation

extension DemoChatDataSource: ChatDataSourceProtocol {
    var hasMoreNext: Bool { return slidingWindow.hasMore() }
    var hasMorePrevious: Bool { return slidingWindow.hasPrevious() }
    var chatItems: [ChatItemProtocol] { return slidingWindow.itemsInWindow }
    
    func loadNext() {
        slidingWindow.loadNext()
        slidingWindow.adjustWindow(
            focusPosition: 1,
            maxWindowSize: preferredMaxWindowSize
        )
        delegate?.chatDataSourceDidUpdate(
            self,
            updateType: .pagination
        )
    }
    
    func loadPrevious() {
        slidingWindow.loadPrevious()
        slidingWindow.adjustWindow(
            focusPosition: 0,
            maxWindowSize: preferredMaxWindowSize
        )
        delegate?.chatDataSourceDidUpdate(
            self,
            updateType: .pagination
        )
    }
    
    func addTextMessage(_ text: String) -> String {
        nextMessageId += 1
        let message = DemoChatMessageFactory.makeTextMessage(
            "\(nextMessageId)",
            text: text,
            isIncoming: false
        )
        messageSender.sendMessage(message)
        slidingWindow.insertItem(message, position: .bottom)
        delegate?.chatDataSourceDidUpdate(self)
        return text
    }
    
    func addPhotoMessage(_ image: UIImage) -> UIImage {
        nextMessageId += 1
        let message = DemoChatMessageFactory.makePhotoMessage(
            "\(nextMessageId)",
            image: image,
            size: image.size,
            isIncoming: false
        )
        messageSender.sendMessage(message)
        slidingWindow.insertItem(message, position: .bottom)
        delegate?.chatDataSourceDidUpdate(self)
        return image
    }
    
    func addRandomIncomingMessage() {
        let message = DemoChatMessageFactory.makeRandomMessage(
            "\(nextMessageId)",
            isIncoming: true
        )
        nextMessageId += 1
        slidingWindow.insertItem(
            message,
            position: .bottom
        )
        delegate?.chatDataSourceDidUpdate(self)
    }
    
    func adjustNumberOfMessages(
        preferredMaxCount: Int?,
        focusPosition: Double,
        completion: (_ didAdjust: Bool) -> Void
    ) {
        let didAdjust = slidingWindow.adjustWindow(
            focusPosition: focusPosition,
            maxWindowSize: preferredMaxCount ?? preferredMaxWindowSize
        )
        completion(didAdjust)
    }
    
    func replaceMessage(
        withUID uid: String,
        withNewMessage newMessage: ChatItemProtocol
    ) {
        let didUpdate = slidingWindow
            .replaceItem(withNewItem: newMessage) { $0.uid == uid }
        
        guard didUpdate else { return }
        delegate?.chatDataSourceDidUpdate(self)
    }
}
