//
//  MainView.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 21/08/24.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientsSwiftUIViewController()
    }
    
    private func setupIngredientsSwiftUIViewController() {
        let ingredientsSwiftUIViewController = IngredientsSwiftUIViewController()

        // Add IngredientsSwiftUIViewController as a child view controller
        addChild(ingredientsSwiftUIViewController)
        view.addSubview(ingredientsSwiftUIViewController.view)
        ingredientsSwiftUIViewController.didMove(toParent: self)
    }
}
