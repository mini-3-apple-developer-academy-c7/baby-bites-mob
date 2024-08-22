//
//  RecommendationPredictor.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 21/08/24.
//

import Foundation
import TabularData

#if canImport(CreateML)
import CreateML
#endif

final class RecommendationPredictor {
  private let queue = DispatchQueue(label: "com.recommendation-service.queue", qos: .userInitiated)

    func computeRecommendations(basedOn items: [Favorite<Recipe>]) async throws -> [Recipe] {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                #if targetEnvironment(simulator)
                continuation.resume(throwing: NSError(domain: "Simulator Not Supported", code: -1))
                #else
                let trainingData = items.filter {
                    $0.rating != nil
                }
                
                let trainingDataFrame = self.dataFrame(for: trainingData)
                
                let testData = items
                let testDataFrame = self.dataFrame(for: testData)
                
                do {
                    let regressor = try MLLinearRegressor(trainingData: trainingDataFrame, targetColumn: "rating")
                    
                    let predictionsColumn = (try regressor.predictions(from: testDataFrame)).compactMap { value in
                        value as? Double
                    }
                    
                    let sorted = zip(testData, predictionsColumn)
                        .sorted { lhs, rhs -> Bool in
                            lhs.1 > rhs.1
                        }
                        .filter {
                            $0.1 > 0
                        }
                        .prefix(10)
                    
                    print(sorted.map(\.1))
                    
                    let result = sorted.map(\.0.model)
                    
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
                #endif
            }
        }
    }

    private func dataFrame(for data: [Favorite<Recipe>]) -> DataFrame {
    var dataFrame = DataFrame()

//    dataFrame.append(
//        column: Column(name: "ingredient", contents: data.map(\.model.ingredients))
//    )

    dataFrame.append(
        column: Column(name: "texture", contents: data.map(\.model.texture))
    )

    dataFrame.append(
      column: Column(name: "cookingTime", contents: data.map(\.model.cookingTime))
    )

    dataFrame.append(
      column: Column(name: "category", contents: data.map(\.model.category))
    )

    dataFrame.append(
      column: Column<Int>(
        name: "rating",
        contents: data.map {
            if let rating = $0.rating {
            return rating
          } else {
            return 0
          }
        }
      )
    )

    return dataFrame
  }
}
