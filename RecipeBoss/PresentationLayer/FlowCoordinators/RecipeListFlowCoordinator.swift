//
//  RecipeListFlowCoordinator.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import UIKit

/// The `RecipeListFlowCoordinator` takes control over the flows starting in the recipe list/carausel screen
class RecipeListFlowCoordinator: FlowCoordinator {
    
    private let rootController: UINavigationController
    private let dependencyProvider: RecipeListFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: RecipeListFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let listController = self.dependencyProvider.recipeListController(router: self)
        self.rootController.setViewControllers([listController], animated: false)
    }
}

extension RecipeListFlowCoordinator: RecipeListRouting {
    func showDetails(forRecipe recipeViewModel: RecipeViewModel) {
        let controller = self.dependencyProvider.recipeDetailsController(recipeViewModel)
        self.rootController.pushViewController(controller, animated: true)
    }
}
