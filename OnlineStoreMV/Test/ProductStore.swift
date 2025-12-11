//
//  ProductStore.swift
//  OnlineStoreMV
//
//  Created by Nonprawich I. on 11/12/25.
//

import Foundation

@Observable
class ProductStore {

    enum LoadingState {
        case notStarted
        case loading
        case loaded(result: [Product])
        case empty
        case error(message: String)
    }

    private var products: [Product]
    private let apiClient: APIClient
    var loadingState: LoadingState = .notStarted

    init(apiClient: APIClient = .live) {
        self.apiClient = apiClient
        self.products = []
    }

    @MainActor
    func fetchProducts() async {
        loadingState = .loading

        do {
            let result = try await apiClient.fetchProducts()
            self.products = result

            if result.isEmpty {
                loadingState = .empty
            } else {
                loadingState = .loaded(result: result)
            }

        } catch {
            loadingState = .error(message: error.localizedDescription)
        }
    }
}
