//
//  BasketPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class BasketPageViewController: UIViewController {

    @IBOutlet private weak var basketCollectionView: UICollectionView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    var basketItems = [
            (name: "Hamburger", price: "120", amount: "1", imageName: "aboutUs"),
            (name: "Pizza", price: "150", amount: "2", imageName: "aboutUs"),
            (name: "Soda", price: "10", amount: "3", imageName: "aboutUs"),
            (name: "Fries", price: "50", amount: "1", imageName: "aboutUs"),
            (name: "Salad", price: "40", amount: "1", imageName: "aboutUs")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
        basketCollectionView.register(UINib(nibName: "BasketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basketCell")
        updateTotalPrice()
        placeOrderBtn.layer.cornerRadius = 16
        placeOrderBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner]
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
        
        cell.delegate = self
        cell.configure(amount: Int(item.amount)!, price: Double(item.price)!)
        return cell
    }
}

extension BasketPageViewController: UICollectionViewDelegate {
    
}

extension BasketPageViewController: BasketCollectionViewDelegate {
    func didUpdateAmount(for cell: BasketCollectionViewCell) {
        guard let indexPath = basketCollectionView.indexPath(for: cell) else { return }
        basketItems[indexPath.row].amount = String(cell.amount)
        updateTotalPrice()
    }
    
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
        totalLabel.text = String(format: "Total: %.2f₺", totalPrice)
    }
}

extension BasketPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 48, height: collectionView.frame.height / 3.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 28 }
}
