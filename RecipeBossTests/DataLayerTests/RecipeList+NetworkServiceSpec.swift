//
//  RecipeList+NetworkServiceSpec.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 24/1/21.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import RecipeBoss

final class RecipeListNetworkServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Recipe List Service Spec") {
            
            var cancellables: [AnyCancellable] = []
            
            it("should call the load method on `NetworkService` with correct values being set") {
                
                // given
                let netwotkServiceSpy = NetworkServiceSpy()
                
                // when
                _ = netwotkServiceSpy
                    .load(Resource<RecipeList>.listOfRecipes())
                
                // then
                
                // Spied call
                expect(netwotkServiceSpy.loadReourceCalled).to(beTrue())
                
                // Spied values
                expect(netwotkServiceSpy.isLocalStub).to(beFalse())
                
                expect(netwotkServiceSpy.url).toNot(beNil())
                expect(netwotkServiceSpy.url?.absoluteString).to(equal("https://recipeboss.source.url.com.au/recipes"))
                expect(netwotkServiceSpy.parameters).toNot(beNil())
                expect(netwotkServiceSpy.parameters?.count).to(equal(0))
                
                expect(netwotkServiceSpy.request).toNot(beNil())
            }
            
            it("should pass the response from the api client unchanged when succeeds") {
                
                var expectedError: NetworkError?
                var receivedResponse: RecipeList?
                
                // given
                let networkServiceMock = NetworkServiceMock(response: TestHelper().sampleRecipeList())
                
                // when
                networkServiceMock
                    .load(Resource<RecipeList>.listOfRecipes())
                    .sink(receiveValue: { result in
                        switch result {
                        case .success(let response):
                            receivedResponse = response
                        case .failure(let error):
                            expectedError = error
                        }
                     })
                    .store(in: &cancellables)
                
                // then
                expect(expectedError).to(beNil())
                
                expect(receivedResponse).toNot(beNil())
                expect(receivedResponse?.recipes.count).to(equal(2))
                expect(receivedResponse?.recipes.first?.title).to(equal("Curtis Stone's tomato and bread salad with BBQ eggplant and capsicum"))
                expect(receivedResponse?.recipes.first?.description).to(equal("For a crowd-pleasing salad, try this tasty combination of fresh tomato, crunchy bread and BBQ veggies. It’s topped with fresh basil and oregano for a finishing touch."))
                expect(receivedResponse?.recipes.first?.details.amountLabel).to(equal("Serves"))
                expect(receivedResponse?.recipes.first?.details.amount).to(equal(8))
                expect(receivedResponse?.recipes.first?.details.cookingTime).to(equal(15))
            }
            
            it("should pass the error from the api client when fails") {
            
                var expectedError: NetworkError?
                var receivedResponse: RecipeList?
                
                // given
                let networkServiceMock = NetworkServiceMock(
                    response: TestHelper().sampleRecipeList(),
                    returningError: true,
                    error: NetworkError.timeout)
                
                // when
                networkServiceMock
                    .load(Resource<RecipeList>.listOfRecipes())
                    .sink(receiveValue: { result in
                        switch result {
                        case .success(let response):
                            receivedResponse = response
                        case .failure(let error):
                            expectedError = error
                        }
                     })
                    .store(in: &cancellables)
                
                // then
                expect(expectedError).toNot(beNil())
                expect(receivedResponse).to(beNil())
            }
        }
    }
}
