//
//  SettingsView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notifications") private var notificationsEnabled = true
    @AppStorage("darkMode") private var isDarkMode = false
    @StateObject private var languageManager = LanguageManager.shared
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    let languages = ["Turkish", "English", "Deutsch", "French"]
    
    @Environment(\.colorScheme) var colorScheme
    
    // Dil kodlarını görüntülenen dil adlarıyla eşleştiren bir dictionary
    private let languageMapping: [String: String] = [
        "tr": "Turkish",
        "en": "English",
        "de": "Deutsch",
        "fr": "French"
    ]
    
    // Görüntülenen dil adını dil koduna çeviren computed property
    private var displayLanguage: String {
        languageMapping.first(where: { $0.key == languageManager.currentLanguage })?.value ?? "English"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue, _ in
                            showToast(message: newValue ? "Bildirimler Açık" : "Bildirimler Kapalı")
                        }
                }
                
                Section(header: Text("Tema")) {
                    Button("Chose Theme") {
                        changeTheme.toggle()
                    }
                }
                
                Section(header: Text("Language")) {
                    Picker("Select Language", selection: $languageManager.currentLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                                .tag(getLanguageCode(for: language) ?? "en")
                        }
                    }
                }
                
                Section(header: Text("Exit")) {
                    Button("Update User Information") {
                        
                    }
                    Button("Log Out") {
                        
                    }
                }
                
                Section {
                    Button("Privacy Policy") {
                        showToast(message: "Gizlilik Politikası açıldı")
                    }
                    
                    Button("About") {
                        showToast(message: "Uygulama hakkında bilgi")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView()
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
    
    private func setAppTheme(isDark: Bool) {
        showToast(message: isDark ? "Dark Theme" : "Light Theme")
    }
    
    private func showToast(message: String) {
        print(message)
    }
    
    private func getLanguageCode(for language: String) -> String? {
        switch language {
        case "Turkish": return "tr"
        case "English": return "en"
        case "Deutsch": return "de"
        case "French": return "fr"
        default: return nil
        }
    }
}

#Preview {
    SettingsView()
}

enum Theme : String, CaseIterable {
    case systemDefault = "default"
    case light = "light"
    case dark = "dark"
    
    var colorSheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
