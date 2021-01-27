//
//  RecipeUseCase+TestDoubles.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import Foundation
import Combine
import UIKit.UIImage
@testable import RecipeBoss

// MARK: - UseCase Dummy

final class RecipeUseCaseDummy: RecipeUseCaseType {
    func findRecipes() -> AnyPublisher<Result<[RecipeModel], NetworkError>, Never> {
        return AnyPublisher.empty()
    }
    
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return AnyPublisher.empty()
    }
}

// MARK: - UseCase Spy

final class RecipeUseCaseSpy: RecipeUseCaseType {
    
    // Spied calls
    var findRecipesCalled: Bool = false
    var loadImageCalled: Bool = false
    
    func findRecipes() -> AnyPublisher<Result<[RecipeModel], NetworkError>, Never> {
        findRecipesCalled = true
        return Empty().eraseToAnyPublisher()
    }
    
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        loadImageCalled = true
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - UseCase Mock

final class RecipeUseCaseMock: RecipeUseCaseType {
    
    var returningError: Bool
    var error: NetworkError
    var resultingData: [RecipeModel]
    
    init(
        returningError: Bool = false,
        error: NetworkError = NetworkError.unknown,
        resultingData: [RecipeModel] = [TestHelper().sampleRecipeDomainModel()]
    ) {
        self.returningError = returningError
        self.error = error
        self.resultingData = resultingData
    }
    
    func findRecipes() -> AnyPublisher<Result<[RecipeModel], NetworkError>, Never> {
        if returningError {
            return Just(.failure(error)).eraseToAnyPublisher()
        }
        return Just(.success(resultingData)).eraseToAnyPublisher()
    }
    
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Empty().eraseToAnyPublisher()
    }
}

final class RecipeListRouterDummy: RecipeListRouting {
    func showDetails(forRecipe recipeViewModel: RecipeViewModel) {}
}

final class RecipeListRouterSpy: RecipeListRouting {
    var showDetailsCalled: Bool = false
    func showDetails(forRecipe recipeViewModel: RecipeViewModel) {
        showDetailsCalled = true
    }
}
