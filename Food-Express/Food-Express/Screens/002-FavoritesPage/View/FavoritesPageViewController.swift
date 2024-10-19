//
//  FavoritesPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class FavoritesPageViewController: UIViewController {

    @IBOutlet private weak var favoritesTableView: UITableView!
    private var selectedIndices: [Int: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        let nib = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        favoritesTableView.register(nib, forCellReuseIdentifier: "favoriteCell")
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
}

extension FavoritesPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.favoriteImageView.image = UIImage(named: "aboutUs")
        cell.favoriteNameLbl.text = "Hamburger"
        cell.favoriteInfoLbl.text = "Your most favorite."
        
        if let isSelected = selectedIndices[indexPath.row] {
            if isSelected {
                cell.favoriteHeartImageView.image = UIImage(systemName: "heart")
                cell.favoriteHeartImageView.tintColor = .black
            } else {
                cell.favoriteHeartImageView.image = UIImage(systemName: "heart.fill")
                cell.favoriteHeartImageView.tintColor = .systemRed
            }
        } else {
            cell.favoriteHeartImageView.image = UIImage(systemName: "heart.fill")
            cell.favoriteHeartImageView.tintColor = .systemRed
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isSelected = selectedIndices[indexPath.row] {
            selectedIndices[indexPath.row] = !isSelected
        } else {
            selectedIndices[indexPath.row] = true
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
