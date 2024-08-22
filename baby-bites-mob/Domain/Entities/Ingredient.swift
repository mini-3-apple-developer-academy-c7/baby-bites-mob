//
//  Ingredient.swift
//  baby-bites-mob
//
//  Created by Mika S Rahwono on 20/08/24.
//
import CloudKit

struct Ingredient: Equatable, Identifiable {
    typealias Identifier = String

    enum FlavorProfile: String {
        case bland
        case mildlySweet
        case mildlySavory
        case neutral
        case slightlySour
    }
    
    enum Category: String {
        case vegetables
        case proteins
        case fruits
    }
    
    let id: Identifier
    let name: String
    let flavorProfile: FlavorProfile?
    let category: Category?
    let imageUrl: String
    let description: String
    
    init(record: CKRecord) {
        self.id = record.recordID.recordName
        self.name = record["name"] as? String ?? ""
        self.imageUrl = record["imageUrl"] as? String ?? ""
        self.description = record["description"] as? String ?? ""
        if let flavorProfileRaw = record["flavorProfile"] as? String {
            self.flavorProfile = FlavorProfile(rawValue: flavorProfileRaw)
        } else {
            self.flavorProfile = nil
        }
        if let categoryRaw = record["category"] as? String {
            self.category = Category(rawValue: categoryRaw)
        } else {
            self.category = nil
        }
    }

    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Ingredient")
        record["name"] = name as CKRecordValue
        record["imageUrl"] = name as CKRecordValue
        record["description"] = name as CKRecordValue
        record["flavorProfile"] = flavorProfile?.rawValue as CKRecordValue?
        record["category"] = category?.rawValue as CKRecordValue?
        return record
    }
}
