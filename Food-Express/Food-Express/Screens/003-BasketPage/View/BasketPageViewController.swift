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
}

final class BasketPageViewController: UIViewController {

    @IBOutlet private weak var basketCollectionView: UICollectionView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var placeOrderBtn: UIButton!
    private lazy var viewModel = BasketViewModel()
    
    var basketItems = [
            (name: "Hamburger", price: "120", amount: "1", imageName: "hamburger"),
            (name: "Pizza", price: "150", amount: "2", imageName: "hamburger"),
            (name: "Soda", price: "10", amount: "3", imageName: "hamburger"),
            (name: "Fries", price: "50", amount: "1", imageName: "hamburger"),
            (name: "Salad", price: "40", amount: "1", imageName: "hamburger")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    @IBAction func placeOrderBtnClicked(_ sender: Any) {
    }
}

extension BasketPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { basketItems.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basketCell", for: indexPath) as? BasketCollectionViewCell else { return UICollectionViewCell() }
        
        let item = basketItems[indexPath.row]
        
        cell.basketProductImageView.image = UIImage(named: item.imageName)
        cell.basketProductAmountLbl.text = item.amount
        cell.basketProductNameLbl.text = item.name
        cell.basketProductPriceLbl.text = "\(item.price)₺"
        cell.totalPriceLbl.text = "\(String((Int(item.amount)!) * (Int(item.price)!)))₺"
        
        cell.delegate = self
        return cell
    }
}

extension BasketPageViewController: UICollectionViewDelegate {
    
}

extension BasketPageViewController: BasketCollectionViewDelegate {
    
    func didRequestDelete(_ cell: BasketCollectionViewCell) {
        if let indexPath = basketCollectionView.indexPath(for: cell) {
            print("deleted item at \(indexPath.item)")
            basketItems.remove(at: indexPath.row)
            basketCollectionView.deleteItems(at: [indexPath])
            updateTotalPrice()
        }
    }

    private func updateTotalPrice() {
        let totalPrice = basketItems.reduce(0.0) { (result, item) -> Double in
            let amount = Int(item.amount) ?? 0
            let price = Double(item.price) ?? 0
            return result + (Double(amount) * price)
        }
        totalLabel.text = "Total: \(totalPrice)₺"
    }
}

extension BasketPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 48, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 28 }
}

extension BasketPageViewController: BasketPageViewInterface {

    func setDelegateUI() {
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
        basketCollectionView.register(BasketCollectionViewCell.register(), forCellWithReuseIdentifier: BasketCollectionViewCell.identifier)
        updateTotalPrice()
    }

    func setUIDesign() {
        placeOrderBtn.layer.cornerRadius = 16
        placeOrderBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
}
