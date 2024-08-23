//
//  Untitled.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 20/08/24.
//

import CloudKit

class CloudKitRecipeRepository: RecipeRepository {
    
    private let ingredientRepository: CloudKitIngredientRepository
    
    init(ingredientRepository: CloudKitIngredientRepository) {
        self.ingredientRepository = ingredientRepository
    }
    
    func fetchAllRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Recipe", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        query.sortDescriptors = [sortDescriptor]

        publicDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                completion(.failure(error))
            } else if let records = results {
                var recipes: [Recipe] = []

                for record in records {
                    let recipe = Recipe(record: record)
                    recipes.append(recipe)
                }
                completion(.success(recipes))
            }
        }
    }
    
    func extractRecordName(from reference: CKRecord.Reference?) -> String? {
        let recordID = reference?.recordID
        return recordID?.recordName
    }

    func fetchRecipesByIngredients(by ingredientID: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Recipe", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        query.sortDescriptors = [sortDescriptor]

        publicDatabase.perform(query, inZoneWith: nil) { [weak self] results, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let records = results else {
                completion(.success([]))
                return
            }
            
            let recipesGroup = DispatchGroup()
            var recipes = [Recipe]()
            var fetchError: Error?

            for record in records {
                recipesGroup.enter()
                
                let recordName = self?.extractRecordName(from: record["ingredients"] as? CKRecord.Reference)
                if recordName != ingredientID {
                    defer { recipesGroup.leave() }
                    continue
                } else {
                    self?.ingredientRepository.fetchIngredient(by: ingredientID) { result in
                        defer { recipesGroup.leave() }
                        switch result {
                        case .success(let ingredient):
                            let recipe = Recipe(record: record, ingredient: ingredient)
                            recipes.append(recipe)
                        case .failure(let error):
                            fetchError = error
                        }
                    }
                }
            }
            
            
            recipesGroup.notify(queue: .main) {
                if let error = fetchError {
                    completion(.failure(error))
                } else {
                    completion(.success(recipes))
                }
            }
        }
    }
    
    func saveRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        let record = recipe.toCKRecord()
        let publicDatabase = CKContainer.default().publicCloudDatabase
        publicDatabase.save(record) { savedRecord, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchRecipe(by id: String, completion: @escaping (Result<Recipe, Error>) -> Void) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let recordID = CKRecord.ID(recordName: id)
        publicDatabase.fetch(withRecordID: recordID) { [weak self] record, error in
            if let error = error {
                completion(.failure(error))
            } else if let record = record {
                // Define fetchIngredient closure
                let fetchIngredient: (CKRecord.ID, @escaping (Ingredient?) -> Void) -> Void = { ingredientID, completion in
                    self?.ingredientRepository.fetchIngredient(by: ingredientID.recordName) { result in
                        switch result {
                        case .success(let ingredient):
                            completion(ingredient)
                        case .failure:
                            completion(nil)
                        }
                    }
                }

                // Create Recipe instance
                let recipe = Recipe(record: record)
                completion(.success(recipe))
            }
        }
    }
}
