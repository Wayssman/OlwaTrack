//
//  UserConfigurationService.swift
//  OlwaTrack
//
//  Created by Alexandr Zhelanov on 16.10.2023.
//

import Foundation

enum UserConfigurationKey: String {
    case trackEditRepeat
}

final class UserConfigurationService {
    // MARK: Static
    static let shared = UserConfigurationService()
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Interface
    func get(_ key: UserConfigurationKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    func set(_ value: Any?, for key: UserConfigurationKey) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
}
