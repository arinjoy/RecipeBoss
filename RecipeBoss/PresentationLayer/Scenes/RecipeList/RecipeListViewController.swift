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
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, RecipeModel> = {
        return makeDataSource()
    }()
    
    private var cancellables: [AnyCancellable] = []
    
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<RecipeModel, Never>()

    
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
        collectionView.collectionViewLayout = customRecipeGridLayout()
        collectionView.dataSource = dataSource
        
        // TODO:
        // collectionView.delegate = self
    }
    
    private func customRecipeGridLayout() -> UICollectionViewLayout {

        // TODO: improve it or customise as much as needed based on `layoutEnvironment.traitCollection`

        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let isCompact = layoutEnvironment.traitCollection.horizontalSizeClass == .compact
            let itemCount = isCompact ? 2 : 4
            let itemHeight = isCompact ?
                UIScreen.main.bounds.width : UIScreen.main.bounds.width / CGFloat(itemCount) + 60
            let padding: CGFloat = isCompact ? 16 : 24
            
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

// MARK: - Diffable DataSource & updates

extension RecipeListViewController {

    enum Section: CaseIterable {
        case recipes
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, RecipeModel> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, recipeModel in
                let cell = collectionView.dequeueReusableCell(withClass: RecipeCollectionViewCell.self,
                                                               forIndexPath: indexPath)
                cell.configure(withPresentationItem: recipeModel)
                // TODO: cell.accessibility
                return  cell
            }
        )
    }

    func update(with recipes: [RecipeModel], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(recipes, toSection: .recipes)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
