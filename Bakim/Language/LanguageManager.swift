//
//  LanguageBundle.swift
//  Bakim
//
//  Created by Feyzullah Durası on 24.10.2024.
//

import Foundation
import SwiftUI
import Combine

// LocalizedBundle implementation
final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

// Bundle extension
private var bundleKey: UInt8 = 0

extension Bundle {
    static func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,
            Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? ""),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// Language Manager
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            updateLanguage()
        }
    }
    
    private init() {
        currentLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ??
            Locale.current.language.languageCode?.identifier ?? "en"
        updateLanguage()
    }
    
    private func updateLanguage() {
        Bundle.setLanguage(currentLanguage)
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
}

// LocalizedViewWrapper
struct LocalizedViewWrapper<Content: View>: View {
    @StateObject private var languageManager = LanguageManager.shared
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
    }
}
