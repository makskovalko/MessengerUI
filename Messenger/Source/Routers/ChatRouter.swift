//
//  ChatRouter.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/12/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import UIKit

protocol ChatRouting: AnyObject {
    func showImagePreview(withModel model: DemoPhotoMessageModel)
}

final class ChatRouter: ChatRouting {
    private weak var context: ChatViewController?
    
    init(context: ChatViewController?) {
        self.context = context
    }
    
    func showImagePreview(withModel model: DemoPhotoMessageModel) {
        context?.navigationController?.pushViewController(
            model |> ImagePreviewViewController.init,
            animated: true
        )
    }
}
