//
//  AssetStore.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import CryptoKit

private let TAG = "AssetStore"

actor AssetStore {
  
  private static let maxDiskCachedFilesLimit = 1000
  
  private var imageCache: NSCache<NSString, NSData>
  
  private let session: URLSessionProtocol
  private let fileManager: FileManagerProtocol
  
//MARK: public methods
  
  init(imageCache: NSCache<NSString, NSData> = NSCache<NSString, NSData>(),
       session: URLSessionProtocol = URLSession.shared,
       fileManager: FileManagerProtocol = FileManager.default) {
    self.session = session
    self.fileManager = fileManager
    self.imageCache = imageCache
    imageCache.countLimit = AssetStore.maxDiskCachedFilesLimit
    imageCache.totalCostLimit = AssetStore.maxDiskCachedFilesLimit * 10 * 1000 // ~ 1MB
  }
  
  // non-I/O bound method, for fast access
  func fastFetchAsset(url: URL?) -> Asset {
    guard let url = url else {
      Log.error(TAG, "attempt to fetch using nil url, returning placeholder")
      return Asset(url: nil, state: .placeholder, data: nil)
    }
    if let cachedAsset = imageCache.object(forKey: url.path as NSString) {
      return Asset(url: url, state: .downloaded, data: cachedAsset as Data)
    }
    return Asset(url: url, state: .placeholder, data: nil)
  }
  
  // potentially I/O bound
  func fetchAsset(url: URL?) async -> Asset? {
    guard let url = url else {
      Log.error(TAG, "attempt to fetch using nil url, returning placeholder")
      return Asset(url: nil, state: .placeholder, data: nil)
    }
    
    // check in cache
    if let cachedAsset = imageCache.object(forKey: url.path as NSString) {
      return Asset(url: url, state: .downloaded, data: cachedAsset as Data)
    } else {
      // check on disk
      if let diskCachedAsset = getDiskCachedAsset(networkURL: url) {
        return diskCachedAsset
      }
      
      // download
      return await getAssetFromNetwork(networkURL: url)
    }
  }
  
//MARK: private methods
  
  private func getAssetFromNetwork(networkURL: URL) async -> Asset? {
    do {
      let (downloadedData, _) = try await self.session.data(from: networkURL, delegate: nil)
      imageCache.setObject(downloadedData as NSData, forKey: networkURL.path as NSString)
      write(data: downloadedData, networkURL: networkURL)
      return Asset(url: networkURL, state: .downloaded, data: downloadedData)
    } catch {
      Log.error(TAG, error)
      return nil
    }
  }
  
  private func getDiskCachedAsset(networkURL: URL) -> Asset? {
    guard let fileURL = getFileURL(usingNetworkURL: networkURL) else {
      Log.error(TAG, "unable to get file URL")
      return nil
    }
    
    if self.fileManager.fileExists(atPath: fileURL.path) == false {
      Log.verbose(TAG, "No file stored for file URL - \(fileURL)")
      return nil
    }
    if let savedData = self.fileManager.contents(atPath: fileURL.path) {
      imageCache.setObject(savedData as NSData, forKey: networkURL.path as NSString)
      return Asset(url:networkURL, state: .downloaded, data: savedData)
    } else {
      Log.error(TAG, "error reading contents of file at path \(fileURL.path)")
      return nil
    }
  }
  
  private func write(data: Data, networkURL: URL)  {
    
    guard let fileURL = getFileURL(usingNetworkURL: networkURL) else {
      Log.error(TAG, "unable to get file URL")
      return
    }
    
    do {
      try data.write(to: fileURL)
      Log.verbose(TAG, "Succesfully wrote to \(fileURL)")
    } catch {
      Log.error(TAG, error)
    }
    
    deleteOldFiles()
  }
  
  private func getFileURL(usingNetworkURL networkURL: URL) -> URL? {
    let fileURLs = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      Log.error(TAG, "unable to get docments directory")
      return nil
    }
    guard let directoryURL = fileURLs.first else {
      Log.error(TAG, "nil directory URL")
      return nil
    }
    let hashString = SHA256.hash(data:Data(networkURL.path.utf8)).compactMap { String(format: "%02x", $0) }.joined()
    return URL(string: "\(directoryURL.absoluteString)\(hashString)")
  }
  
  private func deleteOldFiles() {
    let fileURLs = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > AssetStore.maxDiskCachedFilesLimit else {
      return
    }
    guard let directoryURL = fileURLs.first else { return }
    do {
      let directoryContents = try self.fileManager.contentsOfDirectory(
        at: directoryURL,
        includingPropertiesForKeys: [.creationDateKey],
        options: []
      )
      
      for url in directoryContents {
        let creationDate = try url.resourceValues(forKeys:[.creationDateKey])
        Log.verbose(TAG, "\(url) creationDate = \(creationDate)")
      }
      
      
      var sortedDirectoryContents = directoryContents.sorted {
        do {
          if let creationDateFirst = try $0.resourceValues(forKeys:[.creationDateKey]).allValues[.creationDateKey] as? Date,
             let creationDateSecond = try $1.resourceValues(forKeys:[.creationDateKey]).allValues[.creationDateKey] as? Date {
            return creationDateFirst > creationDateSecond
          }
        } catch {
          Log.error(TAG, "getting creation dates failed")
        }
        Log.error(TAG, "unable to get creation dates")
        return false
      }

      while sortedDirectoryContents.count > AssetStore.maxDiskCachedFilesLimit {
        let removed = sortedDirectoryContents.removeLast()
        try self.fileManager.removeItem(at: removed)
      }
    } catch {
      Log.error(TAG, error)
    }
  }
  
}
