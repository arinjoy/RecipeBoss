//
//  Resource+RecipeListResponse.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 24/1/21.
//

import Foundation

extension Resource {
    
    static func listOfRecipes() -> Resource<RecipeList> {
    
        return Resource<RecipeList>(url: ApiConstants.remoteRecipeListURL, parameters: [:])
    }
}
