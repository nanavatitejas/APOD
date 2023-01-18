//
//  Helper.swift
//  APOD
//
//  Created by Tejas Nanavati on 17/01/23.
//

import Foundation
import AVFoundation
import UIKit
import CoreVideo

class Helper {
    static let shared = Helper()
    private init() {}
    
    private let imageCache = NSCache<NSURL, UIImage>()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }()
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
                    completion(cachedImage)
                    return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    
    

    
    
    
}


extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)

        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }

        return (self as NSString).substring(with: result.range)
    }
}


extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}


    



