//
//  RecipeCollectionViewCell.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 21/1/21.
//

import UIKit
import Combine

final class RecipeCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {
    
    // MARK: - Outlets
    @IBOutlet private var containerView: UIView!
        
    /// Image view used in common for both modes
    @IBOutlet private var imageView: UIImageView!
    
    /// Stack view contains the items needed in compact, i.e. grid layout
    @IBOutlet weak var compactStackView: UIStackView!
    @IBOutlet private var compactTitleLabel: UILabel!
    @IBOutlet private var compactSubtitleLabel: UILabel!
    
    /// Below Items are shown in potrait mode
    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsHeadingTitle: UILabel!
    @IBOutlet weak var ingredientsListStackView: UIStackView!
    
    
    private var imageCancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.image = UIImage(named: "recipe_placeholder_icon")
        
        applyStyle()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
                
        // Only this view is programatically managed to show/hide.
        // The rest of the items are all by default hidden except `wChR`.
        // They are managed via interface builder
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            compactStackView.isHidden = true
        } else {
            compactStackView.isHidden = false
        }
    }
    
    
    // MARK: - Configuration
    
    func configure(withViewModel viewModel: RecipeViewModel) {
    
        // Used in compact cell mode in landscape grid style
        compactTitleLabel.text = "RECIPE"
        compactSubtitleLabel.text = viewModel.title
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            compactStackView.isHidden = true
        } else {
            compactStackView.isHidden = false
        }
        
        // Used in longer view mode in potrait style
        headingTitleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        ingredientsHeadingTitle.text = "Ingredients"
        
        viewModel.ingredients.forEach { ingredient in
            addIngredientItemToStackView(item: ingredient)
        }
        
        containerView.layoutIfNeeded()

        imageCancellable = viewModel.thumbImage
            .receive(on: Scheduler.main)
            .sink { [unowned self] image in
                self.showImage(image: image)
            }
    }
    
    func showImage(image: UIImage?) {
        cancelMainImageLoading()

        UIView.transition(
            with: imageView,
            duration: 0.3,
            options: [.curveEaseOut, .transitionCrossDissolve],
            animations: {
                self.imageView.image = image
            })
    }
    
    
    // MARK: - Private Helpers
    
    private func applyStyle() {
        headingTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headingTitleLabel.textColor = .darkText
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .darkGray
        
        compactTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        compactTitleLabel.textColor = .systemRed
        compactSubtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        compactSubtitleLabel.textColor = .darkGray
        
        ingredientsHeadingTitle.font = .systemFont(ofSize: 22, weight: .bold)
        ingredientsHeadingTitle.textColor = .darkText
        
    }
    
    private func addIngredientItemToStackView(item: String) {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.text = item
        ingredientsListStackView.addArrangedSubview(label)
    }
    
    private func cancelMainImageLoading() {
        imageView.image = nil
        imageCancellable?.cancel()
    }    
}
