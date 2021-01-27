//
//  RecipeViewModelTransformerSpec.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 27/1/21.
//

import Combine
import Quick
import Nimble
@testable import RecipeBoss

final class RecipeViewModelTransformerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Recipe ViewModel Transformer Spec") {
            
            var trasformer: RecipeViewModelTransformer!
            var result: RecipeViewModel!
            
            beforeEach {
                trasformer = RecipeViewModelTransformer()
                result = trasformer.viewModel(from: TestHelper().sampleRecipeDomainModel(),
                                              imageLoader: { _ in
                                                return AnyPublisher.empty()
                                              })
            }
            
            it("should tranform raw/domain data item correctly into its correct presentation view model item") {
        
                expect(result).toNot(beNil())
                
                expect(result.title).to(equal("Curtis Stone's tomato and bread salad with BBQ eggplant and capsicum"))
                expect(result.description).to(equal("For a crowd-pleasing salad, try this tasty combination of fresh tomato, crunchy bread and BBQ veggies. It’s topped with fresh basil and oregano for a finishing touch."))
                expect(result.imageURL?.absoluteString).to(equal("some.image.url"))
                expect(result.imageAltText).to(equal("Tomato, bread and eggplant salad served in a large plate topped with basil leaves with vinaigrette on the side"))
                expect(result.servesInfo.label).to(equal("Serves"))
                expect(result.servesInfo.amount).to(equal(8))
                expect(result.preparationTimeInfo.label).to(equal("Prep"))
                expect(result.preparationTimeInfo.duration).to(equal(15))
                expect(result.preparationTimeInfo.text).to(equal("15m"))
                expect(result.cookingTimeInfo.label).to(equal("Cooking"))
                expect(result.cookingTimeInfo.duration).to(equal(15))
                expect(result.cookingTimeInfo.text).to(equal("15m"))
                
                expect(result.accessibility?.container.identifier).to(equal("RecipeDetail.cell"))
                
                expect(result.accessibility?.title.identifier).to(equal("RecipeDetail.mainHeading"))
                expect(result.accessibility?.title.traits).to(equal(.header))
                
                expect(result.accessibility?.description.identifier).to(equal("RecipeDetail.description"))
                expect(result.accessibility?.description.traits).to(equal(.staticText))
                
                expect(result.accessibility?.image.identifier).to(equal("RecipeDetail.thumbImage"))
                expect(result.accessibility?.image.traits).to(equal(.image))
                
                expect(result.accessibility?.servesInfo.identifier).to(equal("RecipeDetail.servesInfo"))
                expect(result.accessibility?.servesInfo.traits).to(equal(.staticText))
                expect(result.accessibility?.servesInfo.label).to(equal("Serves, 8 people"))
                
                expect(result.accessibility?.preparationTimeInfo.identifier).to(equal("RecipeDetail.prepTimeInfo"))
                expect(result.accessibility?.preparationTimeInfo.traits).to(equal(.staticText))
                expect(result.accessibility?.preparationTimeInfo.label).to(equal("Preparation time, 15 minutes"))
                
                expect(result.accessibility?.cookingTimeInfo.identifier).to(equal("RecipeDetail.cookTimeInfo"))
                expect(result.accessibility?.cookingTimeInfo.traits).to(equal(.staticText))
                expect(result.accessibility?.cookingTimeInfo.label).to(equal("Cooking time, 15 minutes"))
                
                expect(result.accessibility?.ingredientsHeading.identifier).to(equal("RecipeDetail.ingredientsHeading"))
                expect(result.accessibility?.ingredientsHeading.traits).to(equal(.header))
                expect(result.accessibility?.ingredientsHeading.hint).to(equal("List of items you need for this recipe"))
                
                expect(result.accessibility?.compactTitle.identifier).to(equal("RecipeDetail.compact.cell.title"))
                expect(result.accessibility?.compactTitle.traits).to(equal(.header))
                expect(result.accessibility?.compactSubtitle.identifier).to(equal("RecipeDetail.compact.cell.subtitle"))
                expect(result.accessibility?.compactSubtitle.traits).to(equal(.staticText))
                
            }
        }
    }
}
