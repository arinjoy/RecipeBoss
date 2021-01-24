//
//  RecipeModel+DataMappingSpecs.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 24/1/21.
//

import Foundation
import Quick
import Nimble
@testable import RecipeBoss

final class RecipeModelDataMappingSpec: QuickSpec {

    override func spec() {
        
        describe("Recipe List data model spec") {
            
            var testJSONData: Data!
            
            context("correct JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "recipe_sample_data")
                }
                
                it("should successfully decode to valid `RecipeList` object") {

                    let jsonDecoder = JSONDecoder()
                    let mappedItem = try? jsonDecoder.decode(RecipeList.self, from: testJSONData)

                    // The entire structure is mapped
                    expect(mappedItem).toNot(beNil())
                    
                    // 2 recipes found in JSON
                    expect(mappedItem?.recipes.count).to(equal(2))
                    
                    // First recipe details are mapped correcty
                    expect(mappedItem?.recipes.first?.title).to(equal("Curtis Stone's tomato and bread salad with BBQ eggplant and capsicum"))
                    expect(mappedItem?.recipes.first?.description).to(equal("For a crowd-pleasing salad, try this tasty combination of fresh tomato, crunchy bread and BBQ veggies. It’s topped with fresh basil and oregano for a finishing touch."))
                    expect(mappedItem?.recipes.first?.thumbnailUrlPath).to(equal("/content/dam/coles/inspire-create/thumbnails/Tomato-and-bread-salad-480x288.jpg"))
                    expect(mappedItem?.recipes.first?.thumbnailAltText).to(equal("Tomato, bread and eggplant salad served in a large plate topped with basil leaves with vinaigrette on the side"))
                    expect(mappedItem?.recipes.first?.details.amountLabel).to(equal("Serves"))
                    expect(mappedItem?.recipes.first?.details.amount).to(equal(8))
                    expect(mappedItem?.recipes.first?.details.cookingTime).to(equal(15))
                    expect(mappedItem?.recipes.first?.details.cookingTimeLabel).to(equal("Cooking"))
                    expect(mappedItem?.recipes.first?.details.cookingTimeText).to(equal("15m"))
                    expect(mappedItem?.recipes.first?.details.preparationTime).to(equal(15))
                    expect(mappedItem?.recipes.first?.details.preparationTimeLabel).to(equal("Prep"))
                    expect(mappedItem?.recipes.first?.details.preparationTimeText).to(equal("15m"))
                    expect(mappedItem?.recipes.first?.ingredients.count).to(equal(5))
                    expect(mappedItem?.recipes.first?.ingredients[0].ingredient).to(equal("1 cup (250ml) extra virgin olive oil, divided"))
                    expect(mappedItem?.recipes.first?.ingredients[1].ingredient).to(equal("4 cups (240g) 2cm-pieces day-old Coles Bakery Stone Baked by Laurent Pane Di Casa"))
                    expect(mappedItem?.recipes.first?.ingredients[2].ingredient).to(equal("4 Lebanese eggplants, halved lengthways"))
                    expect(mappedItem?.recipes.first?.ingredients[3].ingredient).to(equal("1 red capsicum, quartered, seeded"))
                    expect(mappedItem?.recipes.first?.ingredients[4].ingredient).to(equal("1 yellow capsicum, quartered, seeded"))
                }
            }
            
            context("incorrect JSON response") {
                
                beforeEach {
                    testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "incorrect_data")
                }

                it("should not decode to valid `RecipeList` object") {

                    let jsonDecoder = JSONDecoder()
                    let mappedItem = try? jsonDecoder.decode(RecipeList.self, from: testJSONData)

                    // due to incorrect JSON struture, it cannot be mapped to `RecipeList` object
                    expect(mappedItem).to(beNil())
                }
            }
        }
    }
}
