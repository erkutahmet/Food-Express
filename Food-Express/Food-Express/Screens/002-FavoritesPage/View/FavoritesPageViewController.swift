//
//  FavoritesPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

protocol FavoritesViewInterface: AnyObject {
    func setUI()
    func bindViewModel()
    func reloadData()
    func showAlert(status: Bool, title: String, message: String)
}

final class FavoritesPageViewController: UIViewController {

    @IBOutlet private weak var favoritesTableView: UITableView!
    private var selectedIndices: [Int: Bool] = [:]
    private lazy var viewModel = FavoritesViewModel()
    private var cellDataSource = [FavoritesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

extension FavoritesPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isDataSourceEmpty = cellDataSource.isEmpty
        favoritesTableView.isHidden = isDataSourceEmpty
        return isDataSourceEmpty ? 0 : cellDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier,
                                                       for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }

        let favorites = cellDataSource[indexPath.row]
        cell.setupCell(viewModel: favorites, at: indexPath)
        cell.setCellUI()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.deleteFavorite(foodName: cellDataSource[indexPath.row].foodName)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension FavoritesPageViewController: FavoritesViewInterface {
    func setUI() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.register(FavoriteTableViewCell.register(),
                                    forCellReuseIdentifier: FavoriteTableViewCell.identifier)
    }

    func bindViewModel() {
        viewModel.favorites.bind { [weak self] favorites in
            guard let self = self, let favorite = favorites else { return }

            self.cellDataSource = favorite
            self.reloadData()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }

    func showAlert(status: Bool, title: String, message: String) {
        if status {
            successShowAlert(title: title, message: message, duration: 1.5)
        } else {
            errorShowAlert(title: title, message: message)
        }
    }
}
