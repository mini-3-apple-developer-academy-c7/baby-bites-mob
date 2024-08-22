//
//  Recipe.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 20/08/24.
//

import Foundation
import CloudKit

class Recipe: Equatable, Identifiable {
    typealias Identifier = String

    enum Category: String {
        case firstFoods
        case stageOne
        case stageTwo
        case stageThree
    }
    
    enum Texture: String {
        case pureed
        case mashed
        case softLumps
        case finelyChopped
        case softSolid
        
        case smooth
        case softChunks
        case lumpy
    }
    
    let id: Identifier
    let title: String?
    let category: Category?
    let imageUrl: String?
    let description: String?
    let cookingTime: TimeInterval?
    let texture: Texture?
    var ingredients: Ingredient?
    var body: String?
//    let preparationInstructions: NSAttributedString?
    
    init(record: CKRecord, ingredient: Ingredient? = nil) {
        self.id = record.recordID.recordName
        self.title = record["title"] as? String ?? ""
        if let categoryRaw = record["category"] as? String {
            self.category = Category(rawValue: categoryRaw)
        } else {
            self.category = nil
        }
        self.imageUrl = record["imageUrl"] as? String ?? ""
        self.description = record["description"] as? String ?? ""
        self.cookingTime = record["cookingTime"] as? TimeInterval ?? nil
        if let textureRaw = record["texture"] as? String {
            self.texture = Texture(rawValue: textureRaw)
        } else {
            self.texture = nil
        }
        self.ingredients = ingredient
        self.body = record["body"] as? String ?? ""
//        self.preparationInstructions = nil
//        if let ingredientReference = record["ingredients"] as? CKRecord.Reference {
//                fetchIngredient?(ingredientReference.recordID) { ingredient in
//                self.ingredients = ingredient
//            }
//        } else {
//            self.ingredients = nil
//        }
//        if let instructionsData = record["preparationInstructions"] as? Data {
//            self.preparationInstructions = NSKeyedUnarchiver.unarchiveObject(with: instructionsData) as? NSAttributedString
//        }
    }

    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Recipe")
        record["title"] = title as CKRecordValue?
        record["category"] = category?.rawValue as CKRecordValue?
        record["imageUrl"] = imageUrl as CKRecordValue?
        record["description"] = description as CKRecordValue?
        record["body"] = body as CKRecordValue?
        record["cookingTime"] = cookingTime as CKRecordValue?
        record["texture"] = texture?.rawValue as CKRecordValue?
//        if let instructions = preparationInstructions {
//            record["preparationInstructions"] = NSKeyedArchiver.archivedData(withRootObject: instructions) as CKRecordValue
//        }
//        if let ingredient = ingredients {
//            let ingredientRecord = ingredient.toCKRecord()
//            let reference = CKRecord.Reference(recordID: ingredientRecord.recordID, action: .none)
//            record["ingredients"] = reference
//        }
        return record
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}
