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
        
        configureUI()
        
        // Reactive binding to view model to listen for loading, success & failure events
        bind(to: viewModel)
    }
    
    
    // MARK: - Private Helpers
    
    private func configureUI() {

        collectionView.registerNib(cellClass: RecipeCollectionViewCell.self)
        collectionView.collectionViewLayout = customRecipeGridLayout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private lazy var customRecipeGridLayout: UICollectionViewLayout = {

        // TODO: improve it or customise as much as needed based on `layoutEnvironment.traitCollection`

        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let isCompact = layoutEnvironment.traitCollection.horizontalSizeClass == .compact &&
                layoutEnvironment.traitCollection.verticalSizeClass == .regular

            let padding: CGFloat = 16
            let itemCount = isCompact ? 1 : 2
            let itemHeight = isCompact ?
                UIScreen.main.bounds.height - 100 : UIScreen.main.bounds.width / CGFloat(itemCount) - 2*padding
            
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                           subitem: item,
                                                           count: itemCount)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(padding)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: padding,
                                                            leading: padding,
                                                            bottom: padding,
                                                            trailing: padding)
            section.interGroupSpacing = padding
            return section
        })
    }()

    
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
            // TODO:
            loadingView.isHidden = false
        case .noResults:
            // TODO:
            break
        case .failure(let error):
            // TODO:
            break
        case .success(let recipes):
            loadingView.isHidden = true
            update(with: recipes, animate: true)
        break
        }
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

    enum Section: CaseIterable {
        case recipes
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, RecipeViewModel> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, recipeViewModel in
                let cell = collectionView.dequeueReusableCell(withClass: RecipeCollectionViewCell.self,
                                                               forIndexPath: indexPath)
                cell.configure(withViewModel: recipeViewModel)
                // TODO: cell.accessibility
                return  cell
            }
        )
    }

    func update(with recipes: [RecipeViewModel], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(recipes, toSection: .recipes)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
