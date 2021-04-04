//
//  ViewController.swift
//  MyDocuments
//
//  Created by Егор Никитин on 30.03.2021.
//

import UIKit

final class DocumentsViewController: UIViewController {
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var contentFolder: [URL] = [] {
        didSet {
            filesTableView.reloadData()
        }
    }
    
    var contentPhotos: [URL] = []
    
    var isDoNotSortAlphabetically : Bool = UserDefaults.standard.bool(forKey: Keys.doNotSortAlphabetically.rawValue) {
        didSet {
            contentFolder = isDoNotSortAlphabetically == false ? findFoldersInDirectory().sorted( by: {$0.lastPathComponent < $1.lastPathComponent}) : findFoldersInDirectory().sorted( by: {$0.lastPathComponent > $1.lastPathComponent})
        }
    }
    
    var isDoNotShowImagesVolume: Bool  = UserDefaults.standard.bool(forKey: Keys.doNotShowImagesVolume.rawValue) {
        didSet {
            filesTableView.reloadData()
        }
    }
    
    private let filesTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    private lazy var addFolderBarButton: UIBarButtonItem = {
        $0.action = #selector(addFolder)
        $0.image = UIImage.init(systemName: "folder.fill.badge.plus")
        $0.style = .plain
        $0.target = self
        $0.tintColor = UIColor.black
        return $0
        }(UIBarButtonItem())
    
    private lazy var addPhotoBarButton: UIBarButtonItem = {
        $0.action = #selector(addPhoto)
        $0.image = UIImage.init(systemName: "photo")
        $0.style = .plain
        $0.target = self
        $0.tintColor = UIColor.black
        return $0
        }(UIBarButtonItem())
    
    private let cellID = "cellIDVC"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDoNotSortAlphabetically = UserDefaults.standard.bool(forKey: Keys.doNotSortAlphabetically.rawValue)
        isDoNotShowImagesVolume = UserDefaults.standard.bool(forKey: Keys.doNotShowImagesVolume.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [addPhotoBarButton, addFolderBarButton]
        setupLayout()
        navigationItem.title = path.lastPathComponent
        self.navigationController?.navigationBar.isHidden = false
        contentFolder = isDoNotSortAlphabetically == false ? findFoldersInDirectory().sorted( by: {$0.lastPathComponent < $1.lastPathComponent}) : findFoldersInDirectory().sorted( by: {$0.lastPathComponent > $1.lastPathComponent})
        contentPhotos = findPhotosInDirectory()
    
    }

   private func setupLayout() {
    
    view.addSubview(filesTableView)
    filesTableView.dataSource = self
    filesTableView.delegate = self
    imagePicker.delegate = self
    filesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    
    NSLayoutConstraint.activate([
        
        filesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        filesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        filesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        filesTableView.topAnchor.constraint(equalTo: view.topAnchor)
        
    ])
   }
    
    private func findFoldersInDirectory() -> [URL] {
        let allContent = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [URLResourceKey.nameKey])
        var folders: [URL] = []
        if let allContentUnwrapped = allContent {
            for folder in allContentUnwrapped {
                if folder.lastPathComponent != ".DS_Store" && !folder.lastPathComponent.contains(".jpeg") {
                    folders.append(folder)
                }
            }
            return folders
        } else {
            return folders
        }
    }
    
    private func findPhotosInDirectory() -> [URL] {
        let allContent = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [URLResourceKey.nameKey])
        var photos: [URL] = []
        if let allContentUnwrapped = allContent {
            for photo in allContentUnwrapped {
                if photo.lastPathComponent.contains(".jpeg") {
                    photos.append(photo)
                }
            }
            return photos
        } else {
            return photos
        }
    }
    
    @objc func addFolder(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "Folder name"
        }
        let alertActionAdd = UIAlertAction(title: "Create", style: .default) { (alert) in
            let folderName = alertController.textFields?[0].text
            if folderName != "" {
                
                let folder = self.path.appendingPathComponent("/\(folderName ?? "NewFolder")")
                do {
                    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false, attributes: [FileAttributeKey.type : "Folder"])
                    self.contentFolder = self.findFoldersInDirectory()
                    self.filesTableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertActionAdd)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addPhoto(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
}







extension DocumentsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 && !contentFolder.isEmpty {
            return "Folders"
        } else if section == 1 && !contentPhotos.isEmpty {
            return "Images"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contentFolder.count
        } else {
            return contentPhotos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        if indexPath.section == 0 {
            cell?.textLabel?.text = contentFolder[indexPath.row].lastPathComponent
            cell?.imageView?.image = UIImage(systemName: "folder")
            cell?.imageView?.tintColor = UIColor.black
            cell?.accessoryType =  .disclosureIndicator
        } else {
            cell?.textLabel?.text = "jpeg"
            if let data = try? Data(contentsOf: contentPhotos[indexPath.row]) {
                
                cell?.imageView?.image = UIImage(data: data)
                
                if isDoNotShowImagesVolume == false {
                    cell?.textLabel?.text?.append("(\(String(data.count)) bytes)")
                }
                
            }
            cell?.selectionStyle = .none
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let folderViewController = DocumentsViewController()
            folderViewController.path = contentFolder[tableView.indexPathForSelectedRow!.row]
            navigationController?.pushViewController(folderViewController, animated: true)
            
        }
    }
    
    
}



extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let tmpFilename = UUID().uuidString
            let newURL = path.appendingPathComponent("\(tmpFilename).jpeg")
            do {
                try FileManager.default.moveItem(at: imageURL, to: newURL)
                contentPhotos = findPhotosInDirectory()
                filesTableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
