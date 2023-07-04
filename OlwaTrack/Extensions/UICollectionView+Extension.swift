//
//  UICollectionView+Extension.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 03.07.2023.
//

import UIKit

extension UICollectionView {
    func registerCell(reuseable: Reusable.Type) {
        register(reuseable, forCellWithReuseIdentifier: reuseable.reuseId)
    }
    
    func dequeueCell<T>(at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T else {
            fatalError("Unexpected ReusableCell Type for reuseID \(T.reuseId)")
        }
        return cell
    }
}

extension UICollectionViewCell: Reusable {}
