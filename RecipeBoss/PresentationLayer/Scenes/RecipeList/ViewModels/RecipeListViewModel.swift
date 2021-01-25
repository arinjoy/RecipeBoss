//
//  RecipeListViewModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Combine

final class RecipeListViewModel: RecipeListViewModelType {

    
    // MARK: - Private Properties

    /// The latest list of recipes being shown as results of the latest load operation
    private var recipeList: [RecipeModel] = []

    /// The sink for the disposables
    private var cancellables: [AnyCancellable] = []
    
    
    // MARK: - Dependency
    
    private let useCase: RecipeUseCase
    private weak var router: RecipeListRouting?
    
    
    // MARK: - RecipeListViewModelType
    
    func transform(input: RecipeeListViewModelInput) -> RecipeeListViewModelOutput {
        
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
                    self.recipeList = recipes // TODO: Apply presentation layer transform here
                    return .success(self.recipeList)
                case .failure(let error):
                    self.recipeList = []
                    return .failure(error)
                }
            }.eraseToAnyPublisher()
        
        // TODO: handle some initial delay in loading
        let initialLoadingState: RecipeeListViewModelOutput = .just(.loading)
        
        return Publishers.Merge(initialLoadingState, recipesResultsState)
            .removeDuplicates()
            .eraseToAnyPublisher()

    }
}
