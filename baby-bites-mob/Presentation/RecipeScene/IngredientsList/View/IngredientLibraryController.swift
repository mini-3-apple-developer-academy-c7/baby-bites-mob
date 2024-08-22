//
//  IngredientLibraryController.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 23/08/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    let ingredientListViewModel: IngredientsListViewModel
    
    var body: some View {
        TabView {
            RecommendationPage()
                .tabItem {
                    Image(systemName: "hand.thumbsup")
                    Text("Recommendation")
                }
            IngredientLibrary(ingredientListViewModel: ingredientListViewModel)
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Library")
                }
        }
    }
}

class IngredientsSwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingredientRepository = CloudKitIngredientRepository()
        let fetchAllIngredientsUseCase = FetchAllIngredientsUseCase(ingredientRepository: ingredientRepository)
        let ingredientListViewModel = IngredientsListViewModel(fetchIngredientsUseCase: fetchAllIngredientsUseCase)

        let contentView = ContentView(ingredientListViewModel: ingredientListViewModel)
        
        let hostingController = UIHostingController(rootView: contentView)

        addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
