import ChattoAdditions

final class DemoCompoundMessageModel: Equatable, DecoratedMessageModelProtocol, DemoMessageModelProtocol {

    // MARK: - Instantiation

    init(text: String, image: UIImage?, messageModel: MessageModelProtocol) {
        self.text = text
        self.image = image
        self.messageModel = messageModel
        self.status = messageModel.status
    }

    // MARK: - Public properties

    let text: String
    let image: UIImage?

    // MARK: - DecoratedMessageModelProtocol

    let messageModel: MessageModelProtocol

    // MARK: - DemoMessageModelProtocol

    var status: MessageStatus

    // MARK: - Equatable

    static func == (lhs: DemoCompoundMessageModel, rhs: DemoCompoundMessageModel) -> Bool {
        return lhs.text == rhs.text
            && lhs.image == rhs.image
            && lhs.messageModel.uid == rhs.messageModel.uid
            && lhs.status == rhs.status
    }
}
