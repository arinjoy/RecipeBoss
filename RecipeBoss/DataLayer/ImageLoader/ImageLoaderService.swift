//
//  ImageLoaderService.swift
//  RecipeBoss
//
//  Created by Arinjoy Biswas on 26/1/21.
//

import Foundation
import UIKit.UIImage
import Combine

final class ImageLoaderService: ImageLoaderServiceType {

    private let cache: ImageCacheType = ImageCache()

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {

        // If image exists in cache just return it
        if let image = cache.image(for: url) {
            return .just(image)
        }

        // Else, load from network and cache if for future usage
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .map { data, response -> UIImage? in
                return UIImage(data: data)
            }
            .catch { error in
                return Just(nil)
            }
            .handleEvents(receiveOutput: { [unowned self] image in
                guard let image = image else { return }
                self.cache.insertImage(image, for: url)
            })
            .eraseToAnyPublisher()
    }
}
