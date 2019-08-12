//
//  DemoChatViewModel.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/12/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import RxSwift

protocol DemoChatViewModelProtocol: AnyObject {
    var onRandomIncomingMessage: PublishSubject<Void> { get }
    var onTextMessageAdded: PublishSubject<String> { get }
    var onImageMessageAdded: PublishSubject<UIImage> { get }
    var onDidSelectMessage: PublishSubject<Void> { get }
    var onDidDeselectMessage: PublishSubject<Void> { get }
    
    func showImagePreview(model: DemoPhotoMessageModel)
}

final class DemoChatViewModel: DemoChatViewModelProtocol {
    var router: ChatRouting!
    
    var onRandomIncomingMessage: PublishSubject<Void> {
        return PublishSubject<Void>()
    }
    
    var onTextMessageAdded: PublishSubject<String> {
        return PublishSubject<String>()
    }
    
    var onImageMessageAdded: PublishSubject<UIImage> {
        return PublishSubject<UIImage>()
    }
    
    var onDidSelectMessage: PublishSubject<Void> {
        return PublishSubject<Void>()
    }
    
    var onDidDeselectMessage: PublishSubject<Void> {
        return PublishSubject<Void>()
    }
    
    func showImagePreview(model: DemoPhotoMessageModel) {
        router.showImagePreview(withModel: model)
    }
}
