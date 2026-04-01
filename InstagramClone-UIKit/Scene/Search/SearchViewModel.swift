//
//  SearchViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

class SearchViewModel {
    
    var explorePhotos: [ExplorePhoto] = []
    var searchResults: [User] = []
    
    var onPhotosUpdated: (() -> Void)?
    var onSearchResultsUpdated: (() -> Void)?
    var onLoadingMore: ((Bool) -> Void)?
    var onError: ((AppError) -> Void)?
    
    private let userSearchRepostiory: UserSearchRepository
    private let exploreRepository: ExploreRepository
    
    private var currentPage = 1
    private var isFetchingMore = false
    private var hasMorePages = true
    private var debounceTimer: Timer?
    
    init(userSearchRepostiory: UserSearchRepository = FirebaseUserSearchRepository(),
         exploreRepository: ExploreRepository = PicsumExploreRepository()) {
        self.userSearchRepostiory = userSearchRepostiory
        self.exploreRepository = exploreRepository
    }
    
    deinit {
        debounceTimer?.invalidate()
    }
    
    func fetchExplorePhotos() {
        guard !isFetchingMore, hasMorePages else { return }
        isFetchingMore = true
        onLoadingMore?(true)
        
        exploreRepository.fetchPhotos(page: currentPage,
                                      limit: 30) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchingMore = false
                self.onLoadingMore?(false)
                
                switch result {
                case .success(let photos):
                    if photos.isEmpty {
                        self.hasMorePages = false
                        return
                    }
                    
                    self.explorePhotos.append(contentsOf: photos)
                    self.currentPage += 1
                    self.onPhotosUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func searchUsers(query: String) {
        debounceTimer?.invalidate()
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            onSearchResultsUpdated?()
            return
        }
        
        debounceTimer  = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            self?.performSearch(query: query)
        }
        
    }
    
    private func performSearch(query: String) {
        userSearchRepostiory.searchUsers(query: query) { [weak self] result in
            guard let self = self  else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.searchResults = users
                    self.onSearchResultsUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
}
