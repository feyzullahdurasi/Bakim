//
//  SettingsView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notifications") private var notificationsEnabled = false
    @AppStorage("darkMode") private var isDarkMode = false
    @StateObject private var languageManager = LanguageManager.shared
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var isBusinessOwner = true
    @State private var isSetInfo = false
    
    let languages = ["Turkish", "English", "Deutsch", "French"]
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
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
                    Button("FeedBack") {
                        sendEmail()
                    }
                    .foregroundColor(.black)
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
                
                if isBusinessOwner {
                    // Business Owner Specific Settings
                    Section(header: Text("Business Settings")) {
                        
                    }
                }
                
                Section(header: Text("exit")) {
                    NavigationLink( destination: SetUserInfoView(fullName: .constant("asdf"), email: .constant("asdf"), businessName: .constant("asdf"), location: .constant("asdf"))) {
                        Text("Update User Information")
                    }
                    Button(action: {
                        logout()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("log_out")
                            .foregroundColor(.red)
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
    
    func sendEmail() {
        let email = "info@businessowner.com"
        let subject = "Feedback"
        let body = "Merhaba,\n\nBu e-postayı geri bildirim için gönderiyorum."
        
        // E-posta URL'sini oluştur
        if let emailURL = createEmailURL(to: email, subject: subject, body: body) {
            // URL'nin geçerli olduğundan emin ol
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                print("Mail uygulaması açılamıyor.")
            }
        }
    }
    
    func createEmailURL(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        return URL(string: urlString)
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
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
}

#Preview {
    SettingsView()
}
