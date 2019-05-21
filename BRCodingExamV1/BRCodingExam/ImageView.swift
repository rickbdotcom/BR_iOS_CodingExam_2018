//
//  ImageView.swift
//  BRCodingExam
//
//  Created by rickb on 5/17/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

// In a real app, I wouldn't reinvent the wheel here and I'd just use SDWebImage or the like
// And if I had to implement for real, this I'd do it as an extension on UIImageView and use associated objects instead of subclassing
class ImageView: UIImageView {

    private var imageDownloadTask: URLSessionTask?

// if server required auth headers and whatnot we'd provide a URLRequest version as well
// could add options for placeholder, activity indicator, completion handler, caching, etc.
// we're just setting NSAllowsArbitraryLoads in Info.plist, in real app we'd need to evaluate this
    func loadImage(from url: URL?) {
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        image = nil

        guard let url = url else {
            image = nil
            return
        }
        if let image = cachedImage(for: url) {
            self.image = image
            return
        }
        var currentTask: URLSessionTask?
        imageDownloadTask = imageDownloadSession.downloadTask(with: url) { [weak self] fileURL, response, error in
// lots of things to consider, http caching, file already exists, retries, errors, simultaneous access, cancelling, blah, blah, that's why we don't reinvent the wheel
            if let fileURL = fileURL {
// needs to be copied out before completionhandler returns
                do {
                    try FileManager.default.copyItem(at: fileURL, to: try cachedURL(for: url))
                    DispatchQueue.main.async {
                        if currentTask == self?.imageDownloadTask { // just in case we got cancelled while copying, handling these cases is important on reusable cells
                            self?.image = cachedImage(for: url)
                        }
                    }
                } catch {
                }
            }
        }
        currentTask = imageDownloadTask
        imageDownloadTask?.resume()
    }
}

private let memImageCache = NSCache<NSString, UIImage>()

// could make this async if we really needed to avoid hitching when scrolling
private func cachedImage(for url: URL) -> UIImage? {
    do {
        let cacheURL = try cachedURL(for: url)
        if let image = memImageCache.object(forKey: cacheURL.absoluteString as NSString) {
            return image
        }
        let data = try Data(contentsOf: cacheURL)
        if let image = UIImage(data: data) {
            memImageCache.setObject(image, forKey: cacheURL.absoluteString as NSString)
            return image
        } else {
            return nil
        }
    } catch {
        return nil
    }
}

private func cachedURL(for url: URL) throws -> URL {
    let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: url, create: true)
    return cacheDir.appendingPathComponent(cacheKey(for: url))
}

// need some mechanism for converting URL to a cache key
private func cacheKey(for url: URL) -> String {
    return url.path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "bad" // eh
}

private var imageDownloadSession = URLSession(configuration: .default)
