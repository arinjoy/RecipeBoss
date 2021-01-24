
//
//  NetworkServiceType+TestDoubles.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine
@testable import RecipeBoss

final class NetworkServiceSpy: NetworkServiceType {
    
    // Spy calls
    var loadReourceCalled = false
    
    // Spy values
    var url: URL?
    var parameters: [String: CustomStringConvertible]?
    var request: URLRequest?
    var isLocalStub: Bool?
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        
        loadReourceCalled = true
        
        url = resource.url
        parameters = resource.parameters
        request = resource.request
        isLocalStub = resource.isLocalStub
        
        return Empty().eraseToAnyPublisher()
    }
}

final class NetworkServiceMock<ResponseType>: NetworkServiceType {
    
    /// The pre-determined response to always return from this mock no matter what request is made
    let response: ResponseType

    /// Whether to return error outcome
    let returningError: Bool

    /// The pre-determined error to return if `returnError` is set true
    let error: NetworkError

    init(response: ResponseType,
         returningError: Bool = false,
         error: NetworkError = NetworkError.unknown
    ) {
        self.response = response
        self.returningError = returningError
        self.error = error
    }
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        
        if returningError {
            return Just(.failure(error)).eraseToAnyPublisher()
        }
        
        return Just(.success(response as! T)).eraseToAnyPublisher()
    }
}
