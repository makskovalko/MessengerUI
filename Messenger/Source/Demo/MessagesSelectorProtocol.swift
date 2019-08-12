import ChattoAdditions

public protocol MessagesSelectorDelegate: class {
    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didSelectMessage: MessageModelProtocol
    )
    func messagesSelector(
        _ messagesSelector: MessagesSelectorProtocol,
        didDeselectMessage: MessageModelProtocol
    )
}

public protocol MessagesSelectorProtocol: class {
    var delegate: MessagesSelectorDelegate? { get set }
    var isActive: Bool { get set }
    func canSelectMessage(_ message: MessageModelProtocol) -> Bool
    func isMessageSelected(_ message: MessageModelProtocol) -> Bool
    func selectMessage(_ message: MessageModelProtocol)
    func deselectMessage(_ message: MessageModelProtocol)
    func selectedMessages() -> [MessageModelProtocol]
}
