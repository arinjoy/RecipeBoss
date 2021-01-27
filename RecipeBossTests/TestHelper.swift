//
//  TestHelper.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
@testable import RecipeBoss

final class TestHelper {
    
    func sampleRecipeList() -> RecipeList {
        let jsonDecoder = JSONDecoder()
        let testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "recipe_sample_data")
        let mappedItem = try! jsonDecoder.decode(RecipeList.self, from: testJSONData)
        return mappedItem
    }
    
    func sampleRecipeDomainModel() -> RecipeModel {
        let dataModel = sampleRecipeList().recipes.first!
        return RecipeModel(
            title: dataModel.title,
            description: dataModel.description,
            thumbnailImage: (url: URL(string: "some.image.url"),
                             altText: dataModel.thumbnailAltText),
            servesInfo: (label: dataModel.details.amountLabel,
                         amount: dataModel.details.amount),
            preparationTimeInfo: (label: dataModel.details.preparationTimeLabel,
                                  duration: dataModel.details.preparationTime,
                                  text: dataModel.details.preparationTimeText),
            cookingTimeInfo: (label: dataModel.details.cookingTimeLabel,
                              duration: dataModel.details.cookingTime,
                              text: dataModel.details.cookingTimeText),
            ingredients: dataModel.ingredients.compactMap { $0.ingredient }.filter { !$0.isEmpty }
        )
    }
}
