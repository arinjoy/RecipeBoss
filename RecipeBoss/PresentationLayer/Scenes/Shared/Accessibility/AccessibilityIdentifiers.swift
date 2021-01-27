//
//  AccessibilityIdentifiers.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 27/1/21.
//

struct AccessibilityIdentifiers {
    
    struct RecipeDetail {
        static let cellId = "\(RecipeDetail.self).cell"
        
        static let headingNameId = "\(RecipeDetail.self).mainHeading"
        static let descriptionId = "\(RecipeDetail.self).description"
        static let thumbImageId = "\(RecipeDetail.self).thumbImage"
        static let servesInfoId = "\(RecipeDetail.self).servesInfo"
        static let prepTimeInfoId = "\(RecipeDetail.self).prepTimeInfo"
        static let cookTimeInfoId = "\(RecipeDetail.self).cookTimeInfo"
        static let ingredientHeadingId = "\(RecipeDetail.self).ingredientsHeading"
        static let ingredientsListItemId = "\(RecipeDetail.self).ingredients.item"
        
        static let compactTitleId = "\(RecipeDetail.self).compact.cell.title"
        static let compactSubtitleId = "\(RecipeDetail.self).compact.cell.subtitle"
    }
    
    
    struct Placeholder {
        static let rootViewId = "\(Placeholder.self).rootViewId"
        static let imageId = "\(Placeholder.self).image"
        static let titleId = "\(Placeholder.self).title"
        static let descriptionId = "\(Placeholder.self).description"
    }
}
