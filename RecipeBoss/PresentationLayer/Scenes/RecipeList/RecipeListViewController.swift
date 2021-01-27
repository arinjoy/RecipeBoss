//
//  RecipeListViewController.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 21/1/21.
//

import UIKit
import Combine

final class RecipeListViewController: UIViewController {
    
    // MARK: - Outlets / UI Elements
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var loadingView: UIView!
    
    private lazy var placeholderViewController = {
        return PlaceholderViewController(nibName: nil, bundle: nil)
    }()
    
    var viewModel: RecipeListViewModelType!
    
    // MARK: - Private properties
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, RecipeViewModel> = {
        return makeDataSource()
    }()
    
    private var cancellables: [AnyCancellable] = []
    
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<RecipeViewModel, Never>()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inject the placeholder view at start as
        // it will be needeed to be shownif no results or error
        add(placeholderViewController)
        
        configureUI()
        
        // Reactive binding to view model to listen for loading, success & failure events
        bind(to: viewModel)
    }
    
    
    // MARK: - Private Helpers
    
    private func configureUI() {
        collectionView.registerNib(cellClass: RecipeCollectionViewCell.self)
        collectionView.collectionViewLayout = customRecipeGridOrPagingLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func bind(to viewModel: RecipeListViewModelType) {
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = RecipeListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                             selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output
            .receive(on: Scheduler.main)
            .sink(receiveValue: { [weak self] state in
                self?.render(state)
            }).store(in: &cancellables)
    }
    
    private func render(_ state: RecipeListState) {
        switch state {
        case .loading:
            placeholderViewController.view.isHidden = true
            loadingView.isHidden = false
            update(with: [], animate: true)
        
        case .noResults:
            placeholderViewController.view.isHidden = false
            placeholderViewController.showNoResults()
            loadingView.isHidden = true
            update(with: [], animate: true)
        
        case .failure(let error):
            placeholderViewController.view.isHidden = false
            
            // Note: Handle more and more custom error cases to tweak the
            // error message copy if needed...
            
            switch error {
            case .networkFailure, .timeout:
                placeholderViewController.showConnectivityError()
            default:
                placeholderViewController.showGenericError()
            }

            loadingView.isHidden = true
            update(with: [], animate: true)
            
        case .success(let recipes):
            loadingView.isHidden = true
            update(with: recipes, animate: true)
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout based layout calculation

extension RecipeListViewController {
    
    private func customRecipeGridOrPagingLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // NOTE: THIS LOGIC IS NOT ENOUGH TO DETECT LANDSCAPE OR POTRAIT MODE
            // Size classes cannot give this value precisely for lareger iPads full screen apps.
            // This below check works mostly on iPhones, not on most iPads
            
            let isCompactWidth = layoutEnvironment.traitCollection.horizontalSizeClass == .compact &&
                layoutEnvironment.traitCollection.verticalSizeClass == .regular
            
            if isCompactWidth {
                return self.generatePotraitPagingLayout()
            } else {
                return self.generateLandscapeGridLayout()
            }
        })
    }
    
    /// Generates a grid style layout
    private func generateLandscapeGridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    /// Generates paging style layout to flick left-right The cell item is tall and take up all of the vertiocal space
    private func generatePotraitPagingLayout() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: NSCollectionLayoutDimension.absolute(CGFloat(UIScreen.main.bounds.height + 300)))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      // Show one item plus peek on narrow screen
      let groupFractionalWidth = 0.95
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
        heightDimension: .fractionalWidth(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitem: item,
                                                     count: 1)
      group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 50, trailing: 16)

      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      return section
    }
}

extension RecipeListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        // Send reactive signal as selection is made and pass the recipe view model being selected
        selection.send(snapshot.itemIdentifiers[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RecipeCollectionViewCell else { return }

        // Check if image store has this image loaded already, then update using the same
        if let image = viewModel.imageStore[indexPath] {
            cell.showImage(image: image)
        } else {
            // Else, add image loading operation and attach the image update closure
            let updateCellClosure: (UIImage?) -> Void = { [weak self] image in
                cell.showImage(image: image)
                self?.viewModel.imageStore[indexPath] = image
                self?.viewModel.removeImageLoadOperation(atIndexPath: indexPath)
            }
            viewModel.addImageLoadOperation(atIndexPath: indexPath,
                                            updateCellClosure: updateCellClosure)
        }
    }
}

// MARK: - Diffable DataSource & updates

extension RecipeListViewController {

    private enum Section: CaseIterable {
        case recipes
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, RecipeViewModel> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, recipeViewModel in
                let cell = collectionView.dequeueReusableCell(withClass: RecipeCollectionViewCell.self,
                                                              forIndexPath: indexPath)
                cell.configure(withViewModel: recipeViewModel)
                return  cell
            }
        )
    }

    private func update(with recipes: [RecipeViewModel], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(recipes, toSection: .recipes)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
