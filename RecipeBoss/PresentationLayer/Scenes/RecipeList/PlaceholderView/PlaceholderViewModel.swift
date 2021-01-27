//
//  PlaceholderViewModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import Foundation
import UIKit.UIImage

struct PlaceholderViewModel {

    let image: UIImage
    let title: String
    let description: String?
    
    var accessibility: PlaceholderAccessibility?

    // TODO: load these string copies form `.strings` file maybe...
    
    static var noResults: PlaceholderViewModel {
        let title = "No recipe found!"
        let description = "Please try again another time."
        let image = UIImage(systemName: "binoculars") ?? UIImage()
        return PlaceholderViewModel(
            image: image,
            title: title,
            description: description,
            accessibility: PlaceholderAccessibility(
                container: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.rootViewId),
                image: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.imageId,
                                                  label: "Not found symbol",
                                                  traits: .image),
                title: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.titleId,
                                                  traits: .header),
                description: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.descriptionId,
                                                        traits: .staticText)
            )
        )
    }

    static var genericError: PlaceholderViewModel {
        let title = "Oops! Can't load recipes."
        let description = "Seems like there might be some technical issue. Please try again."
        let image = UIImage(systemName: "exclamationmark.icloud") ?? UIImage()
        return PlaceholderViewModel(
            image: image,
            title: title,
            description: description,
            accessibility: PlaceholderAccessibility(
                container: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.rootViewId),
                image: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.imageId,
                                                  label: "Error occured symbol",
                                                  traits: .image),
                title: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.titleId,
                                                  traits: .header),
                description: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.descriptionId,
                                                        traits: .staticText)
            )
        )
    }
    
    static var connectivityError: PlaceholderViewModel {
        let title = "You're offline!"
        let description = "Seems like you're not connected to Internet. Please make sure that you have WiFi or Mobile network."
        let image = UIImage(systemName: "wifi.exclamationmark") ?? UIImage()
        return PlaceholderViewModel(
            image: image,
            title: title,
            description: description,
            accessibility: PlaceholderAccessibility(
                container: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.rootViewId),
                image: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.imageId,
                                                  label: "Wifi disconnected symbol",
                                                  traits: .image),
                title: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.titleId,
                                                  traits: .header),
                description: AccessibilityConfiguration(identifier: AccessibilityIdentifiers.Placeholder.descriptionId,
                                                        traits: .staticText)
            )
        )
    }
}

struct PlaceholderAccessibility {
    let container: AccessibilityConfiguration
    let image: AccessibilityConfiguration
    let title: AccessibilityConfiguration
    let description: AccessibilityConfiguration
}
