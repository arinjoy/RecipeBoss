//
//  RecipeUseCaseSpec.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 25/1/21.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import RecipeBoss

final class RecipeUseCaseSpec: QuickSpec {
    
    var recipeDomainModels: [RecipeModel]!
    var error: NetworkError!
    
    override func spec() {
        
        var useCase: RecipeUseCaseType!
        var cancellables: [AnyCancellable] = []

        describe("Recipe UseCase Spec") {
            
            beforeEach {
                self.recipeDomainModels = nil
                self.error = nil
            }
            
            context("Find the list of recipes") {
                
                it("should call network service correctly") {
                    
                    // given
                    let serviceSpy = NetworkServiceSpy()
                    useCase = RecipeUseCase(networkService: serviceSpy)
                    
                    // when
                    _ = useCase.findRecipes()
                    
                    // then
                    expect(serviceSpy.loadReourceCalled).toEventually(beTrue())
                }
                
                context("network service failed") {
                    
                    it("should return the error correctly for any error") {
                        
                        // given
                        let serviceMock = NetworkServiceMock(response: TestHelper().sampleRecipeList(),
                                                             returningError: true, // fails
                                                             error: NetworkError.unAuthorized)
                        useCase = RecipeUseCase(networkService: serviceMock)
                        
                        // when
                        useCase
                            .findRecipes()
                            .sink(receiveValue: { result in
                                switch result {
                                case .success(let response):
                                    self.recipeDomainModels = response
                                case .failure(let error):
                                    self.error = error
                                }
                             })
                            .store(in: &cancellables)
                    
                        // then
                        expect(self.recipeDomainModels).toEventually(beNil())
                        expect(self.error).toEventuallyNot(beNil())
                    }
                }
                
                context("network service succeeded") {
                    
                    it("should process the low level data response correctly and apply business transformation correctly") {
                        
                        // given
                        let serviceMock = NetworkServiceMock(response: TestHelper().sampleRecipeList(),
                                                             returningError: false) // succeeds
                        useCase = RecipeUseCase(networkService: serviceMock)
                        
                        // when
                        useCase
                            .findRecipes()
                            .sink(receiveValue: { result in
                                switch result {
                                case .success(let response):
                                    self.recipeDomainModels = response
                                case .failure(let error):
                                    self.error = error
                                }
                             })
                            .store(in: &cancellables)
                        
                        // then
                        
                        // Data is being mapped correctly
                        expect(self.error).toEventually(beNil())
                        expect(self.recipeDomainModels).toEventuallyNot(beNil())
                        
                        expect(self.recipeDomainModels.count).toEventually(equal(2))
                        
                        expect(self.recipeDomainModels.first?.title).toEventually(equal("Curtis Stone's tomato and bread salad with BBQ eggplant and capsicum"))
                        expect(self.recipeDomainModels.first?.description).toEventually(equal("For a crowd-pleasing salad, try this tasty combination of fresh tomato, crunchy bread and BBQ veggies. It’s topped with fresh basil and oregano for a finishing touch."))
                        
                        expect(self.recipeDomainModels.first?.thumbnailImage.url?.absoluteString).toEventually(equal("https://coles.com.au/content/dam/coles/inspire-create/thumbnails/Tomato-and-bread-salad-480x288.jpg"))
                        expect(self.recipeDomainModels.first?.thumbnailImage.altText).toEventually(equal("Tomato, bread and eggplant salad served in a large plate topped with basil leaves with vinaigrette on the side"))
                        
                        expect(self.recipeDomainModels.first?.servesInfo.label).toEventually(equal("Serves"))
                        expect(self.recipeDomainModels.first?.servesInfo.amount).toEventually(equal(8))
                        
                        expect(self.recipeDomainModels.first?.preparationTimeInfo.label).toEventually(equal("Prep"))
                        expect(self.recipeDomainModels.first?.preparationTimeInfo.duration).toEventually(equal(15))
                        expect(self.recipeDomainModels.first?.preparationTimeInfo.text).toEventually(equal("15m"))
                        
                        expect(self.recipeDomainModels.first?.cookingTimeInfo.label).toEventually(equal("Cooking"))
                        expect(self.recipeDomainModels.first?.cookingTimeInfo.duration).toEventually(equal(15))
                        expect(self.recipeDomainModels.first?.cookingTimeInfo.text).toEventually(equal("15m"))
                        
                        expect(self.recipeDomainModels.first?.ingredients.count).toEventually(equal(5))
                        expect(self.recipeDomainModels.first?.ingredients[0]).toEventually(equal("1 cup (250ml) extra virgin olive oil, divided"))
                        expect(self.recipeDomainModels.first?.ingredients[1]).toEventually(equal("4 cups (240g) 2cm-pieces day-old Coles Bakery Stone Baked by Laurent Pane Di Casa"))
                        
                    }
                }
            }
        }
    }
}
