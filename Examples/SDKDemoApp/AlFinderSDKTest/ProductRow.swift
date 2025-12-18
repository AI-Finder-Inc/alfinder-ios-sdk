//
//  ProductRow.swift
//  AlFinderSDKTest
//
//  Created by Mina Haleem on 16.12.25.
//

import SwiftUI
import AlFinderSDK

struct ProductRow: View {
    let product: AlFinderClient.Product

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.mainImage ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 64, height: 64)
                        .overlay { ProgressView() }
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 64, height: 64)
                        .overlay { Image(systemName: "photo") }
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name.en ?? product.name.ar ?? "Unnamed product")
                    .font(.headline)
                    .lineLimit(2)

                if let price = product.price {
                    Text("\(price, specifier: "%.2f") \(product.currency ?? "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let available = product.isAvailable {
                    Text(available ? "Available" : "Out of stock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

