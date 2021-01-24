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
}
