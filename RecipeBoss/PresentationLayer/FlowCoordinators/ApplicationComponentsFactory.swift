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
    
    // TODO: when lower level is done
    // Add useCase
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

        // TODO:
        // let recipeListVM = RecipeListViewModel(router: router)
        
        // TODO: Improve this VM injection logic differently if possible
        // recipeListVC.viewModel = recipeListVM
        return recipeListVC
    }
    
    func recipeDetailsController(_ viewModel: String) -> UIViewController {
        
        // TODO: do when needed
        return UIViewController()
    }
}
