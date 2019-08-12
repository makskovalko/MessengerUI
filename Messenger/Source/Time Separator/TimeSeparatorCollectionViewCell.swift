import Foundation
import UIKit
import Chatto

class TimeSeparatorCollectionViewCell: UICollectionViewCell {
    private lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label |> contentView.addSubview
    }

    var text: String = "" { didSet { (oldValue != text) => setTextOnLabel(text) } }

    private func setTextOnLabel(_ text: String) {
        label.text = text
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.bounds.size = label.sizeThatFits(contentView.bounds.size)
        label.center = contentView.center
    }
}
