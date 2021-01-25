//
//  RecipeeListViewModelType.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Combine

struct RecipeeListViewModelInput {

    /// Called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>

    /// Called when the user selected an item from the list
    let selection: AnyPublisher<RecipeModel, Never>

    init(
        appear: AnyPublisher<Void, Never>,
        selection: AnyPublisher<RecipeModel, Never>
    ) {
        self.appear = appear
        self.selection = selection
    }
}

typealias RecipeeListViewModelOutput = AnyPublisher<RecipeListState, Never>

protocol RecipeListViewModelType {
    
    func transform(input: RecipeeListViewModelInput) -> RecipeeListViewModelOutput

}

enum RecipeListState {
    case idle
    case loading
    case success([RecipeModel])
    case noResults
    case failure(NetworkError)
}

extension RecipeListState: Equatable {
    static func == (lhs: RecipeListState, rhs: RecipeListState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsRecipes), .success(let rhsRecipes)): return lhsRecipes == rhsRecipes
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}
