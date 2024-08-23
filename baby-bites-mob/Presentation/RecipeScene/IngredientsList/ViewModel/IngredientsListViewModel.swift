//
//  IngredientsListViewModel.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 20/08/24.
//

import Combine
import Foundation

class IngredientsListViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchIngredientsUseCase: FetchAllIngredientsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchIngredientsUseCase: FetchAllIngredientsUseCase) {
        self.fetchIngredientsUseCase = fetchIngredientsUseCase
        fetchAllIngredients()
    }

    func fetchAllIngredients() {
        isLoading = true
        fetchIngredientsUseCase.execute() { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ingredients):
                    self?.ingredients = ingredients
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.ingredients = []
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
