//
//  PhotosCollectionViewDatasource.swift
//  Independent Work One
//
//  Created by Тимур Салахиев on 21.11.2024.
//

import Foundation
import UIKit

class PhotosCollectionViewDataSource: NSObject, UICollectionViewDataSource{
    
    var dataSource: [UIImage] = [UIImage(named: "applepie")!,
                                 UIImage(named: "drunk")!,
                                 UIImage(named: "dvoyka")!,
                                 UIImage(named: "fish")!,
                                 UIImage(named: "fisherman")!,
                                 UIImage(named: "fragrance")!,
                                 UIImage(named: "friend")!,
                                 UIImage(named: "seconddvoyka")!,
                                 UIImage(named: "sigma")!,
                                 UIImage(named: "sigmas")!,
                                 UIImage(named: "soberyet")!,
                                 UIImage(named: "sunrise")!,]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        cell.configureCell(with: dataSource[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
