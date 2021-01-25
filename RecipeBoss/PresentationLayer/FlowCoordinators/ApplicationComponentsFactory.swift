//
//  ApplicationComponentsFactory.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//


import UIKit

/// The ApplicationComponentsFactory takes responsibity of creating application components and
/// establishing dependencies between them.
final class ApplicationComponentsFactory {
    
    private lazy var useCase: RecipeUseCaseType = {
        return RecipeUseCase(
            networkService: ServicesProvider.localStubbedProvider().network
        )
    }()

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = UIColor.black
        return rootViewController
    }
}

extension ApplicationComponentsFactory: RecipeListFlowCoordinatorDependencyProvider {

    func recipeListController(router: RecipeListRouting) -> UIViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let recipeListVC = storyboard.instantiateViewController(withIdentifier: "RecipeList") as? RecipeListViewController
        else {
            fatalError("`RecipeListViewController` could not be constructed out of main storyboard")
        }

        let recipeListVM = RecipeListViewModel(useCase: useCase, router: router)
        
        // TODO: Improve this VM injection logic differently if possible
        recipeListVC.viewModel = recipeListVM
        return recipeListVC
    }
    
    func recipeDetailsController(_ viewModel: String) -> UIViewController {
        
        // TODO: do when needed
        return UIViewController()
    }
}
