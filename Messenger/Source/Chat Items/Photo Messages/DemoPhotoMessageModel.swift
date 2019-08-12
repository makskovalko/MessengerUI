import ChattoAdditions

final class DemoPhotoMessageModel: PhotoMessageModel<MessageModel>, DemoMessageModelProtocol {
    override init(
        messageModel: MessageModel,
        imageSize: CGSize,
        image: UIImage
    ) {
        super.init(
            messageModel: messageModel,
            imageSize: imageSize,
            image: image
        )
    }

    var status: MessageStatus {
        get { return self._messageModel.status }
        set { self._messageModel.status = newValue }
    }
}
