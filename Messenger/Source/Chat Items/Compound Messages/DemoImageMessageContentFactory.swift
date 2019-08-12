import UIKit
import Chatto
import ChattoAdditions

struct DemoImageMessageContentFactory: MessageContentFactoryProtocol {
    func canCreateMessageContent(forModel model: DemoCompoundMessageModel) -> Bool {
        return model.image != nil
    }

    func createContentView() -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }

    func createContentPresenter(
        forModel model: DemoCompoundMessageModel
    ) -> MessageContentPresenterProtocol {
        return DefaultMessageContentPresenter<DemoCompoundMessageModel, UIImageView>(
            message: model,
            showBorder: false,
            onBinding: { message, imageView in
                imageView?.image = message.image
            }
        )
    }

    func createLayoutProvider(
        forModel model: DemoCompoundMessageModel
    ) -> MessageManualLayoutProviderProtocol {
        guard let image = model.image else { preconditionFailure() }
        return ImageMessageLayoutProvider(
            imageSize: image.size,
            ignoreContentInsets: true
        )
    }

    func createMenuPresenter(
        forModel model: DemoCompoundMessageModel
    ) -> ChatItemMenuPresenterProtocol? {
        return nil
    }
}
