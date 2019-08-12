import UIKit
import Chatto
import RxSwift
import RxCocoa

private extension TimeSeparatorPresenter {
    enum Constants {
        static let cellReuseIdentifier = TimeSeparatorCollectionViewCell.self.description()
        static let cellHeight: CGFloat = 24
    }
}

final class TimeSeparatorPresenter {
    private let timeSeparatorModel: TimeSeparatorModel
    
    init (timeSeparatorModel: TimeSeparatorModel) {
        self.timeSeparatorModel = timeSeparatorModel
    }
}

extension TimeSeparatorPresenter: ChatItemPresenterProtocol {
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(
            TimeSeparatorCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.cellReuseIdentifier
        )
    }
    
    func dequeueCell(
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellReuseIdentifier,
            for: indexPath
        )
    }
    
    func configureCell(
        _ cell: UICollectionViewCell,
        decorationAttributes: ChatItemDecorationAttributesProtocol?
    ) {
        (cell as? TimeSeparatorCollectionViewCell)?.text = timeSeparatorModel.date
    }
    
    var canCalculateHeightInBackground: Bool { return true }
    
    func heightForCell(
        maximumWidth width: CGFloat,
        decorationAttributes: ChatItemDecorationAttributesProtocol?
    ) -> CGFloat { return Constants.cellHeight }
}
