import UIKit
import Chatto
import ChattoAdditions

struct DemoTextMessageContentFactory: MessageContentFactoryProtocol {
    private let font = UIFont.systemFont(ofSize: 17)
    private let textInsets = UIEdgeInsets.zero

    func canCreateMessageContent(forModel model: DemoCompoundMessageModel) -> Bool {
        return true
    }

    func createContentView() -> UIView {
        let label = LabelWithInsets()
        label.numberOfLines = 0
        label.font = self.font
        label.textInsets = self.textInsets
        return label
    }

    func createContentPresenter(
        forModel model: DemoCompoundMessageModel
    ) -> MessageContentPresenterProtocol {
        return DefaultMessageContentPresenter<DemoCompoundMessageModel, LabelWithInsets>(
            message: model,
            showBorder: false,
            onBinding: { message, label in
                label?.text = message.text
                label?.textColor = message.isIncoming ? .black : .white
            }
        )
    }

    func createLayoutProvider(
        forModel model: DemoCompoundMessageModel
    ) -> MessageManualLayoutProviderProtocol {
        return TextMessageLayoutProvider(
            text: model.text,
            font: font,
            textInsets: textInsets
        )
    }

    func createMenuPresenter(
        forModel model: DemoCompoundMessageModel
    ) -> ChatItemMenuPresenterProtocol? { return nil }
}

private final class LabelWithInsets: UILabel {
    var textInsets: UIEdgeInsets = .zero
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets + safeAreaInsets))
    }
}

private func + (
    lhs: UIEdgeInsets,
    rhs: UIEdgeInsets
) -> UIEdgeInsets {
    return UIEdgeInsets(
        top: lhs.top + rhs.top,
        left: lhs.left + rhs.left,
        bottom: lhs.bottom + rhs.bottom,
        right: lhs.right + rhs.right
    )
}
