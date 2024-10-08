//
//  MainPageViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

protocol HomeViewInterface: AnyObject {
    func setUIForSearch()
    func setDelegateUI()
    func setDarkModeUI()
}

final class MainPageViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var foodCollectionView: UICollectionView!
    @IBOutlet private weak var aboutUsImageView: UIImageView!

    private lazy var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(aboutUsTapped))
        aboutUsImageView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
    
    @objc func aboutUsTapped() {
        let aboutVC = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
        aboutVC.modalPresentationStyle = .pageSheet
        self.present(aboutVC, animated: true)
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as? FoodCollectionViewCell else { return UICollectionViewCell() }
        
        cell.foodImageView.image = UIImage(named: "hamburger")
        cell.foodNameLbl.text = "Food Name"
        cell.foodPriceLbl.text = "Price"
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegate {
    
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
}

extension MainPageViewController: HomeViewInterface {
    func setDelegateUI() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.register(UINib(nibName: "FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "foodCell")
    }

    func setDarkModeUI() {
        let sharedUserInterfaceStyle = UserDefaults.standard.string(forKey: "userInterfaceStyle") ?? "light"
        if sharedUserInterfaceStyle == "dark" {
            searchTextField.backgroundColor = .darkGray
        } else {
            searchTextField.backgroundColor = UIColor(hex: "F4F4F4")
        }
    }
    
    func setUIForSearch() {
        let searchIcon = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.tintColor = .systemGray
        
        let iconContainerLeft = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        iconContainerLeft.addSubview(searchIcon)

        searchTextField.leftView = iconContainerLeft
        searchTextField.leftViewMode = .unlessEditing

        let clearButton = UIButton(type: .system)
        clearButton.frame = CGRect(x: -5, y: 0, width: 20, height: 20)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .systemGray
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)

        let iconContainerRight = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        iconContainerRight.addSubview(clearButton)

        searchTextField.rightView = iconContainerRight
        searchTextField.rightViewMode = .whileEditing
    }

    @objc private func clearTextField() {
        searchTextField.text = ""
        searchTextField.endEditing(true)
        
    }
}
