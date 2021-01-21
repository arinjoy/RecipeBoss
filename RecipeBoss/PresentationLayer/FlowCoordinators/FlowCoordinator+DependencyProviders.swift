//
//  ApplicationFlowCoordinatorDependencyProvider.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to
/// satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: class {

    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol RecipeListFlowCoordinatorDependencyProvider: class {
    
    /// Creates UIViewController to show a list of recipes
    func recipeListController(router: RecipeListRouting) -> UIViewController
    
    /// Creates UIViewController to show all the details of a recipe in a different view controller
    func recipeDetailsController(_ viewModel: String) -> UIViewController
}
