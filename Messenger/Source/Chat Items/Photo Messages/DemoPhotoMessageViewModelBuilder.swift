//
//  DemoPhotoMessageViewModelBuilder.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import ChattoAdditions

final class DemoPhotoMessageViewModelBuilder: ViewModelBuilderProtocol {
    private let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    func createViewModel(_ model: DemoPhotoMessageModel) -> DemoPhotoMessageViewModel {
        let messageViewModel = messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = DemoPhotoMessageViewModel(
            photoMessage: model,
            messageViewModel: messageViewModel
        )
        photoMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return photoMessageViewModel
    }
    
    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoPhotoMessageModel
    }
}
