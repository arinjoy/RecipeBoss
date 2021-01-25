//
//  ServicesProvider.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 22/1/21.
//

import Foundation

/// Can provide misc services such as - network data loading, local file data loading, image loading, core-data/caching
/// For now there is only service of `NetworkServiceType` which does HTTP based data loading
class ServicesProvider {

    /// The underlying network service to load HTTP network based data
    let network: NetworkServiceType
    
    /// The underlying image service to load images from HTTP or from saved cache
    let imageLoader: ImageLoaderServiceType
    
    init(network: NetworkServiceType, imageLoader: ImageLoaderServiceType) {
        self.network = network
        self.imageLoader = imageLoader
    }

    /// The deafult provider used for production code to fetch from remote
    static func defaultProvider() -> ServicesProvider {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        // Set 10 seconds timeout for the request,
        // otherwise defaults to 60 seconds which is too long.
        // This helps in network disconnection and error testing.
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 10
        
        let network = NetworkService(with: sessionConfig)
        
        return ServicesProvider(network: network, imageLoader: ImageLoaderService())
    }
    
    /// The helping provider to fetch locally from stub JSON file
    static func localStubbedProvider() -> ServicesProvider {
        // Slightly modified version with more recent dates used for testing
        let localStubbedNetwork = LocalStubbedDataService(withLocalFile: "recipesSample")
        return ServicesProvider(network: localStubbedNetwork, imageLoader: ImageLoaderService())
    }
}

