//
//  SearchController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit

class SearchController: BaseController {
    
    private lazy var exploreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(resource: .igBackground)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ExplorePhotoCell.self, forCellWithReuseIdentifier: ExplorePhotoCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var paginationIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    private lazy var resultsTableView: UITableView = {
        let t = UITableView()
        t.dataSource = self
        t.backgroundColor = UIColor(resource: .igBackground)
        t.separatorStyle = .none
        t.rowHeight = 64
        t.register(UserSearchCell.self, forCellReuseIdentifier: UserSearchCell.identifier)
        t.isHidden = true
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let l = UILabel()
        l.text = "No users found"
        l.font = .systemFont(ofSize: 15)
        l.textColor = UIColor(resource: .igPlaceHolder)
        l.textAlignment = .center
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let viewModel = SearchViewModel()
    weak var coordinator: MainCoordinator?
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        title = "Search"
        setupSearchController()
    }
    
    override func configureConstraints() {
        view.addSubview(exploreCollectionView)
        view.addSubview(paginationIndicator)
        view.addSubview(resultsTableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            exploreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exploreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exploreCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            paginationIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paginationIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func configureViewModel() {
        viewModel.onPhotosUpdated = { [weak self] in
            self?.exploreCollectionView.reloadData()
        }
        
        viewModel.onLoadingMore = { [weak self] isLoading in
            isLoading ? self?.paginationIndicator.startAnimating()
            : self?.paginationIndicator.stopAnimating()
        }
        
        viewModel.onSearchResultsUpdated = { [weak self] in
            guard let self else { return }
            self.resultsTableView.reloadData()
            let isEmpty = self.viewModel.searchResults.isEmpty && self.isSearchActive
            self.emptyStateLabel.isHidden = !isEmpty
        }
        
        viewModel.onError = { [weak self] error in
            let alert = AlertBuilder()
                .setTitle("Hata")
                .setMessage(error.userFriendlyMessage)
                .setPrimaryButton("Tamam")
                .build()
            self?.present(alert, animated: true)
        }
        
        viewModel.fetchExplorePhotos()
    }
    
    private func setupSearchController() {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search users..."
        navigationItem.searchController = sc
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func showExplore() {
        isSearchActive = false
        resultsTableView.isHidden = true
        emptyStateLabel.isHidden = true
        exploreCollectionView.isHidden = false
    }
    
    private func showSearchResults() {
        isSearchActive = true
        exploreCollectionView.isHidden = true
        resultsTableView.isHidden = false
    }
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.explorePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePhotoCell.identifier, for: indexPath) as? ExplorePhotoCell else {
            return UICollectionViewCell()
        }
        cell.configure(photo: viewModel.explorePhotos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //grid size for photos one big others small
        let totalWidth = collectionView.bounds.width
        let smallSize = (totalWidth - 2) / 3
        let largeSize = smallSize * 2 + 1
        
        let groupIndex = indexPath.item / 5
        let positionInGroup = indexPath.item % 5
        let isLarge = groupIndex % 2 == 0 ? positionInGroup == 0 : positionInGroup == 4
        
        return isLarge
        ? CGSize(width: largeSize, height: largeSize)
        : CGSize(width: smallSize, height: smallSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == exploreCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let threshold = contentHeight - scrollView.frame.height * 1.5
        if offsetY > threshold {
            viewModel.fetchExplorePhotos()
        }
    }
}

extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserSearchCell.identifier, for: indexPath
        ) as? UserSearchCell else { return UITableViewCell() }
        cell.configure(user: viewModel.searchResults[indexPath.row])
        return cell
    }
}

extension SearchController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchUsers(query: "")
            showExplore()
        } else {
            showSearchResults()
            viewModel.searchUsers(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchUsers(query: "")
        showExplore()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        showExplore()
    }
}


