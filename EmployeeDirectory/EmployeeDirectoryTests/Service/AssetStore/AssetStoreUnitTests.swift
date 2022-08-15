//
//  AssetStoreUnitTests.swift
//  EmployeeDirectoryTests
//
//  Created by Akshay Bhandary on 8/14/22.
//

import XCTest
@testable import EmployeeDirectory

class AssetStoreUnitTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testFastFetchWithNilURL() async throws {
    // setup asset store
    let assetStore = AssetStore()
    
    // run the fast fetch method
    let asset = await assetStore.fastFetchAsset(url: nil)
    
    // verify that a placeholder is returned
    XCTAssertEqual(asset.url, nil)
    XCTAssertEqual(asset.state, .placeholder)
  }
  
  func testFastFetchDataCached() async throws {
    
    // setup asset store with cached data
    let imageCache = NSCache<NSString, NSData>()
    let cachedData = NSData()
    let url = URL(string: "http://square.com")
    imageCache.setObject(cachedData, forKey: url!.path as NSString)
    let assetStore = AssetStore(imageCache: imageCache)
    
    // run the fast fetch method
    let asset = await assetStore.fastFetchAsset(url: url)

    // asset that the cached data is returned
    XCTAssertEqual(asset.url, url)
    XCTAssertEqual(asset.state, .downloaded)
    XCTAssertEqual(asset.data, cachedData as Data)
  }
  
  func testFastFetchDataNotCached() async throws {
    
    // setup asset store with cached data
    let imageCache = NSCache<NSString, NSData>()
    let url = URL(string: "http://square.com")
    let assetStore = AssetStore(imageCache: imageCache)
    
    // run the fast fetch method
    let asset = await assetStore.fastFetchAsset(url: url)

    // asset that a placeholder is returned
    XCTAssertEqual(asset.url, url)
    XCTAssertEqual(asset.state, .placeholder)
    XCTAssertEqual(asset.data, nil)
  }
  
  func testFetchWithNilURL() async throws {
    // setup asset store
    let assetStore = AssetStore()
    
    // run the fast fetch method
    let asset = await assetStore.fetchAsset(url: nil)
    guard let asset = asset else {
      XCTFail("got nil asset while expecting a placeholder")
      return
    }

    // verify that a placeholder is returned
    XCTAssertEqual(asset.url, nil)
    XCTAssertEqual(asset.state, .placeholder)
  }
  
  func testFetchDataInMemCache() async throws {
    
    // setup asset store with cached data
    let imageCache = NSCache<NSString, NSData>()
    let cachedData = NSData()
    let url = URL(string: "http://square.com")
    imageCache.setObject(cachedData, forKey: url!.path as NSString)
    let assetStore = AssetStore(imageCache: imageCache)
    
    // run the fetch method
    let asset = await assetStore.fetchAsset(url: url)
    guard let asset = asset else {
      XCTFail("got nil asset while expecting a cached asset")
      return
    }
    
    // asset that the cached data is returned
    XCTAssertEqual(asset.url, url)
    XCTAssertEqual(asset.state, .downloaded)
    XCTAssertEqual(asset.data, cachedData as Data)
  }
  
  func testFetchDataNotInMemCachedButInDiskCache() async throws {
    
    // setup asset store with disk cached data
    let imageCache = NSCache<NSString, NSData>()
    let url = URL(string: "http://square.com")
    let mockURLSession = MockURLSession(dataToReturn: nil, responseToReturn: nil, errorToThrow: nil)
    let mockStoredData = Data()
    var mockFileManager = MockFileManager()
    mockFileManager.contentsAtPath = mockStoredData
    mockFileManager.fileExists = true
    mockFileManager.urls = [url!]
    let assetStore = AssetStore(imageCache: imageCache,
                                session: mockURLSession,
                                fileManager: mockFileManager)
    
    // run the fetch method
    let asset = await assetStore.fetchAsset(url: url)
    guard let asset = asset else {
      XCTFail("got nil asset while expecting a cached asset")
      return
    }
    
    // asset that the expected data is returned
    XCTAssertEqual(asset.url, url)
    XCTAssertEqual(asset.state, .downloaded)
    XCTAssertEqual(asset.data, mockStoredData)
    
    // asset that the cache now has the disk stored data
    XCTAssertEqual(imageCache.object(forKey: url!.path as NSString), mockStoredData as NSData)
  }
  
  func testFetchDataNotInMemCachedNotInDiskCache() async throws {
    
    // setup asset store with disk cached data
    let imageCache = NSCache<NSString, NSData>()
    let url = URL(string: "http://square.com")
    let mockNetworkData = Data()
    let mockURLSession = MockURLSession(dataToReturn: mockNetworkData,
                                        responseToReturn: URLResponse(),
                                        errorToThrow: nil)
    var mockFileManager = MockFileManager()
    mockFileManager.fileExists = false
    mockFileManager.urls = [url!]
    let assetStore = AssetStore(imageCache: imageCache,
                                session: mockURLSession,
                                fileManager: mockFileManager)
    
    // run the fetch method
    let asset = await assetStore.fetchAsset(url: url)
    guard let asset = asset else {
      XCTFail("got nil asset while expecting a cached asset")
      return
    }
    
    // asset that the expected data is returned
    XCTAssertEqual(asset.url, url)
    XCTAssertEqual(asset.state, .downloaded)
    XCTAssertEqual(asset.data, mockNetworkData)
    
    // asset that the cache now has the disk stored data
    XCTAssertEqual(imageCache.object(forKey: url!.path as NSString), mockNetworkData as NSData)
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
