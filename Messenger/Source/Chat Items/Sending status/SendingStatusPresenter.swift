import UIKit
import Chatto

final class SendingStatusPresenter {
    private let statusModel: SendingStatusModel
    
    init (statusModel: SendingStatusModel) {
        self.statusModel = statusModel
    }
}

extension SendingStatusPresenter: ChatItemPresenterProtocol {
    static func registerCells(
        _ collectionView: UICollectionView
        ) {
        collectionView.register(
            UINib(
                nibName: "SendingStatusCollectionViewCell",
                bundle: Bundle(for: self)
            ),
            forCellWithReuseIdentifier: "SendingStatusCollectionViewCell"
        )
    }
    
    func dequeueCell(
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: "SendingStatusCollectionViewCell",
            for: indexPath
        )
    }
    
    func configureCell(
        _ cell: UICollectionViewCell,
        decorationAttributes: ChatItemDecorationAttributesProtocol?
    ) {
        guard let statusCell = cell as? SendingStatusCollectionViewCell else {
            fatalError("expecting status cell")
        }
        
        let attrs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0),
            NSAttributedString.Key.foregroundColor: self.statusModel.status == .failed
                ? UIColor.red
                : UIColor.black
        ]
        
        statusCell.text = NSAttributedString(
            string: statusText(),
            attributes: attrs)
    }
    
    func statusText() -> String {
        switch self.statusModel.status {
        case .failed:
            return NSLocalizedString("Sending failed", comment: "")
        case .sending:
            return NSLocalizedString("Sending...", comment: "")
        default:
            return ""
        }
    }
    
    func heightForCell(
        maximumWidth width: CGFloat,
        decorationAttributes: ChatItemDecorationAttributesProtocol?
    ) -> CGFloat { return 19 }
    
    var canCalculateHeightInBackground: Bool { return true }
}
