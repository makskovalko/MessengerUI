import UIKit

final class ChatViewController: DemoChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(
            title: "Add message",
            style: .plain,
            target: self,
            action: #selector(addRandomMessage)
        )
        navigationItem.rightBarButtonItem = button
    }

    @objc
    private func addRandomMessage() {
        addRandomIncomingMessage()
    }
}
