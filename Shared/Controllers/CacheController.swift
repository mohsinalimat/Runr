//
//  CacheController.swift
//  Runr
//
//  Created by Philip Sawyer on 12/27/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class CacheController {
	
	static let imageFileExtension = ".png"
	
	private let cacheDirectoryURL: URL
	
	private let cache: NSCache<NSString, AnyObject>
	
	private var fileManager: FileManager
	
	init() {
		fileManager = FileManager.default
		
		cacheDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
		
		cache = NSCache<NSString, AnyObject>()
	}
	
	/// Fetches an image from the cache or from the file system with the key provided
	///
	/// - Parameter key: The key of the image to be fetched
	/// - Returns: The represented image. `nil` if an image cannot be found
	func image(for key: String) -> UIImage? {
		if let object = cache.object(forKey: key as NSString) {
			return object as? UIImage
		} else {
			let url = cacheDirectoryURL.appendingPathComponent("\(key)\(CacheController.imageFileExtension)", isDirectory: false)
			guard let data = try? Data(contentsOf: url) else { return nil }
			if let image = UIImage(data: data) {
				cache.setObject(image, forKey: key as NSString)
				return image
			}
		}
		
		return nil
	}
	
	/// Saves the image to disk, and adds the image to the cache
	///
	/// - Parameters:
	///   - image: The image to be saved
	///   - key: The key to save the image as
	func set(image: UIImage, for key: String) {
		let data = image.pngData()
		let url = cacheDirectoryURL.appendingPathComponent("\(key)\(CacheController.imageFileExtension)", isDirectory: false)
		let success = fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
		if success {
			cache.setObject(image, forKey: key as NSString)
		}
	}
}
