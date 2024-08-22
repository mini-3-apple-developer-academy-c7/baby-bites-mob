//
//  IngredientLibrary.swift
//  baby-bites-mob
//
//  Created by Zefanya on 22/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(foodItems) { item in
                            FoodItemView(item: item)
                        }
                    }
                    .padding()
//                    .background(Color(.systemGray5))
                }

                CustomTabBar()
            }
            .navigationBarItems(leading: Text("Library")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black))
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct FoodItemView: View {
    let item: FoodItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(item.imageName)
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
            
            Text(item.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 7)
            
            Text(item.category)
                .font(.system(size: 10))
                .padding(4)
                .background(categoryColor(for: item.category))
                .foregroundColor(.white)
                .cornerRadius(4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Fruits": return Color.blue
        case "Vegetables": return Color.green
        case "Protein": return Color.red.opacity(0.7)
        default: return Color.gray
        }
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack {
            Spacer()
            CustomTabBarItem(icon: "hand.thumbsup", text: "Recommendation")
            Spacer()
            CustomTabBarItem(icon: "book.closed.fill", text: "Library")
            Spacer()
        }
        .padding(.vertical, 25)
        .background(Color.white.shadow(radius: 2))
        .cornerRadius(0)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct CustomTabBarItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.black)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
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

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let imageName: String
}

let foodItems = [
    FoodItem(name: "Avocado", category: "Fruits", imageName: "avocado"),
    FoodItem(name: "Banana", category: "Fruits", imageName: "banana"),
    FoodItem(name: "Broccoli", category: "Vegetables", imageName: "broccoli"),
    FoodItem(name: "Chicken", category: "Protein", imageName: "chicken"),
    FoodItem(name: "Egg", category: "Protein", imageName: "egg"),
    FoodItem(name: "Salmon", category: "Protein", imageName: "salmon")
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

