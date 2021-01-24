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
        }
    }
}

