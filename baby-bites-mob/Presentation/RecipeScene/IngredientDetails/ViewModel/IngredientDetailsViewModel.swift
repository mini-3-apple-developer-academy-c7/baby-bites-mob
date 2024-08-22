//
//  IngredientDetailsViewModel.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 20/08/24.
//

import Combine
import Foundation

class IngredientDetailsViewModel: ObservableObject {
    @Published var ingredient: Ingredient?
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var ingredientID: String?

    private let fetchIngredientUseCase: FetchIngredientUseCase
    private let fetchRecipesByIngredientUseCase: FetchRecipesByIngredientUseCase
    private var cancellables = Set<AnyCancellable>()

    init(ingredientID: String, fetchIngredientUseCase: FetchIngredientUseCase, fetchRecipesByIngredientUseCase: FetchRecipesByIngredientUseCase) {
        self.fetchIngredientUseCase = fetchIngredientUseCase
        self.fetchRecipesByIngredientUseCase = fetchRecipesByIngredientUseCase
        self.ingredientID = ingredientID
        fetchIngredient(by: ingredientID)
    }

    func fetchIngredient(by ingredientID: String) {
        isLoading = true
        fetchIngredientUseCase.execute(ingredientID: ingredientID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ingredient):
                    self?.ingredient = ingredient
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.ingredient = nil
                    self?.errorMessage = error.localizedDescription
                    print("Gagal")
                }
            }
        }
    }
    
    func fetchRecipesByIngredient() {
        isLoading = true
        fetchRecipesByIngredientUseCase.execute(ingredientID: self.ingredientID ?? "") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    self?.errorMessage = nil
                    print(recipes)
                case .failure(let error):
                    self?.recipes = []
                    self?.errorMessage = error.localizedDescription
                    print("Gagal")
                }
            }
        }
    }
}
