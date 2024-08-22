//
//  IngredientLibrary.swift
//  baby-bites-mob
//
//  Created by Zefanya on 22/08/24.
//

import SwiftUI

struct IngredientLibrary: View {
    @ObservedObject var ingredientListViewModel: IngredientsListViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(ingredientListViewModel.ingredients) { ingredient in
                            IngredientItemView(ingredient: ingredient)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Text("Library")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecommendationPage: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Recommendations")
                    .font(.largeTitle)
                    .padding()

                // Mock content
                Text("Here are some food recommendations!")
                    .padding()
            }
            .navigationBarTitle("Recommendation", displayMode: .inline)
        }
    }
}

struct IngredientItemView: View {
    let ingredient: Ingredient

    private var ingredientDetailsViewModel: IngredientDetailsViewModel {
        let cloudKitIngredientRepository = CloudKitIngredientRepository()
        let cloudKitRecipeRepository = CloudKitRecipeRepository(ingredientRepository: cloudKitIngredientRepository)
        let fetchRecipesByIngredientUseCase = FetchRecipesByIngredientUseCase(recipeRepository: cloudKitRecipeRepository)
        let fetchIngredientUseCase = FetchIngredientUseCase(ingredientRepository: cloudKitIngredientRepository)
        return IngredientDetailsViewModel(
            ingredientID: ingredient.id,
            fetchIngredientUseCase: fetchIngredientUseCase,
            fetchRecipesByIngredientUseCase: fetchRecipesByIngredientUseCase
        )
    }
    
    var body: some View {
        NavigationLink(destination: IngredientDetailView(ingredientDetailsViewModel: ingredientDetailsViewModel)) {
            VStack(alignment: .leading) {
                Image(ingredient.imageUrl)
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
                
                Text(ingredient.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 7)
                
                Text(ingredient.category?.rawValue ?? "")
                    .font(.system(size: 10))
                    .padding(4)
                    .background(categoryColor(for: ingredient.category?.rawValue ?? ""))
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle()) // Ensure that the NavigationLink does not apply default button styling
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "fruits": return Color.blue
        case "vegetables": return Color.green
        case "proteins": return Color.red.opacity(0.7)
        default: return Color.gray
        }
    }
}

struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        TextField("Search", text: $searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)

                    Spacer()

                    Button(action: {
                        // Action for microphone button
                    }) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
    }
}
