//
//  RecipeUseCase.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Combine
import UIKit.UIImage

final class RecipeUseCase: RecipeUseCaseType {

    // MARK: - Depdendency
    
    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType

    // MARK: - Init
    
    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    
    // MARK: - RecipeUseCase
    
    func findRecipes() -> AnyPublisher<Result<[RecipeModel], NetworkError>, Never> {
        return networkService
        .load(Resource<RecipeList>.listOfRecipes())
        .map({ [weak self] (result: Result<RecipeList, NetworkError>) -> Result<[RecipeModel], NetworkError> in
            guard let strongSelf = self else { return .failure(.unknown)}
            switch result {
            case .success(let resonse):
                return .success(resonse.recipes.map { strongSelf.recipeDomainModel(from: $0) })
            case .failure(let error):
                return .failure(error)
            }
        })
        .subscribe(on: Scheduler.background)
        .receive(on: Scheduler.main)
        .eraseToAnyPublisher()
    }
    
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(url) }
        .flatMap { [weak self] url -> AnyPublisher<UIImage?, Never> in
            guard let self = self else { return .just(nil) }
            return self.imageLoaderService.loadImage(from: url)
        }
        .receive(on: Scheduler.main)
        .share()
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Private Helpers
    
    /// Transform a low level recipe data model to higer level domain model
    /// Applies thumbnail image full url construction, some cleanup of empty ingredient string if any etc.
    /// More logic of business level conversion can be added here...
    private func recipeDomainModel(from dataModel: Recipe) -> RecipeModel {
        
        let thumbnailFullUrlString = ApiConstants.recipeThumbnailUrlBasePath + "\(dataModel.thumbnailUrlPath)"
        
        return RecipeModel(
            title: dataModel.title,
            description: dataModel.description,
            thumbnailImage: (url: URL(string: thumbnailFullUrlString),
                             altText: dataModel.thumbnailAltText),
            servesInfo: (label: dataModel.details.amountLabel,
                         amount: dataModel.details.amount),
            preparationTimeInfo: (label: dataModel.details.preparationTimeLabel,
                                  duration: dataModel.details.preparationTime,
                                  text: dataModel.details.preparationTimeText),
            cookingTimeInfo: (label: dataModel.details.cookingTimeLabel,
                              duration: dataModel.details.cookingTime,
                              text: dataModel.details.cookingTimeText),
            ingredients: dataModel.ingredients.compactMap { $0.ingredient }.filter { !$0.isEmpty }
        )
    }
}
