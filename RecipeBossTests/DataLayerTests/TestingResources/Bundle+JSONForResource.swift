//
//  Bundle+JSONForResource.swift
//  RecipeBossTests
//
//  Created by Arinjoy Biswas on 24/1/21.
//

import Foundation

extension Bundle {
    
    /// Loads a JSON file resource and returns its data
    func jsonData(forResource resource: String) -> Data {
        let resourceURL: URL = url(forResource: resource, withExtension: "json")!
        return try! Data(contentsOf: resourceURL)
    }
}

