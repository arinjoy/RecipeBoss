//
//  PlaceholderViewModel.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import UIKit

final class PlaceholderViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyles()
        configureAccessibility()
    }

    // MARK: - Public
    
    func showNoResults() {
        render(viewModel: PlaceholderViewModel.noResults)
    }

    func showGenericError() {
        render(viewModel: PlaceholderViewModel.genericError)
    }
    
    func showConnectivityError() {
        render(viewModel: PlaceholderViewModel.connectivityError)
    }

    // MARK: - Private Helpers
    
    private func render(viewModel: PlaceholderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image
    }

    private func applyStyles() {
        view.backgroundColor = .white

        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit

        for label in [titleLabel, descriptionLabel] {
            label?.textColor = .darkText
            label?.adjustsFontForContentSizeCategory = true
        }

        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    private func configureAccessibility() {
        view.accessibilityIdentifier = "" //AccessibilityIdentifiers.ListPlaceholder.rootViewId
        titleLabel.accessibilityIdentifier = "" //AccessibilityIdentifiers.ListPlaceholder.titleLabelId
        descriptionLabel.accessibilityIdentifier = ""
            // AccessibilityIdentifiers.ListPlaceholder.descriptionLabelId
        
        titleLabel.accessibilityTraits = .header
        descriptionLabel.accessibilityTraits = .staticText
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
    }
}
