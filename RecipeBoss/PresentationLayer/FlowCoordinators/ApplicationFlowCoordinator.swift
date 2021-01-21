//
//  ApplicationFlowCoordinator.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import UIKit

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: class {

    /// Stars the flow
    func start()
}


/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & RecipeListFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = UIColor.black

        self.window.rootViewController = navigationController

        let recipeListFlowCoordinator = RecipeListFlowCoordinator(
            rootController: navigationController,
            dependencyProvider: self.dependencyProvider)
        
        recipeListFlowCoordinator.start()

        self.childCoordinators = [recipeListFlowCoordinator]
    }

}
