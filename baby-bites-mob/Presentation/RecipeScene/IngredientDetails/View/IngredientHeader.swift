//
//  IngeredientHeader.swift
//  Baby Bites
//
//  Created by Riyadh Abu Bakar on 22/08/24.
//

import SwiftUI

struct IngredientHeader: View {
    var ingredient: Ingredient?
    
    private func categoryBackgroundColor(for category: String) -> Color {
        switch category.lowercased() {
        case "vegetables":
            return Color(red: 0.38, green: 1, blue: 0).opacity(0.2)
        case "fruits":
            return Color(red: 0, green: 0.64, blue: 1).opacity(0.2)
        case "proteins":
            return Color(red: 1, green: 0, blue: 0).opacity(0.2)
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ingredient?.name ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(ingredient?.category?.rawValue ?? "")
                .font(.headline)
                .padding(5)
                .background(categoryBackgroundColor(for: ingredient?.category?.rawValue ?? ""))
                .cornerRadius(5)
            
            Text(ingredient?.description ?? "")
                .font(.body)
        }
        .padding()
    }
}

