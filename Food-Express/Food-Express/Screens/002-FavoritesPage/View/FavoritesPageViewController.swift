//
//  FavoritesPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class FavoritesPageViewController: UIViewController {

    @IBOutlet private weak var favoritesTableView: UITableView!

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
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let favoriteCell = cell as? FavoriteTableViewCell else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            favoriteCell.favoriteHeartImageView.image = UIImage(systemName: "heart.fill")
            favoriteCell.favoriteHeartImageView.tintColor = .systemRed
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
