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
        
        // Reactive binding to view model to listen for loading, success & failure events
        bind(to: viewModel)
    }
    
    // MARK: - Private Helpers
    
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
        case .success(let photos):
            loadingView.isHidden = true
            update(with: photos, animate: true)
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
                // TODO:
                // let cell = collectionView.dequeueReusableCell(withClass: CustomCell.self, forIndexPath: indexPath)
                // cell.configure(with: recipeModel)
                return UICollectionViewCell()
            }
        )
    }

    func update(with photos: [RecipeModel], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(photos, toSection: .recipes)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}


