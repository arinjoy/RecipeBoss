//
//  RecipesUseCaseType.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import Foundation
import Combine
import UIKit.UIImage

protocol RecipeUseCaseType {

    /// Loads a list of recipes from some source
    /// Returns results in terms of domain level `RecipeModel` array or `NetworkError` if any
    func findRecipes() -> AnyPublisher<Result<[RecipeModel], NetworkError>, Never>

}
