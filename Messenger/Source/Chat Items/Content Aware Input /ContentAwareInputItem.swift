import ChattoAdditions

final class ContentAwareInputItem {
    var textInputHandler: ((String) -> Void)?

    private let buttonAppearance: TabInputButtonAppearance
    
    init(
        tabInputButtonAppearance: TabInputButtonAppearance
            = ContentAwareInputItem.createDefaultButtonAppearance()
    ) {
        buttonAppearance = tabInputButtonAppearance
        customInputView.onAction = { [weak self] text in
            self?.textInputHandler?(text)
        }
    }

    private var customInputView: CustomInputView = {
        return CustomInputView(frame: .zero)
    }()
    
    fileprivate lazy var internalTabView: TabInputButton = {
        return TabInputButton.makeInputButton(
            withAppearance: buttonAppearance,
            accessibilityID: "text.chat.input.view"
        )
    }()

    var selected = false {
        didSet { internalTabView.isSelected = selected }
    }
}

extension ContentAwareInputItem {
    static func createDefaultButtonAppearance() -> TabInputButtonAppearance {
        let images: [UIControlStateWrapper: UIImage] = [
            UIControlStateWrapper(state: .normal): UIImage(
                named: "custom-icon-unselected",
                in: Bundle(for: ContentAwareInputItem.self),
                compatibleWith: nil
            )!,
            UIControlStateWrapper(state: .selected): UIImage(
                named: "custom-icon-selected",
                in: Bundle(for: ContentAwareInputItem.self),
                compatibleWith: nil
            )!,
            UIControlStateWrapper(state: .highlighted): UIImage(
                named: "custom-icon-selected",
                in: Bundle(for: ContentAwareInputItem.self),
                compatibleWith: nil
            )!
        ]
        return TabInputButtonAppearance(
            images: images,
            size: nil
        )
    }
}

// MARK: - ChatInputItemProtocol

extension ContentAwareInputItem: ChatInputItemProtocol {
    var shouldSaveDraftMessage: Bool { return false }
    var supportsExpandableState: Bool { return true }
    var expandedStateTopMargin: CGFloat { return 140.0 }
    var presentationMode: ChatInputItemPresentationMode { return .customView }
    var showsSendButton: Bool { return false }
    var inputView: UIView? { return customInputView }
    var tabView: UIView { return internalTabView }

    func handleInput(_ input: AnyObject) {
        guard let text = input as? String else { return }
        textInputHandler?(text)
    }
}
