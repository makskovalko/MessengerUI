import ChattoAdditions

final class DemoCompoundMessageViewModel: DecoratedMessageViewModelProtocol, DemoMessageViewModelProtocol {

    init(message: DemoCompoundMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.messageViewModel = messageViewModel
        self.messageModel = message
    }

    let messageViewModel: MessageViewModelProtocol
    let messageModel: DemoMessageModelProtocol
}

struct DemoCompoundMessageViewModelBuilder: ViewModelBuilderProtocol {
    init() {}

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    func createViewModel(_ message: DemoCompoundMessageModel) -> DemoCompoundMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(message)
        let compoundViewModel = DemoCompoundMessageViewModel(message: message,
                                                             messageViewModel: messageViewModel)
        compoundViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return compoundViewModel
    }

    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoCompoundMessageModel
    }
}
