//
//  RecipeListViewModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Combine
import UIKit.UIImage

final class RecipeListViewModel: RecipeListViewModelType {

    
    // MARK: - Private Properties

    /// The latest list of recipes being shown as results of the latest load operation
    private var recipeList: [RecipeViewModel] = []

    /// The sink for the disposables
    private var cancellables: [AnyCancellable] = []
    
    private var imageLoadingQueue = OperationQueue()
    private var imageLoadingOperations: [IndexPath: ImageLoadOperation] = [:]
    
    
    // MARK: - Dependency
    
    private let useCase: RecipeUseCaseType
    private weak var router: RecipeListRouting?
    
    init(useCase: RecipeUseCaseType,
         router: RecipeListRouting?
    ) {
        self.useCase = useCase
        self.router = router
    }
    
    
    // MARK: - RecipeListViewModelType
    
    func transform(input: RecipeListViewModelInput) -> RecipeListViewModelOutput {
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink(receiveValue: { [weak self] recipeViewModel in
               // TODO: self?.router?.showDetails(forRecipe: recipeViewModel)
            })
            .store(in: &cancellables)
        
        let recipesResultsState = self.useCase.findRecipes()
            .map { result -> RecipeListState in
                switch result {
                case .success([]):
                    self.recipeList = []
                    return .noResults
                case .success(let recipes):
                    //self.recipeList = recipes // TODO: Apply presentation layer transform here
                    return .success(self.recipeList)
                case .failure(let error):
                    self.recipeList = []
                    return .failure(error)
                }
            }.eraseToAnyPublisher()
        
        // TODO: handle some initial delay in loading
        let initialLoadingState: RecipeListViewModelOutput = .just(.loading)
        
        return Publishers.Merge(initialLoadingState, recipesResultsState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var imageStore: [IndexPath : UIImage?] = [:]
    
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?) {
        guard imageLoadingOperations[indexPath] == nil, recipeList.count > indexPath.row
        else { return }

        guard let imageURL = recipeList[indexPath.row].imageURL else { return }
        let imageLoader = ImageLoadOperation(withUrl: imageURL)
        imageLoader.completionHandler = updateCellClosure
        imageLoadingQueue.addOperation(imageLoader)
        imageLoadingOperations[indexPath] = imageLoader
    }
    
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath) {
        if let imageLoader = imageLoadingOperations[indexPath] {
            imageLoader.cancel()
            imageLoadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    // MARK: - Private Helpers
    
    // MARK: - Private Helpers

    private func recipeViewModels(from recipes: [RecipeModel]) -> [RecipeViewModel] {
        return recipes.map { recipe in
            return RecipeViewModelTransformer.viewModel(
                from: recipe,
                imageLoader: { [unowned self] url in
                    //self.useCase.loadImage(for: url)
                })
        }
        .compactMap { $0 }
    }
}
