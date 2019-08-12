import Foundation
import Chatto
import ChattoAdditions

public protocol DemoMessageModelProtocol: MessageModelProtocol {
    var status: MessageStatus { get set }
}

public final class DemoChatMessageSender {
    public var onMessageChanged: ((_ message: DemoMessageModelProtocol) -> Void)?

    public func sendMessages(_ messages: [DemoMessageModelProtocol]) {
        messages.forEach(fakeMessageStatus)
    }

    public func sendMessage(_ message: DemoMessageModelProtocol) {
        fakeMessageStatus(message)
    }

    private func fakeMessageStatus(_ message: DemoMessageModelProtocol) {
        func onFailed() {
            updateMessage(message, status: .sending)
            fakeMessageStatus(message)
        }
        
        func onSending() {
            arc4random_uniform(100) % 5 == 0
                ? updateMessage(
                    message,
                    status: arc4random_uniform(100) % 2 == 0
                        ? .failed
                        : .success
                    )
                : fakeMessageStatusAfterDelay(
                    withMessage: message
                )
        }
        
        switch message.status {
        case .success: break
        case .failed: onFailed()
        case .sending: onSending()
        }
    }

    private func updateMessage(
        _ message: DemoMessageModelProtocol,
        status: MessageStatus
    ) {
        guard message.status != status else { return }
        message.status = status
        notifyMessageChanged(message)
    }

    private func notifyMessageChanged(
        _ message: DemoMessageModelProtocol
    ) { onMessageChanged?(message) }
    
    private func fakeMessageStatusAfterDelay(
        withMessage message: DemoMessageModelProtocol
    ) {
        let delaySeconds = Double(arc4random_uniform(1200)) / 1000.0
        let delayTime = DispatchTime.now()
            + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fakeMessageStatus(message)
        }
    }
}
