//
//  CustomInputView.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import UIKit

final class CustomInputView: UIView {
    var onAction: ((String) -> Void)?
    
    private var label: UILabel!
    private var textField: UITextField!
    private var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func commonInit() {
        textField = createTextField()
        label = createLabel()
        button = createButton()
        
        [label, textField, button].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.heightAnchor.constraint(equalToConstant: 50.0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
        
            textField.leftAnchor.constraint(equalTo: leftAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50.0),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12.0),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12.0)
        ])
    }
    
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) { endEditing(true) }
    
    @objc
    private func onTap(_ sender: Any) {
        onAction?(textField.text ?? "Nothing to send")
        endEditing(true)
    }
}

// MARK: - Create Views

private extension CustomInputView {
    private func createTextField() -> UITextField {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.borderStyle = .roundedRect
            $0.text = "Try me"
            return $0
        }(UITextField(frame: .zero))
    }
    
    func createLabel() -> UILabel {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.textColor = UIColor(white: 0.15, alpha: 1.0)
            $0.text = "Just a custom content view with text field and button."
            return $0
        }(UILabel(frame: .zero))
    }
    
    func createButton() -> UIButton {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
            $0.setTitle("Send Message", for: .normal)
            return $0
        }(UIButton(type: .system))
    }
}
