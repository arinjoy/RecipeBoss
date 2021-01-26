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
    @IBOutlet private var imageViewHeightShortConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewHeightTallConstraint: NSLayoutConstraint!
    
    /// Stack view contains the items needed in compact, i.e. grid layout
    @IBOutlet private var compactStackView: UIStackView!
    @IBOutlet private var compactTitleLabel: UILabel!
    @IBOutlet private var compactSubtitleLabel: UILabel!
    
    /// Below Items are shown in potrait mode
    @IBOutlet private var headingTitleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var ingredientsHeadingTitle: UILabel!
    @IBOutlet private var ingredientsListStackView: UIStackView!
    
    
    // MARK: - Properties
    
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
        
        // NOTE: THIS LOGIC IS NOT ENOUGH TO DETECT LANDSCAPE OR POTRAIT MODE
        // Size classes cannot give this value precisely for lareger iPads full screen apps.
        // This below check owrks mostly on iPhones, not on most iPads
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            activateTallerDetailCellMode()
        } else {
            activateCompactGridCellMode()
        }
    }
    
    
    // MARK: - Configuration
    
    func configure(withViewModel viewModel: RecipeViewModel) {
    
        // Used in compact cell mode in landscape grid style
        compactTitleLabel.text = "RECIPE"
        compactSubtitleLabel.text = viewModel.title
        
        // NOTE: THIS LOGIC IS NOT ENOUGH TO DETECT LANDSCAPE OR POTRAIT MODE
        // Size classes cannot give this value precisely for lareger iPads full screen apps.
        // This below check owrks mostly on iPhones, not on most iPads
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            activateTallerDetailCellMode()
        } else {
            activateCompactGridCellMode()
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
        headingTitleLabel.font = .systemFont(ofSize: 26, weight: .bold)
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
        
        let chevronIcon = UIImageView(image: UIImage(systemName: "chevron.forward"))
        chevronIcon.contentMode = .scaleAspectFit
        chevronIcon.tintColor = .darkGray
        NSLayoutConstraint.activate([
            chevronIcon.widthAnchor.constraint(equalToConstant: 16),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.text = item
      
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.spacing = 10
        stack.addArrangedSubview(chevronIcon)
        stack.addArrangedSubview(label)
        ingredientsListStackView.addArrangedSubview(stack)
    }
    
    private func cancelMainImageLoading() {
        imageView.image = nil
        imageCancellable?.cancel()
    }
    
    private func activateCompactGridCellMode() {
        compactStackView.isHidden = false
        imageViewHeightTallConstraint.isActive = true
        imageViewHeightShortConstraint.isActive = false
    }
    
    private func activateTallerDetailCellMode() {
        compactStackView.isHidden = true
        imageViewHeightShortConstraint.isActive = true
        imageViewHeightTallConstraint.isActive = false
    }
}
