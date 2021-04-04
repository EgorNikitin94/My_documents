//
//  Keychain.swift
//  MyDocuments
//
//  Created by Егор Никитин on 05.04.2021.
//

import Foundation
import KeychainAccess

class AppKeychain {
    
    static let keychain = Keychain(service: "MyDocuments")
    
}
