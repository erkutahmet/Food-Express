//
//  CategoriesPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

protocol CategoriesViewInterface: AnyObject {
    func prepareCollectionView()
}

final class CategoriesPageViewController: UIViewController {

    @IBOutlet private weak var categoriesCollectionView: UICollectionView!

    private lazy var viewModel = CategoriesPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension CategoriesPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
        
        let item = viewModel.cellForItem(at: indexPath)
        cell.setUpCell(name: item.0, image: item.1)
        return cell
    }
}

extension CategoriesPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
    }
}

extension CategoriesPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2 - 12, height: collectionView.frame.height / 2.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 20 }
}

extension CategoriesPageViewController: CategoriesViewInterface {
    func prepareCollectionView() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoriesCollectionViewCell.register(), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
    }
}
