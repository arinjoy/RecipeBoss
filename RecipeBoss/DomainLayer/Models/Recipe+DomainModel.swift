//
//  DomainModels.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation

/// A domain level representation of a recipe.
/// Information are grouped into their tuples to reduce some hierarchy, a flattened a bit from their low level data model structure
struct RecipeModel {
    let title: String
    let description: String
    let thumbnailImage: (url: URL?, altText: String)
    let servesInfo: (label: String, amount: Int)
    let preparationTimeInfo: (label: String, duration: Int, text: String)
    let cookingTimeInfo: (label: String, duration: Int, text: String)
    let ingredients: [String]
}

extension RecipeModel: Hashable {

    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
