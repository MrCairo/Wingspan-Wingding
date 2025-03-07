//
//  BirdModel.swift
//  Wingding
//
//  Created by Mitch Fisher on 3/2/25.
//

import Foundation
struct BirdModel : Codable {
    let commonName : String?
    let scientificName : String?
    let set : String?
    let color : String?
    let powerText : String?
    let flavorText : String?
    let bonusCard : String?
    let victoryPoints : Int?
    let nestType : String?
    let eggLimit : Int?
    let wingspan : Int?
    let wetland : String?
    let fish : Int?
    let totalFoodCost : Int?
    let oceania : String?
    let historian : String?
    let endangeredSpeciesProtector : String?
    let fisheryManager : String?
    let largeBirdSpecialist : String?
    let platformBuilder : String?
    let smallClutchSpecialist : String?
    let wetlandScientist : String?

    enum CodingKeys: String, CodingKey {

        case commonName = "Common name"
        case scientificName = "Scientific name"
        case set = "Set"
        case color = "Color"
        case powerText = "Power text"
        case flavorText = "Flavor text"
        case bonusCard = "Bonus card"
        case victoryPoints = "Victory points"
        case nestType = "Nest type"
        case eggLimit = "Egg limit"
        case wingspan = "Wingspan"
        case wetland = "Wetland"
        case fish = "Fish"
        case totalFoodCost = "Total food cost"
        case oceania = "Oceania"
        case historian = "Historian"
        case endangeredSpeciesProtector = "Endangered Species Protector"
        case fisheryManager = "Fishery Manager"
        case largeBirdSpecialist = "Large Bird Specialist"
        case platformBuilder = "Platform Builder"
        case smallClutchSpecialist = "Small Clutch Specialist"
        case wetlandScientist = "Wetland Scientist"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        commonName = try values.decodeIfPresent(String.self, forKey: .commonName)
        scientificName = try values.decodeIfPresent(String.self, forKey: .scientificName)
        set = try values.decodeIfPresent(String.self, forKey: .set)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        powerText = try values.decodeIfPresent(String.self, forKey: .powerText)
        flavorText = try values.decodeIfPresent(String.self, forKey: .flavorText)
        bonusCard = try values.decodeIfPresent(String.self, forKey: .bonusCard)
        victoryPoints = try values.decodeIfPresent(Int.self, forKey: .victoryPoints)
        nestType = try values.decodeIfPresent(String.self, forKey: .nestType)
        eggLimit = try values.decodeIfPresent(Int.self, forKey: .eggLimit)
        wingspan = try values.decodeIfPresent(Int.self, forKey: .wingspan)
        wetland = try values.decodeIfPresent(String.self, forKey: .wetland)
        fish = try values.decodeIfPresent(Int.self, forKey: .fish)
        totalFoodCost = try values.decodeIfPresent(Int.self, forKey: .totalFoodCost)
        oceania = try values.decodeIfPresent(String.self, forKey: .oceania)
        historian = try values.decodeIfPresent(String.self, forKey: .historian)
        endangeredSpeciesProtector = try values.decodeIfPresent(String.self, forKey: .endangeredSpeciesProtector)
        fisheryManager = try values.decodeIfPresent(String.self, forKey: .fisheryManager)
        largeBirdSpecialist = try values.decodeIfPresent(String.self, forKey: .largeBirdSpecialist)
        platformBuilder = try values.decodeIfPresent(String.self, forKey: .platformBuilder)
        smallClutchSpecialist = try values.decodeIfPresent(String.self, forKey: .smallClutchSpecialist)
        wetlandScientist = try values.decodeIfPresent(String.self, forKey: .wetlandScientist)
    }

}
