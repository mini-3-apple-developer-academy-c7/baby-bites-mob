//
//  RecipeInspirationRow.swift
//  Baby Bites
//
//  Created by Riyadh Abu Bakar on 22/08/24.
//

import SwiftUI

struct RecipeInspirationRow: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                HStack {
                    // Image Section
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 149, height: 100)
                        .background(
                            AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 149, height: 100)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }    
                        )
                    
                    // Text Section
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(recipe.title ?? "")
                                .font(
                                    Font.custom("SF Pro", size: 20)
                                        .weight(.bold)
                                )
                                .frame(width: 150, height: 12, alignment: .topLeading)
                            
                            VStack {
                                Text(recipe.texture?.rawValue ?? "")
                                    .font(
                                        Font.custom("SF Pro", size: 10)
                                            .weight(.light)
                                    )
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.pink.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Color(red: 0.52, green: 0.51, blue: 0.5)) // Color for icon
                            Text(recipe.cookingTime != nil ? "\(Int(recipe.cookingTime! / 60)) min" : "No cooking time available")
                                .font(
                                    Font.custom("SF Pro", size: 10)
                                        .weight(.medium)
                                )
                                .foregroundColor(Color(red: 0.52, green: 0.51, blue: 0.5)) // Color for text
                        }
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 353, height: 100)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding()
    }
}
