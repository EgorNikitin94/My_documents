//
//  SortingFilesTableViewCell.swift
//  MyDocuments
//
//  Created by Егор Никитин on 04.04.2021.
//

import UIKit

final class SortingFilesTableViewCell: UITableViewCell {
    
    private lazy var sortAlphabetically: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Sort alphabetically"
        return $0
    }(UILabel())
    
    private lazy var alphabetSwitch: UISwitch = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isOn = UserDefaults.standard.bool(forKey: Keys.doNotSortAlphabetically.rawValue) == false ? true : false
        $0.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return $0
    }(UISwitch())
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(sortAlphabetically)
        contentView.addSubview(alphabetSwitch)
        
        NSLayoutConstraint.activate([
            
            sortAlphabetically.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            sortAlphabetically.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            alphabetSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            alphabetSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
        if (sender.isOn) {
            UserDefaults.standard.setValue(false, forKey: Keys.doNotSortAlphabetically.rawValue)
        } else {
            UserDefaults.standard.setValue(true, forKey: Keys.doNotSortAlphabetically.rawValue)
        }
        
    }
    
}


