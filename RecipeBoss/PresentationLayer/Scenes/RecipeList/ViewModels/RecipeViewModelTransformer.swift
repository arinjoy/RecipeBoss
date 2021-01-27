//
//  RecipeViewModelTransformer.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 26/1/21.
//

import Foundation
import UIKit.UIImage
import Combine

struct RecipeViewModelTransformer {

    static func viewModel(
        from model: RecipeModel,
        imageLoader: (URL?) -> AnyPublisher<UIImage?, Never>
    ) -> RecipeViewModel? {
        
        let accessibilty = RecipeAccessibility(
            container: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.cellId,
                label: UIAccessibility.createCombinedAccessibilityLabel(from: ["RECIPE", model.title]),
                // TODO: change to `.button` type if tappable cell and detail view navigation is needed
                // in future
                traits: .staticText),
            title: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.headingNameId,
                label: model.title,
                traits: .header),
            description: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.descriptionId,
                label: model.description,
                traits: .staticText),
            image: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.thumbImageId,
                label: model.thumbnailImage.altText,
                traits: .image),
            servesInfo: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.servesInfoId,
                label: UIAccessibility.createCombinedAccessibilityLabel(
                    from: [model.servesInfo.label,
                           "\(model.servesInfo.amount) \(model.servesInfo.amount > 1 ? "people" : "person")"
                    ]),
                traits: .staticText),
            preparationTimeInfo: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.prepTimeInfoId,
                label: UIAccessibility.createCombinedAccessibilityLabel(
                    from: ["Preparation time",
                           "\(model.preparationTimeInfo.duration) minutes"
                    ]),
                traits: .staticText),
            cookingTimeInfo: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.cookTimeInfoId,
                label: UIAccessibility.createCombinedAccessibilityLabel(
                    from: ["Cooking time",
                           "\(model.cookingTimeInfo.duration) minutes"
                    ]),
                traits: .staticText),
            ingredientsHeading: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.ingredientHeadingId,
                label: "Ingredients",
                hint: "List of items you need for this recipee",
                traits: .header),
            compactTitle: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.compactTitleId,
                traits: .header),
            compactSubtitle: AccessibilityConfiguration(
                identifier: AccessibilityIdentifiers.RecipeDetail.compactSubtitleId,
                label: model.title,
                traits: .staticText)
        )
        
        return RecipeViewModel(
            title: model.title,
            description: model.description,
            imageURL: model.thumbnailImage.url,
            imageAltText: model.thumbnailImage.altText,
            thumbImage: imageLoader(model.thumbnailImage.url),
            servesInfo: model.servesInfo,
            preparationTimeInfo: model.preparationTimeInfo,
            cookingTimeInfo: model.cookingTimeInfo,
            ingredients: model.ingredients,
            accessibility: accessibilty)
    }
}
