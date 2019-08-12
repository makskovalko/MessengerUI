//
//  ImagePreviewViewController.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/12/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import UIKit

final class ImagePreviewViewController: UIViewController {
    private let imageModel: DemoPhotoMessageModel
    private var pinchGesture = UIPinchGestureRecognizer()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(imageModel: DemoPhotoMessageModel) {
        self.imageModel = imageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Preview"
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        setupConstraints()
        
        imageView.image = imageModel.image
        
        pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinchedView)
        )
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension ImagePreviewViewController: UIGestureRecognizerDelegate {
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        view.bringSubviewToFront(imageView)
        sender.view?.transform = sender
            .view?
            .transform
            .scaledBy(
                x: sender.scale,
                y: sender.scale
            ) ?? .identity
        sender.scale = 1.0
    }
}
