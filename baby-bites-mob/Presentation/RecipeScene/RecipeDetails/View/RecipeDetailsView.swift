//
//  Untitled.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 23/08/24.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @State private var showRatingPopup = false
    @State private var selectedRating = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        Color(.systemGray6).edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 400, height: 400)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }                            
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
                        .offset(y: 300)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Ingredient Header
                        RecipeHeader(recipe: recipe)
                            .padding(.top, -65)
                            .padding(.leading, 25)
                            .frame(width: 394, alignment: .leading)
                        
                        // Separator
                        Rectangle()
                            .frame(width: 352, height: 1)
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.6))
                            .padding(.horizontal)
                            .padding(.leading, 20)
                            .padding(.trailing, 21)
                        
                        // What you need
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What you need")
                                .font(.headline)
                                .padding(.top, -15)
                                .padding()
                            
                            if let whatYouNeed = extractWhatYouNeed(from: recipe.howTo ?? "") {
                                Text(whatYouNeed)
                                    .font(.body)
                                    .padding(.top, -55)
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // How to make
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How to make")
                                .font(.headline)
                                .padding(.top, -70)
                                .padding()
                            
                            if let howToMake = extractHowToMake(from: recipe.howTo ?? "") {
                                Text(howToMake)
                                    .font(.body)
                                    .padding(.top, -105)
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // Rate Button
                        Button(action: {
                            showRatingPopup = true
                        }) {
                            Text("Rate")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color(red: 0.87, green: 0.33, blue: 0.33))
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .padding(.bottom, 30)
                }
                Spacer(minLength: 150)
            }
            .navigationTitle("Dish Detail")
            .navigationBarTitleDisplayMode(.inline)
            .blur(radius: showRatingPopup ? 5 : 0)
            .overlay(
                Group {
                    if showRatingPopup {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        RatingView(selectedRating: $selectedRating, showPopup: $showRatingPopup)
                            .frame(width: 300, height: 200)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .transition(.scale)
                            .zIndex(1)
                    }
                }
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    //to extract sections of the recipe
    func extractWhatYouNeed(from recipe: String) -> String? {
        return recipe.components(separatedBy: "What you need:").last?.components(separatedBy: "How to make:").first
    }
    
    func extractHowToMake(from recipe: String) -> String? {
        return recipe.components(separatedBy: "How to make:").last
    }
}

struct RatingView: View {
    @Binding var selectedRating: Int
    @Binding var showPopup: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            Text("How much your kid liked this dish?")
                .font(.headline)
                .foregroundColor(.black)

            HStack(spacing: 10) {
                ForEach(1..<6) { index in
                    Image(systemName: index <= selectedRating ? "star.fill" : "star")
                        .foregroundColor(Color(red: 0.87, green: 0.33, blue: 0.33))
                        .font(.largeTitle)
                        .onTapGesture {
                            selectedRating = index
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 20)

            Button(action: {
                showPopup = false
    
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 129, height: 30)
                    .padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 36))
                    .background(Color(red: 0.87, green: 0.33, blue: 0.33)) //
                    .cornerRadius(7.643)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
    }
}
