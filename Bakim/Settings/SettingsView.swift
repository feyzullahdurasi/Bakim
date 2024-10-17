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
    @AppStorage("language") private var selectedLanguage = "Türkçe"
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    let languages = ["Türkçe", "English", "Deutsch"]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bildirimler")) {
                    Toggle("Bildirimleri Etkinleştir", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue, _ in
                            showToast(message: newValue ? "Bildirimler Açık" : "Bildirimler Kapalı")
                        }
                }
                
                Section(header: Text("Tema")) {
                    Button("Chose Theme") {
                        changeTheme.toggle()
                    }
                }
                
                Section(header: Text("Dil")) {
                    Picker("Dil Seçimi", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: selectedLanguage) { newValue, _ in
                        showToast(message: "Dil değiştirildi: \(newValue)")
                    }
                }
                
                Section {
                    Button("Gizlilik Politikası") {
                        showToast(message: "Gizlilik Politikası açıldı")
                    }
                    
                    Button("Hakkında") {
                        showToast(message: "Uygulama hakkında bilgi")
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView()
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
    
    private func setAppTheme(isDark: Bool) {
        // SwiftUI'da temayı doğrudan değiştiremeyiz, bu yüzden kullanıcıya bir mesaj gösteriyoruz
        showToast(message: isDark ? "Koyu Tema" : "Açık Tema")
    }
    
    private func showToast(message: String) {
        // SwiftUI'da doğrudan Toast gösteremiyoruz, bu yüzden bir alert veya overlay kullanabiliriz
        // Bu örnekte sadece print kullanıyoruz
        print(message)
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
