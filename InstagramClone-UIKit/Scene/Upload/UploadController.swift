//
//  UploadControlller.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit
import Photos

class UploadController: BaseController {
    
    private lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 15)
        tv.textColor = UIColor(resource: .igText)
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var captionPlaceholderLabel: UILabel = {
        let l = UILabel()
        l.text = "Write a caption..."
        l.font = .systemFont(ofSize: 15)
        l.textColor = .placeholderText
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(resource: .igBorder)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var recentLabel: UILabel = {
        let l = UILabel()
        l.text = "Recent"
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .systemBackground
        cv.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: PhotoGalleryCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private lazy var permissionDeniedView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let l = UILabel()
        l.text = "Fotoğraflara erişim izni gerekli"
        l.font = .systemFont(ofSize: 15, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        
        let btn = UIButton(type: .system)
        btn.setTitle("Ayarları Aç", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.tintColor = .systemBlue
        btn.addTarget(self, action: #selector(openSettingsTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let sv = UIStackView(arrangedSubviews: [l, btn])
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        v.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
        
        return v
    }()
    
    private let viewModel = UploadViewModel()
    private var phAssets: [PHAsset] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    override func configureUI() {
        title = "New Post"
        captionTextView.delegate = self
        configureNavigationBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        galleryCollectionView.addGestureRecognizer(tap)
    }
    
    override func configureConstraints() {
        view.addSubview(thumbnailImageView)
        view.addSubview(captionTextView)
        captionTextView.addSubview(captionPlaceholderLabel)
        view.addSubview(separatorView)
        view.addSubview(recentLabel)
        view.addSubview(galleryCollectionView)
        view.addSubview(permissionDeniedView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            captionTextView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            captionTextView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            captionTextView.heightAnchor.constraint(equalToConstant: 80),
            
            captionPlaceholderLabel.topAnchor.constraint(equalTo: captionTextView.topAnchor, constant: 0),
            captionPlaceholderLabel.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor, constant: 8),
            
            separatorView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            recentLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            recentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            galleryCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 8),
            galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            permissionDeniedView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            permissionDeniedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            permissionDeniedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionDeniedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func configureViewModel() {
        viewModel.onUploadSuccess = { [weak self] in
            self?.resetForm()
            self?.tabBarController?.selectedIndex = 0
        }
        
        viewModel.onUploadError = { [weak self] error in
            let alert = AlertBuilder()
                .setTitle("Hata")
                .setMessage(error.userFriendlyMessage)
                .setPrimaryButton("Tamam")
                .build()
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                let loader = UIBarButtonItem(customView: self.loadingIndicator)
                self.navigationItem.rightBarButtonItem = loader
                self.loadingIndicator.startAnimating()
            } else {
                self.configureNavigationBar()
            }
            self.view.isUserInteractionEnabled = !isLoading
        }
        
        updateShareButtonState()
        fetchGalleryPhotos()
    }
    
    private func configureNavigationBar() {
        let shareButton = UIBarButtonItem(
            title: "Share",
            style: .done,
            target: self,
            action: #selector(shareTapped)
        )
        shareButton.tintColor = UIColor(resource: .igPurple)
        shareButton.isEnabled = viewModel.selectedImageData != nil
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func updateShareButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.selectedImageData != nil
    }
    
    @objc private func shareTapped() {
        viewModel.caption = captionTextView.text ?? ""
        viewModel.uploadPost()
    }
    
    @objc private func openSettingsTapped() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func resetForm() {
        thumbnailImageView.image = nil
        captionTextView.text = ""
        captionPlaceholderLabel.isHidden = false
        viewModel.selectedImageData = nil
        viewModel.caption = ""
        updateShareButtonState()
    }
    
    private func fetchGalleryPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.loadPhotos()
                default:
                    self?.showPermissionDenied()
                }
            }
        }
    }
    
    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var fetchedAssets: [PHAsset] = []
        assets.enumerateObjects { asset, _, _ in
            fetchedAssets.append(asset)
        }
        
        phAssets = fetchedAssets
        galleryCollectionView.reloadData()
        
        if let firstAsset = fetchedAssets.first {
            selectPhoto(asset: firstAsset)
            galleryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    private func showPermissionDenied() {
        recentLabel.isHidden = true
        galleryCollectionView.isHidden = true
        permissionDeniedView.isHidden = false
    }
    
    private func selectPhoto(asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
                self?.viewModel.selectedImageData = image?.jpegData(compressionQuality: 0.75)
                self?.updateShareButtonState()
            }
        }
    }
}

extension UploadController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return phAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.identifier, for: indexPath) as? PhotoGalleryCell else {
            return UICollectionViewCell()
        }
        
        let asset = phAssets[indexPath.item]
        let size = CGSize(width: 150, height: 150)
        
        let requestID = PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: nil
        ) { image, _ in
            DispatchQueue.main.async {
                cell.configure(image: image)
            }
        }
        cell.tag = Int(requestID)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = phAssets[indexPath.item]
        selectPhoto(asset: asset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}

extension UploadController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        captionPlaceholderLabel.isHidden = !textView.text.isEmpty
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

