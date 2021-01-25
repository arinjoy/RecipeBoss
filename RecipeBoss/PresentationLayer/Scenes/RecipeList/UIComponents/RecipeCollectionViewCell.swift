//
//  RecipeCollectionViewCell.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 21/1/21.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    
    
    // MARK: - Configuration
    
    // TODO: with `RecipePresentationItem` type which is transformed at view layer for thwe UI need
    func configure(withPresentationItem item: RecipeModel) {
        
        // TODO: load from URL and bind here
        //imageView.image =
        
        titleLabel.text = "RECIPE"
        subtitleLabel.text = item.title
    }
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyle()
    }
    
    // MARK: - Private Helpers
    
    private func applyStyle() {
        
    }
}
