//
//  EmployeeTableViewCell.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import Foundation
import UIKit
import Combine

private let TAG = "EmployeeTableViewCell"

@MainActor class EmployeeTableViewCell: UITableViewCell {
  var titleLabel: UILabel!
  var subtitleLabel: UILabel!
  var photoImage: UIImageView!
  var vStack: UIStackView!
  
  private var imageTask: Task<Optional<()>, Never>?
  private var downloadTask: Task<(), Never>?
  var photoURLString: String?
  
  static let cellReuseIdentifier = "com.square.employeedirectory.cell"
  
  func setup(withEmployee employee: Employee, assetStore: AssetStore) {
    
    self.titleLabel.text = employee.fullName
    self.subtitleLabel.text = employee.team
    photoURLString = employee.photoUrlSmall
    setPhotoImage(photoURLString: employee.photoUrlSmall, assetStore: assetStore)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupProfilePic()
    setupTitleDescriptionVStack()
    
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // profile image constraints
    constraints.append(contentsOf: [
      photoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
      photoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
      photoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
      photoImage.widthAnchor.constraint(equalTo: photoImage.heightAnchor)
    ])
    
    // name label constraints
    constraints.append(contentsOf:[
      vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
      vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
      vStack.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 20.0),
      vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0)
    ])
    
    return constraints
  }
  
  private func setupProfilePic() {
    photoImage = UIImageView()
    
    // setup corners
    photoImage.layer.cornerRadius = 10.0
    photoImage.clipsToBounds = true
    photoImage.translatesAutoresizingMaskIntoConstraints = false
    
    // add border
    photoImage.layer.borderWidth = 1.0
    photoImage.layer.borderColor = UIColor.gray.cgColor
    
    self.addSubview(photoImage)
  }
  
  private func setupTitleDescriptionVStack() {
    
    vStack = UIStackView()
    vStack.axis = .vertical
    vStack.distribution = .fill
    vStack.alignment = .fill
  //  vStack.backgroundColor = UIColor.random()
    vStack.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
  //  titleLabel.backgroundColor = UIColor.random()
    vStack.addArrangedSubview(titleLabel)
    
    subtitleLabel = UILabel()
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.textColor = UIColor.darkGray
    vStack.addArrangedSubview(subtitleLabel)

    self.addSubview(vStack)
  }
}

// photo image setup extension, code that coule potentially be refactored into a view model
extension EmployeeTableViewCell {

  private func setPhotoImage(photoURLString: String, assetStore: AssetStore) {
    imageTask?.cancel()
    imageTask = Task {
      await setPhotoImageAsync(photoURLString: photoURLString, assetStore: assetStore)
    }
  }
  
  private func setPhotoImageAsync(photoURLString: String, assetStore: AssetStore) async {
    
    let imageURL = URL(string: photoURLString)
    if imageURL == nil {
      // non fatal error, continue with showing a placeholder
      Log.error(TAG, "couldn't get URL for employee url string - \(photoURLString)")
    }
    
    // use asset store to fetch and set an image, if asset store returns a stub
    // then use a placeholder and initiate a download
    let asset = await assetStore.fastFetchAsset(url: imageURL)
    setPhotoImage(withAsset: asset)
    if asset.state == .placeholder {
      downloadAndSetImageAsync(assetStore: assetStore, asset: asset)
    }
  }

  private func setPhotoImage(withAsset asset: Asset) {
    DispatchQueue.main.async {
      switch(asset.state) {
      case .placeholder, .failed:
        self.photoImage.image =  UIImage(named: "Placeholder")
      case .downloaded:
        if let assetURL = asset.url?.absoluteString,
            assetURL == self.photoURLString,
            let imageData = asset.data {
          // @todo: ideally we would reconfigure the item instead of the cell directly as the cell may
          // have been re-used at this point, checking the photoURLString string here as
          // to ensure it's the right one to update.
          self.photoImage.image = UIImage(data: imageData)
        }
      }
    }
  }
  
  private func downloadAndSetImageAsync(assetStore: AssetStore, asset: Asset) {
    downloadTask?.cancel()
    downloadTask = Task {
      if let asset = await assetStore.fetchAsset(url: asset.url) {
        setPhotoImage(withAsset: asset)
      }
    }
  }
}
