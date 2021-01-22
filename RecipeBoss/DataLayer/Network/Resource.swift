//
//  Resource.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import Foundation

struct Resource<T: Decodable> {
    
    /// The URL to request data for this resource
    let url: URL
    
    /// The optional parmeters to construct the full URL path
    let parameters: [String: CustomStringConvertible]
    
    /// An indicator if we are loading the the data locally from a `Stubbed JSON` file
    /// Helpful for debugging, building/unit testing
    let isLocalStub: Bool
    
    var request: URLRequest? {
        
        guard !isLocalStub else { return nil }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    // MARK: - Init
    
    init(url: URL, parameters: [String: CustomStringConvertible] = [:], isLocalStub: Bool = false) {
        self.url = url
        self.parameters = parameters
        self.isLocalStub = isLocalStub
    }
}

