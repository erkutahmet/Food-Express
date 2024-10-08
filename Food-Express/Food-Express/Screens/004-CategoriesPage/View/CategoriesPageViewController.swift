//
//  CategoriesPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class CategoriesPageViewController: UIViewController {

    @IBOutlet private weak var categoriesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self

        categoriesCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
    }
}

extension CategoriesPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 10 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.categoryImageView.image = UIImage(named: "aboutUs")
        cell.categoryNameLbl.text = "Category \(indexPath.row)"
        cell.layer.cornerRadius = 4
        cell.categoryImageView.addBlurWithRadius(blurRadius: 5)
        
        return cell
    }
}

extension CategoriesPageViewController: UICollectionViewDelegate {
    
}

extension CategoriesPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2 - 12, height: collectionView.frame.height / 2.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 20 }
}
