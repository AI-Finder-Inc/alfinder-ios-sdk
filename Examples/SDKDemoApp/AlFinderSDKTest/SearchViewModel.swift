//
//  Search.swift
//  AlFinderSDKTest
//
//  Created by Mina Haleem on 16.12.25.
//

import Foundation
import Combine
import AlFinderSDK

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published private(set) var products: [AlFinderClient.Product] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init() {
        // Debounce typing, dedupe, and search automatically
        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] q in
                self?.triggerSearch(for: q)
            }
            .store(in: &cancellables)
    }

    func clear() {
        query = ""
        cancelSearch()
        products = []
        errorMessage = nil
        isLoading = false
    }

    func cancelSearch() {
        searchTask?.cancel()
        searchTask = nil
        isLoading = false
    }

    private func triggerSearch(for q: String) {
        // If empty: clear results + cancel any in-flight request
        guard !q.isEmpty else {
            cancelSearch()
            products = []
            errorMessage = nil
            return
        }

        // Cancel previous request before starting a new one
        searchTask?.cancel()

        isLoading = true
        errorMessage = nil

        searchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await AlFinderClient.shared.searchProducts(
                    query: q,
                    limit: 8,
                    page: 1,
                    lang: .en
                )

                // If task got cancelled during await, don't update UI
                guard !Task.isCancelled else { return }

                self.products = response.results.products
                self.isLoading = false

            } catch {
                guard !Task.isCancelled else { return }
                self.products = []
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
