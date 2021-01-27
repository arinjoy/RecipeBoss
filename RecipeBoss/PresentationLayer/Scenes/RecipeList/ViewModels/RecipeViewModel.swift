//
//  RecipeViewModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 26/1/21.
//

import Foundation
import UIKit.UIImage
import Combine

struct RecipeViewModel {
    
    let title: String
    let description: String
    
    let imageURL: URL?
    let imageAltText: String
    let thumbImage: AnyPublisher<UIImage?, Never>
    
    let servesInfo: (label: String, amount: Int)
    let preparationTimeInfo: (label: String, duration: Int, text: String)
    let cookingTimeInfo: (label: String, duration: Int, text: String)
    let ingredients: [String]
    
    var accessibility: RecipeAccessibility?
}


/// Used for `NSDiffableDataSource`
extension RecipeViewModel: Hashable {

    static func == (lhs: RecipeViewModel, rhs: RecipeViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title + "\(description)")
    }
}


