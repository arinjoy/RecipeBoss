//
//  RecipeListViewController.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 21/1/21.
//

import UIKit
import Combine

final class RecipeListViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    
    var viewModel: RecipeListViewModelType!
    
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<RecipeModel, Never>()

    // MARK: - Lifecycle
    
    @IBOutlet private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reactive binding to view model to listen for loading, success & failure events
        bind(to: viewModel)
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
               // TODO: self?.render(state)
                print (state)
            }).store(in: &cancellables)
    }
}

