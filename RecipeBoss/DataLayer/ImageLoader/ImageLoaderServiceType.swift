//
//  ImageLoaderServiceType.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 26/1/21.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: AnyObject {

    /// Loads an image from an web/network URL considering if the image for the same URL has been
    /// saved in-memory cache or not and finally returns the `UIImage` instance in from of reactive publisher signal
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
