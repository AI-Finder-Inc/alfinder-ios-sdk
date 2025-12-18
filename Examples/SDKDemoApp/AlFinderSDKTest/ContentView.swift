//
//  ContentView.swift
//  AlFinderSDKTest
//
//  Created by Mina Haleem on 16.12.25.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var vm = SearchViewModel()

    var body: some View {
        NavigationView {
            Group {
                if vm.isLoading && vm.products.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Searching…").foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let msg = vm.errorMessage, vm.products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 28))
                        Text("Search failed").font(.headline)
                        Text(msg)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        Button("Retry") {
                            // just re-emit current query (or call clear+set)
                            vm.query = vm.query
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if vm.products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 28))
                        Text("Start typing to search").font(.headline)
                        Text("Example: watch, iphone, shoes…")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    List(vm.products, id: \.id) { product in
                        ProductRow(product: product)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("AlFinder Search")
            .searchable(text: $vm.query, prompt: "Search products…")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.clear()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .disabled(vm.query.isEmpty)
                }
            }
        }
    }
}

