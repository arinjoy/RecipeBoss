//
//  RecipeListRouting.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import Foundation

protocol RecipeListRouting: AnyObject {
    
    /// Presents the details screen of a recipe
    func showDetails(forRecipe recipeViewModel: RecipeViewModel)
}

