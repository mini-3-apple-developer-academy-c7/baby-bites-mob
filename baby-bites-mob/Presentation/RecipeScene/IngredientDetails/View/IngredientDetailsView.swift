//
//  IngredientDetailsView.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 23/08/24.
//

import SwiftUI

struct IngredientDetailView: View {
    @ObservedObject var ingredientDetailsViewModel: IngredientDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    // Background color and photo
                    Color(.systemGray6).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AsyncImage(url: URL(string: ingredientDetailsViewModel.ingredient?.imageUrl ?? ""))
                            .frame(width: 400, height: 300)
                            .clipped()
                        
                        Spacer()
                    }
                    
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 358, height: 6)
                            .cornerRadius(3)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 0.5)
                    .offset(y: 235) // overlapping frame with photo
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Ingredient Header
                    IngredientHeader(ingredient: ingredientDetailsViewModel.ingredient)
                        .padding(.top, -100)
                        .padding(.leading, 20)
                        .frame(width: 394, alignment: .leading)

                    // Separator
                    Rectangle()
                        .frame(width: 352, height: 1)
                        .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.6))
                        .padding(.horizontal)
                        .padding(.leading, 20)
                        .padding(.trailing, 21)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dish Inspiration")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 20)
                        
                        // Dish Inspiration List
                        VStack(spacing: 0) {
                            ForEach(ingredientDetailsViewModel.recipes) { recipe in
                                RecipeInspirationRow(recipe: recipe)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 21)
                    }
                }
                .padding(.vertical)
                .offset(y: 10) // inspiration header adjustment
            }
        }
        .navigationTitle("Ingredient Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if ingredientDetailsViewModel.recipes.isEmpty {
                ingredientDetailsViewModel.fetchRecipesByIngredient()
            }
        }
    }
}
