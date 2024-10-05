//
//  PSharedPreferences.swift
//  Bakim
//
//  Created by Feyzullah Durası on 3.10.2024.
//

import Foundation

class PSharedPreferences {

    // Tekil örnek oluşturmak için Singleton yapı
    static let shared = PSharedPreferences()

    private let lastSavedTimeKey = "preferences_time"

    private init() {}

    // Zamanı kaydet
    func saveTime(_ time: TimeInterval) {
        UserDefaults.standard.set(time, forKey: lastSavedTimeKey)
    }

    // Kaydedilen zamanı al
    func getTime() -> TimeInterval? {
        let time = UserDefaults.standard.double(forKey: lastSavedTimeKey)
        return time != 0 ? time : nil
    }
}

