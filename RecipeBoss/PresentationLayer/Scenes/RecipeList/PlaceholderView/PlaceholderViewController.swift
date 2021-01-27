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
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        viewModel.accessibility?.container.apply(to: view)
        viewModel.accessibility?.image.apply(to: imageView)
        viewModel.accessibility?.title.apply(to: titleLabel)
        viewModel.accessibility?.description.apply(to: descriptionLabel)
    }

    private func applyStyles() {
        view.backgroundColor = .white
        
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true

        for label in [titleLabel, descriptionLabel] {
            label?.textColor = .darkText
            label?.adjustsFontForContentSizeCategory = true
        }

        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
    }
}
