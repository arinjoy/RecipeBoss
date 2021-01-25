//
//  RecipeeListViewModelType.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Combine
import UIKit.UIImage

struct RecipeListViewModelInput {

    /// Called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>

    /// Called when the user selected an item from the list
    let selection: AnyPublisher<RecipeViewModel, Never>

    init(
        appear: AnyPublisher<Void, Never>,
        selection: AnyPublisher<RecipeViewModel, Never>
    ) {
        self.appear = appear
        self.selection = selection
    }
}

typealias RecipeListViewModelOutput = AnyPublisher<RecipeListState, Never>

protocol RecipeListViewModelType {
    
    func transform(input: RecipeListViewModelInput) -> RecipeListViewModelOutput
    
    /// A cache/store of images loaded for recipe photo images
    var imageStore: [IndexPath: UIImage?] { get set }

    /// Will add an image loading opeation at a specified indexPath (if not already added)
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?)

    /// Will remove an image loading opeation at a specified indexPath (if exists)
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath)

}

enum RecipeListState {
    case loading
    case success([RecipeViewModel])
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
