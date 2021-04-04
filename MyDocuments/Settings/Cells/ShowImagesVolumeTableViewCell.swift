//
//  ShowImagesVolumeTableViewCell.swift
//  MyDocuments
//
//  Created by Егор Никитин on 04.04.2021.
//

import UIKit


final class ShowImagesVolumeTableViewCell: UITableViewCell {
    
    private lazy var showImagesVolumeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Show images volume"
        return $0
    }(UILabel())
    
    private lazy var showImagesVolumeSwitch: UISwitch = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isOn = UserDefaults.standard.bool(forKey: Keys.doNotShowImagesVolume.rawValue) == false ? true : false
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
        contentView.addSubview(showImagesVolumeLabel)
        contentView.addSubview(showImagesVolumeSwitch)
        
        NSLayoutConstraint.activate([
            
            showImagesVolumeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            showImagesVolumeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            showImagesVolumeSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            showImagesVolumeSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
        if (sender.isOn) {
            UserDefaults.standard.setValue(false, forKey: Keys.doNotShowImagesVolume.rawValue)
        } else {
            UserDefaults.standard.setValue(true, forKey: Keys.doNotShowImagesVolume.rawValue)
        }
        
    }
    
    
}
