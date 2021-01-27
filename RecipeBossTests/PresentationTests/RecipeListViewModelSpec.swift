//
//  RecipeListViewModelSpec.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import Combine
import Quick
import Nimble
@testable import RecipeBoss

final class RecipeListViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("Recipe List ViewModel Spec") {
            
            var cancellables: [AnyCancellable] = []
            
            var viewModel: RecipeListViewModel!
            
            var appear: PassthroughSubject<Void, Never>!
            var selection: PassthroughSubject<RecipeViewModel, Never>!
            
            beforeEach {
                appear = PassthroughSubject<Void, Never>()
                selection = PassthroughSubject<RecipeViewModel, Never>()
            }
            
            afterEach {
                cancellables.forEach { $0.cancel() }
                cancellables.removeAll()
            }
        
            context("while communicating with useCase") {
                
                var useCaseSpy: RecipeUseCaseSpy!
                
                it("should talk to useCase when data loading is needed") {
                    
                    // given
                    useCaseSpy = RecipeUseCaseSpy()
                    viewModel = RecipeListViewModel(useCase: useCaseSpy, router: RecipeListRouterDummy())
                    
                    let input = RecipeListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                                         selection: selection.eraseToAnyPublisher())

                    // when
                    let output = viewModel.transform(input: input)
                    
                    // then
                    output
                        .sink(receiveValue: { state in
                            expect(useCaseSpy.findRecipesCalled).toEventually(beTrue())
                            expect(state).toEventually(equal(.loading))
                        }).store(in: &cancellables)
                }
            }
        }
    }
}
