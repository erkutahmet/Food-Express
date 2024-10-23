//
//  MainPageViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit
import AlamofireImage

protocol MainViewInterface: AnyObject {
    func setUIForSearch()
    func setDelegateUI()
    func setDarkModeUI()
    func reloadData()
    func bindViewModel()
    func openDetail(id foodId: String)
    func setupTapGesture()
}

final class MainPageViewController: UIViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var foodCollectionView: UICollectionView!
    
    private lazy var viewModel = MainViewModel()
    private var cellDataSource = [FoodViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.viewDidAppear()
    }

    @IBAction private func searchHandler(_ sender: UITextField) {
        guard let searchText = sender.text else { return }
        viewModel.searchHandler(contains: searchText)
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard indexPath.item < viewModel.numberOfItems(),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as? FoodCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let food = self.cellDataSource[indexPath.item]
        cell.setupCellShadowView(index: indexPath.item)
        cell.setupCell(viewModel: food)
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let foodId = cellDataSource[indexPath.item].yemekID
        openDetail(id: foodId)
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2.1, height: 200)
    }
}

extension MainPageViewController: MainViewInterface {
    func openDetail(id foodId: String) {
        guard let food = viewModel.retriveFood(with: foodId) else { return }
        let detailFoodViewModel = FoodViewModel(food: food)
        let detailFoodViewController = DetailsFoodViewController(foodViewModel: detailFoodViewModel)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .label
        navigationItem.backBarButtonItem = backItem
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailFoodViewController, animated: true)
        }
    }
    
    func bindViewModel() {
        viewModel.cellDataSource.bind { [weak self] yemekler in
            guard let self = self, let foods = yemekler else { return }
            
            self.cellDataSource = foods
            self.reloadData()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.foodCollectionView.reloadData()
        }
    }
    
    func setDelegateUI() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.register(FoodCollectionViewCell.register(), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
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
        viewModel.searchHandler(contains: "")
        searchTextField.endEditing(true)
    }

    internal func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
