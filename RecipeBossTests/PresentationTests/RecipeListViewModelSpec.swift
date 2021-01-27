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
                
                context("list of recipes loaded successfully") {
                    
                    var useCaseMock: RecipeUseCaseMock!
                    var recipesReceived: [RecipeViewModel]?
                    
                    it("should load the list of recipes") {
                        
                        // given
                        useCaseMock = RecipeUseCaseMock(returningError: false)
                        viewModel = RecipeListViewModel(useCase: useCaseMock, router: RecipeListRouterDummy())
                        
                        let input = RecipeListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                                             selection: selection.eraseToAnyPublisher())

                        // when
                        let output = viewModel.transform(input: input)
                        
                        // then
                        output
                            .sink(receiveValue: { state in
                                
                                switch state {
                                case .success(let results):
                                    recipesReceived = results
                                    
                                    expect(recipesReceived).toEventuallyNot(beNil())
                                    expect(recipesReceived?.first?.title).toEventually(
                                        equal("Curtis Stone's tomato and bread salad with BBQ eggplant and capsicum"))
                                    
                                    // `RecipeViewModelTransformer` is individually unit tested. No point
                                    // of checking all them fields again
                                
                                case .failure(_):
                                    fail("Should not fail when supposed to pass")
                                default:
                                    break
                                }
                            }).store(in: &cancellables)
                    }
                }
                
                context("list of recipes not loaded due to failure") {
                    
                    var useCaseMock: RecipeUseCaseMock!
                    var errorReceived: NetworkError?
                    
                    it("should not load the list of recipes and detect error") {
                        
                        // given
                        useCaseMock = RecipeUseCaseMock(returningError: true)
                        viewModel = RecipeListViewModel(useCase: useCaseMock, router: RecipeListRouterDummy())
                        
                        let input = RecipeListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                                             selection: selection.eraseToAnyPublisher())

                        // when
                        let output = viewModel.transform(input: input)
                        
                        // then
                        output
                            .sink(receiveValue: { state in
                                switch state {
                                case .failure(let error):
                                    errorReceived = error
                                    expect(errorReceived).toEventuallyNot(beNil())
                                case .success(_):
                                    fail("Should not pass when supposed to fail")
                                default:
                                    break
                                }
                            }).store(in: &cancellables)
                    }
                }
            
                context("list of recipes loaded but as empty") {
                    
                    var useCaseMock: RecipeUseCaseMock!
                    
                    it("should load emty state") {
                        
                        // given
                        useCaseMock = RecipeUseCaseMock(returningError: false, resultingData: [])
                        viewModel = RecipeListViewModel(useCase: useCaseMock, router: RecipeListRouterDummy())
                        
                        let input = RecipeListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                                             selection: selection.eraseToAnyPublisher())

                        // when
                        let output = viewModel.transform(input: input)
                        
                        // then
                        output
                            .sink(receiveValue: { state in
                                
                                switch state {
                                case .noResults:
                                    assert(true, "No results state detected")
                                case .failure(_):
                                    fail("Should not fail when supposed to pass")
                                default:
                                    break
                                }
                                
                            }).store(in: &cancellables)
                    }
                }
            }
        }
    }
}
