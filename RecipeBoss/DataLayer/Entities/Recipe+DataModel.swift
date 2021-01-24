//
//  Recipe+DataModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import Foundation

struct RecipeList: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    
    let title: String
    let description: String
    let thumbnailUrlPath: String
    let thumbnailAltText: String
    let details: RecipeDetails
    let ingredients: [IngredientItem]
    
    private enum CodingKeys: String, CodingKey {
        case title = "dynamicTitle"
        case description = "dynamicDescription"
        case thumbnailUrlPath = "dynamicThumbnail"
        case thumbnailAltText = "dynamicThumbnailAlt"
        case details = "recipeDetails"
        case ingredients = "ingredients"
    }
}

struct RecipeDetails: Decodable {
    
    let amountLabel: String
    let amount: Int
    
    let preparationTimeLabel: String
    let preparationTime: Int
    let preparationTimeText: String
    
    let cookingTimeLabel: String
    let cookingTime: Int
    let cookingTimeText: String
    
    private enum CodingKeys: String, CodingKey {
        case amountLabel = "amountLabel"
        case amount = "amountNumber"
        case preparationTimeLabel = "prepLabel"
        case preparationTime = "prepTimeAsMinutes"
        case preparationTimeText = "prepTime"
        case cookingTimeLabel = "cookingLabel"
        case cookingTime = "cookTimeAsMinutes"
        case cookingTimeText = "cookingTime"
    }
}

struct IngredientItem: Decodable {
    let ingredient: String
}

