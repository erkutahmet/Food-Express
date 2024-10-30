//
//  BasketPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

protocol BasketPageViewInterface: AnyObject {
    func setDelegateUI()
    func setUIDesign()
    func bindViewModel()
    func reloadData()
    func showAlertFromVM(title: String, message: String)
    func animateRemoval(at indexPath: IndexPath)
}

final class BasketPageViewController: UIViewController {

    @IBOutlet private weak var basketCollectionView: UICollectionView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var placeOrderBtn: UIButton!
    private lazy var viewModel = BasketViewModel()
    private var cellDataSource = [ViewBasketModel]()

    private lazy var overLayer = OverLayerPopUpViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }

    @IBAction private func placeOrderBtnClicked(_ sender: UIButton) {
        overLayer.appear(sender: self, popUpType: .placeOrder)
        sender.disableTemporarilyWithTapEffect()
    }
}

extension BasketPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isDataSourceEmpty = cellDataSource.isEmpty
        basketCollectionView.isHidden = isDataSourceEmpty
        return isDataSourceEmpty ? 0 : cellDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketCollectionViewCell.identifier, for: indexPath) as? BasketCollectionViewCell else { return UICollectionViewCell() }
        
        let items = self.cellDataSource[indexPath.item]
        cell.setupCell(viewModel: items)
        cell.setupCellUI()
        cell.delegate = self
        return cell
    }
}

extension BasketPageViewController: UICollectionViewDelegate { }

extension BasketPageViewController: BasketCollectionViewDelegate {
    
    func didRequestDelete(_ cell: BasketCollectionViewCell) {
        if let indexPath = basketCollectionView.indexPath(for: cell) {
            viewModel.removeItem(at: indexPath)
        }
    }
}

extension BasketPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 48, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 28 }
}

extension BasketPageViewController: BasketPageViewInterface {

    func bindViewModel() {
        viewModel.cellDataSource.bind { [weak self] items in
            guard let self = self, let basketItem = items else { return }
            
            if basketItem.isEmpty {
                totalLabel.text = "Total: 0₺"
            } else {
                totalLabel.text = "Total: \(viewModel.getTotalPrice())₺"
            }
            
            self.cellDataSource = basketItem
            self.reloadData()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.basketCollectionView.reloadData()
        }
    }

    func setDelegateUI() {
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
        basketCollectionView.register(BasketCollectionViewCell.register(), forCellWithReuseIdentifier: BasketCollectionViewCell.identifier)
    }

    func setUIDesign() {
        placeOrderBtn.layer.cornerRadius = 16
        placeOrderBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        placeOrderBtn.layer.borderColor = UIColor(hex: "#808080").cgColor
        placeOrderBtn.layer.borderWidth = 1.0
    }

    func showAlertFromVM(title: String, message: String) {
        errorShowAlert(title: title, message: message) {
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
        }
    }

    func animateRemoval(at indexPath: IndexPath) {
        if let cell = self.basketCollectionView.cellForItem(at: indexPath) as? BasketCollectionViewCell {
            cell.animateRemoval()
        }
    }
}
