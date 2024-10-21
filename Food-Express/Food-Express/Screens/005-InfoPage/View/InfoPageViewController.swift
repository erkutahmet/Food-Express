//
//  InfoPageViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit
import FirebaseAuth

protocol InfoPageViewInterface: AnyObject {
    func setUI()
    func showAlertFromVM(status: Bool, title: String, message: String)
}

final class InfoPageViewController: UIViewController {

    @IBOutlet private weak var settingsTableView: UITableView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var surnameLbl: UILabel!
    @IBOutlet private weak var userPictureImageView: UIImageView!

    private lazy var viewModel = InfoPageViewModel()

    private let list = ["Edit profile", "Change password", "Dark mode"]
    private let list2 = ["About us", "Privacy policy", "Terms of service", "Sign Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
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
            cell.selectionStyle = .none
            cell.accessoryView = toggleSwitch
        } else if cell.textLabel?.text == "Sign Out" {
            cell.textLabel?.textColor = .red
            cell.accessoryType = .none
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1{
            if indexPath.row == 3 {
                errorShowAlertWithOptions(title: "Warning!", message: "Are you sure want to sign out?",
                okCompletion: {
                    self.viewModel.signOutUser()
                }, cancelCompletion: {
                    self.dismiss(animated: true)
                })
            }
        }
    }
}

extension InfoPageViewController: InfoPageViewInterface {
    
    func setUI() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self

        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }

    
    func showAlertFromVM(status: Bool, title: String, message: String) {
        if status {
            self.successShowAlert(title: title, message: message) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let loginVC = LoginViewController()
                appDelegate.window?.rootViewController = loginVC
                appDelegate.window?.makeKeyAndVisible()
            }
        } else {
            self.errorShowAlert(title: title, message: message)
        }
    }
}
