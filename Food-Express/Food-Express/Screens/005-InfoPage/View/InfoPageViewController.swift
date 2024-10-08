//
//  InfoPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class InfoPageViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var surnameLbl: UILabel!
    @IBOutlet weak var userPictureImageView: UIImageView!

    let list = ["Edit profile", "Change password", "Dark mode"]
    let list2 = ["About us", "Privacy policy", "Terms of service"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.dataSource = self
        settingsTableView.delegate = self

        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
}

extension InfoPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? list.count : list2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        cell.textLabel?.text = indexPath.section == 0 ? list[indexPath.row] : list2[indexPath.row]

        let toggleSwitch = UISwitch()
        let savedStyle = UserDefaults.standard.string(forKey: "userInterfaceStyle") ?? "light"
        toggleSwitch.isOn = (savedStyle == "dark")
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        if cell.textLabel?.text == "Dark mode" {
            cell.accessoryView = toggleSwitch
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        if sender.isOn {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.set("dark", forKey: "userInterfaceStyle")
        } else {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.set("light", forKey: "userInterfaceStyle") 
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .systemGray2
        
        if section == 0 {
            titleLabel.text = "Settings"
        } else {
            titleLabel.text = "About"
        }
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray5
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            separatorView.topAnchor.constraint(equalTo: headerView.topAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}

extension InfoPageViewController: UITableViewDelegate {
    
}
