//
//  ProfileController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit

class ProfileController: BaseController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(resource: .igBackground)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ProfilePostCell.self, forCellWithReuseIdentifier: ProfilePostCell.identifier)
        cv.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.identifier
        )
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let viewModel = ProfileViewModel()
    weak var coordinator: MainCoordinator?
    
    override func configureUI() {
        title = "Profile"
    }
    
    override func configureConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func configureViewModel() {
        viewModel.onUserLoaded = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onPostsLoaded = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            let alert = AlertBuilder()
                .setTitle("Hata")
                .setMessage(error.userFriendlyMessage)
                .setPrimaryButton("Tamam")
                .build()
            self?.present(alert, animated: true)
        }
        
        viewModel.fetchProfile()
    }
}

extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePostCell.identifier, for: indexPath) as? ProfilePostCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.posts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView else {
            return UICollectionReusableView()
        }
        if let user = viewModel.user {
            header.configure(with: user, postCount: viewModel.posts.count)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}
