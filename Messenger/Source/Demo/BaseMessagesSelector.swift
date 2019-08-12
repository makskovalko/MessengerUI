import ChattoAdditions

final class BaseMessagesSelector: MessagesSelectorProtocol {
    weak var delegate: MessagesSelectorDelegate?
    
    private var selectedMessagesDictionary = [String: MessageModelProtocol]()

    var isActive = false {
        didSet {
            guard oldValue != isActive, isActive else { return }
            selectedMessagesDictionary.removeAll()
        }
    }

    func canSelectMessage(_ message: MessageModelProtocol) -> Bool {
        return true
    }

    func isMessageSelected(_ message: MessageModelProtocol) -> Bool {
        return selectedMessagesDictionary[message.uid] != nil
    }

    func selectMessage(_ message: MessageModelProtocol) {
        selectedMessagesDictionary[message.uid] = message
        delegate?.messagesSelector(self, didSelectMessage: message)
    }

    func deselectMessage(_ message: MessageModelProtocol) {
        selectedMessagesDictionary[message.uid] = nil
        delegate?.messagesSelector(self, didDeselectMessage: message)
    }

    func selectedMessages() -> [MessageModelProtocol] {
        return Array(selectedMessagesDictionary.values)
    }
}
