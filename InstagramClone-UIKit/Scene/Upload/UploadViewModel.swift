//
//  UploadViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 29.03.26.
//

import Foundation

class UploadViewModel {
    
    var caption: String = ""
    var selectedImageData: Data?
    
    var onUploadSuccess: (() -> Void)?
    var onUploadError: ((AppError) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private let repository: PostRepository
    
    init(repository: PostRepository = FirebasePostRepository()) {
        self.repository = repository
    }
    
    func uploadPost() {
        guard let imageData = selectedImageData else {
            onUploadError?(.imageConversionFailed)
            return
        }
        
        onLoading?(true)
        
        repository.uploadPost(imageData: imageData, caption: caption) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success:
                    self?.onUploadSuccess?()
                case .failure(let error):
                    self?.onUploadError?(error)
                }
            }
        }
    }
}

