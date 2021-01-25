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
        
        // TODO: Manage accessbility stuff here
        
        return RecipeViewModel(
            title: model.title,
            description: model.description,
            imageURL: model.thumbnailImage.url,
            imageAltText: model.thumbnailImage.altText,
            thumbImage: imageLoader(model.thumbnailImage.url),
            servesInfo: model.servesInfo,
            preparationTimeInfo: model.preparationTimeInfo,
            cookingTimeInfo: model.cookingTimeInfo,
            ingredients: model.ingredients)
        
        return nil
    }
}
