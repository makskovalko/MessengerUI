import UIKit

final class SendingStatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    var text: NSAttributedString? { didSet { label.attributedText = text } }
}
