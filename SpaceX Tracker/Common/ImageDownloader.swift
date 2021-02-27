//
//  ImageDownloader.swift
//  SpaceX Tracker
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import Foundation
import UIKit

protocol ImageDownloaderProtocol {
    func image(from urlString: String, completion:@escaping (_ image: UIImage?) -> Void) -> URLSessionTask?
}

final class ImageDownloader: ImageDownloaderProtocol {
    private var cache = NSCache<AnyObject, AnyObject>()
    private let queue = DispatchQueue(label: "image_download", qos: .default, attributes: .concurrent, autoreleaseFrequency: .never, target: .none)

    func image(from urlString: String, completion:@escaping (_ image: UIImage?) -> Void) -> URLSessionTask? {
        if let data = cache.object(forKey: urlString as AnyObject) as? Data {
            let image = UIImage(data: data)
            DispatchQueue.main.async { completion(image) }
            return nil
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        
        let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let image = UIImage.init(data: data)
            self.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
            DispatchQueue.main.async { completion(image) }
        }

        queue.async {
            downloadTask.resume()
        }

        return downloadTask
    }
}
