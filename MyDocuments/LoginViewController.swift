//
//  LoginViewController.swift
//  MyDocuments
//
//  Created by Егор Никитин on 01.04.2021.
//

import UIKit
import KeychainAccess

final class LoginViewController: UIViewController {
    
    var isModalViewController: Bool = false
    
    private var iterationEnterPassword: Int = 0
    
    private var passwordContainer: String?
    
    private lazy var passwordTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.8534691637, green: 0.870538547, blue: 0.870538547, alpha: 1)
        $0.isSecureTextEntry = true
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.25
        $0.tintColor = #colorLiteral(red: 0.2823529412, green: 0.5215686275, blue: 0.8, alpha: 1)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 10
        $0.indent(size: 10)
        $0.placeholder = "Enter password"
        return $0
    }(UITextField())
    
    private lazy var enterPasswordButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(1), for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .selected)
        $0.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .highlighted)
        $0.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .disabled)
        $0.setTitle(AppKeychain.keychain["MyPassword"] == nil ? "Crete password" : "Ok", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector (checkOrChangePassword), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var backButton: UIBarButtonItem = {
            var button = UIBarButtonItem()
            button.target = self
            button.title = "Done"
            button.style = .done
            button.action = #selector(backButtonTapped)
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = isModalViewController == false ? true : false
        view.backgroundColor = .white
        setupLayout()
        
        passwordTextField.delegate = self
        
        if isModalViewController {
            enterPasswordButton.setTitle("Change password", for: .normal)
            title = "Change password"
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    private func setupLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(enterPasswordButton)
        
        NSLayoutConstraint.activate([
                
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            enterPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            enterPasswordButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            enterPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            enterPasswordButton.heightAnchor.constraint(equalToConstant: 50)
            
                
            ])
    }
    
    @objc private func checkOrChangePassword() {
        if isModalViewController {
            changePassword()
        } else {
            checkPassword()
        }
    }
    
    private func changePassword() {
        if iterationEnterPassword == 0 && passwordTextField.text?.count ?? 0 == 4 {
            passwordContainer = passwordTextField.text
            enterPasswordButton.setTitle("Enter  password once more", for: .normal)
            iterationEnterPassword = 1
            passwordTextField.text = ""
        } else if iterationEnterPassword == 1 {
            guard passwordContainer == passwordTextField.text  else {
                passwordContainer = nil
                iterationEnterPassword = 0
                passwordTextField.text = ""
                enterPasswordButton.setTitle("Change password", for: .normal)
                showAlertController()
                return
            }
            AppKeychain.keychain["MyPassword"] = passwordTextField.text
            iterationEnterPassword = 0
            showAlertController(title: "Successfully!", message: "Password was changed successfully")
        } else {
            showAlertController(message: "password must contain 4 characters")
        }
    }
    
    private func checkPassword() {
        let isPasswordExists: Bool = AppKeychain.keychain["MyPassword"] == nil ? false : true
        
        if isPasswordExists {
            guard passwordTextField.text == AppKeychain.keychain["MyPassword"] else {
                showAlertController()
                return
            }
            goToTabBarViewController()
        } else {
            createPassword()
        }
    }
    
    private func createPassword() {
        if iterationEnterPassword == 0 && passwordTextField.text?.count ?? 0 == 4 {
            passwordContainer = passwordTextField.text
            enterPasswordButton.setTitle("Enter  password once more", for: .normal)
            iterationEnterPassword = 1
            passwordTextField.text = ""
        } else if iterationEnterPassword == 1 {
            guard passwordContainer == passwordTextField.text  else {
                passwordContainer = nil
                iterationEnterPassword = 0
                passwordTextField.text = ""
                enterPasswordButton.setTitle("Crete password", for: .normal)
                showAlertController()
                return
            }
            AppKeychain.keychain["MyPassword"] = passwordTextField.text
            iterationEnterPassword = 0
            goToTabBarViewController()
        } else {
            showAlertController(message: "password must contain 4 characters")
        }
    }
    
    private func goToTabBarViewController() {
        let tabBarVC = TabBarViewController()
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    
    private func showAlertController(title: String = "Attention!" ,message: String = "Incorrect password") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            print("ОК")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
            dismiss(animated: true) {
                //
            }
        }
    
}




extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordTextField.resignFirstResponder()
        
        return true
    }
}
