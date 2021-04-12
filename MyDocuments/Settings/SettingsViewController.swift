//
//  SettingsViewController.swift
//  MyDocuments
//
//  Created by Егор Никитин on 02.04.2021.
//

import UIKit
import KeychainAccess

final class SettingsViewController: UIViewController {
    
    private let settingsTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    private var reuseID: String {
        return String(describing: SettingsTableViewCell.self)
    }
    
    private let changePasswordID = "cellIDSVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        
        title = "Settings"
        
        setupLayout()
    }
    
    
    private func setupLayout() {
        
        view.addSubview(settingsTableView)
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: changePasswordID)
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: reuseID)
        
        NSLayoutConstraint.activate([
            
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.topAnchor.constraint(equalTo: view.topAnchor)
            
        ])
    }
}




extension SettingsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SettingsTableViewCell
        if indexPath.row == 0 {
            settingsCell.configure(labelText: "Sort alphabetically", userDefaultsKey: Keys.doNotSortAlphabetically.rawValue)
            settingsCell.userDefaultsKey = Keys.doNotSortAlphabetically.rawValue
            return settingsCell
        } else if indexPath.row == 1 {
            settingsCell.configure(labelText: "Show images volume", userDefaultsKey: Keys.doNotShowImagesVolume.rawValue)
            settingsCell.userDefaultsKey = Keys.doNotShowImagesVolume.rawValue
            return settingsCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: changePasswordID)
            cell?.textLabel?.text = "Change password"
            cell?.textLabel?.textColor = .systemBlue
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let loginViewController = LoginViewController()
            loginViewController.isModalViewController = true
            let navVC = UINavigationController(rootViewController: loginViewController)
            navigationController?.present(navVC, animated: true, completion: nil)
        }
    }
    
    
}
