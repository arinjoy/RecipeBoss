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
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    
    private var imageCancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.image = UIImage(named: "recipe_placeholder_icon")
        
        applyStyle()
    }
    
    
    // MARK: - Configuration
    
    func configure(withViewModel viewModel: RecipeViewModel) {
    
        
        titleLabel.text = "RECIPE" // FIXED value for now
        subtitleLabel.text = viewModel.title
        

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
        
    }
    
    private func cancelMainImageLoading() {
        imageView.image = nil
        imageCancellable?.cancel()
    }
}
