//
//  URLImageView.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 23/08/24.
//

import SwiftUI

struct URLImageView: View {
    let imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 130, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 100)
                    .clipped()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            case .failure:
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            @unknown default:
                EmptyView()
            }
        }
    }
}
