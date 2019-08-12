import Foundation
import ChattoAdditions

final class DemoPhotoMessageViewModel: PhotoMessageViewModel<DemoPhotoMessageModel> {
    private let fakeImage: UIImage
    
    override init(
        photoMessage: DemoPhotoMessageModel,
        messageViewModel: MessageViewModelProtocol
    ) {
        fakeImage = photoMessage.image
        super.init(
            photoMessage: photoMessage,
            messageViewModel: messageViewModel
        )
        
        guard !photoMessage.isIncoming else { return }
        image.value = nil
    }

    override func willBeShown() { fakeProgress() }

    func fakeProgress() {
        let statuses = [.success, .failed] as [TransferStatus]
        if statuses.contains(transferStatus.value) { return }
        
        
        if self.transferProgress.value >= 1.0 {
            if arc4random_uniform(100) % 2 == 0 {
                transferStatus.value = .success
                image.value = fakeImage
            } else {
                transferStatus.value = .failed
            }
            return
        }
        
        transferStatus.value = .transfering
        
        let delaySeconds: Double = Double(arc4random_uniform(600)) / 1000.0
        let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            guard let sSelf = self else { return }
            let deltaProgress = Double(arc4random_uniform(15)) / 100.0
            sSelf.transferProgress.value = min(sSelf.transferProgress.value + deltaProgress, 1)
            sSelf.fakeProgress()
        }
    }
}

extension DemoPhotoMessageViewModel: DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol { return _photoMessage }
}
