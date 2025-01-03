//
//  PSharedPreferences.swift
//  Bakim
//
//  Created by Feyzullah Durası on 3.10.2024.
//

import Foundation

final class PreferencesManager {
    static let shared = PreferencesManager()
    
    private let defaults = UserDefaults.standard
    private let lastSavedTimeKey = "preferences_time"
    private let authTokenKey = "auth_token"
    private let userSettingsKey = "user_settings"
    
    private init() {}
    
    // MARK: - Time Management
    func saveTime(_ time: TimeInterval) {
        defaults.set(time, forKey: lastSavedTimeKey)
    }
    
    func getTime() -> TimeInterval? {
        let time = defaults.double(forKey: lastSavedTimeKey)
        return time != 0 ? time : nil
    }
    
    // MARK: - Auth Token
    func saveAuthToken(_ token: String) {
        defaults.set(token, forKey: authTokenKey)
    }
    
    func getAuthToken() -> String? {
        defaults.string(forKey: authTokenKey)
    }
    
    func clearAuthToken() {
        defaults.removeObject(forKey: authTokenKey)
    }
    
    // MARK: - Settings
    func saveSettings<T: Encodable>(_ settings: T) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: userSettingsKey)
        }
    }
    
    func getSettings<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = defaults.data(forKey: userSettingsKey),
              let decoded = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return decoded
    }
}
