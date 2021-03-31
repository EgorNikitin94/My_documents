//
//  ViewController.swift
//  MyDocuments
//
//  Created by Егор Никитин on 30.03.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var contentFolder: [URL] = []
    
    @IBOutlet var filesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.dataSource = self
        filesTableView.delegate = self
        imagePicker.delegate = self
        print(path)
        title = path.lastPathComponent
        contentFolder = findContentOfDirectory()
    
    }

    private func findContentOfDirectory() -> [URL] {
        let content = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [URLResourceKey.nameKey])
        if let contentUnwrapped = content {
            return contentUnwrapped
        } else {
            return []
        }
    }
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
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
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    private func urlsToString() -> [String] {
        let items = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [URLResourceKey.nameKey])
        var itemsString: [String] = []
        if let items = items {
            for item in items {
                if item.lastPathComponent != ".DS_Store" {
                    itemsString.append(item.lastPathComponent)
                }
            }
        }
        return itemsString
    }
}







extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Folders"
        } else {
            return "Images"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contentFolder.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = contentFolder[indexPath.row].lastPathComponent
            cell.accessoryType =  .disclosureIndicator
        } else {
            cell.selectionStyle = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let folderViewController = ViewController()
            folderViewController.path = contentFolder[tableView.indexPathForSelectedRow!.row]
            navigationController?.pushViewController(folderViewController, animated: true)
            
        }
    }
    
    
}



extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        photoImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
