//
//  Recipe+Accessibility.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import UIKit

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
}

struct RecipeAccessibility {
    
    let container: AccessibilityConfiguration
    
    let title: AccessibilityConfiguration
    let description: AccessibilityConfiguration
    
    let image: AccessibilityConfiguration
    
    let servesInfo: AccessibilityConfiguration
    let preparationTimeInfo: AccessibilityConfiguration
    let cookingTimeInfo: AccessibilityConfiguration
    
    let ingredientsHeading: AccessibilityConfiguration
    
    let compactTitle: AccessibilityConfiguration
    let compactSubtitle: AccessibilityConfiguration
}

