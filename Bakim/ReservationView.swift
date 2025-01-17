//
//  ReservationView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 17.10.2024.
//

import SwiftUI

struct ReservationView: View {
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var cardHolderName = ""
    @State private var saveCard = false
    
    init(totalPrice: Int, selectedDate: Date, selectedTime: String) {
        self.totalPrice = totalPrice
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
    }
    
    let totalPrice: Int
    let selectedDate: Date
    let selectedTime: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Information")
                .font(.title2)
                .bold()
            
            // Display selected date and time
            VStack(alignment: .leading, spacing: 5) {
                Text("Appointment Date: \(formattedDate)")
                    .font(.headline)
                Text("Appointment Time: \(selectedTime)")
                    .font(.headline)
                Text("Total Price: \(totalPrice)₺")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray6)))
            .padding(.horizontal)
            
            var formattedCardNumber: String {
                return cardNumber.chunked(into: 4).joined(separator: " ")
            }
            VStack (spacing: 15){
                TextField("Kart Numarası", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: cardNumber) { newValue, _ in
                        formatCardNumber(newValue)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(Text(formattedCardNumber).opacity(0))
                
                HStack {
                    TextField("Expiration Date (MM/YY)", text: $expirationDate)
                        .keyboardType(.numberPad)
                        .onChange(of: expirationDate) { newValue, _ in
                            formatExpirationDate(newValue)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("CVV", text: $cvv)
                        .onChange(of: cvv) { newValue, _ in
                            formatCVV(newValue)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                }
                
                TextField("Cardholder Name", text: $cardHolderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
            Toggle(isOn: $saveCard) {
                Text("Save Card")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            
            Button(action: processPayment) {
                Text("Complete Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            
            
        }
        .padding()
        .navigationTitle("Reservation")
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }
    
    private func processPayment() {
        // Payment processing logic (e.g., API call for payment)
        // For now, we'll just show an alert or confirmation message
        print("Payment processed for \(totalPrice)₺ on \(formattedDate) at \(selectedTime)")
    }
    
    private func formatCardNumber(_ value: String) {
        let digitsOnly = value.filter { $0.isNumber }
        if digitsOnly.count <= 16 {
            cardNumber = digitsOnly.chunked(into: 4).joined(separator: " ")
        }
    }
    
    private func formatExpirationDate(_ value: String) {
        let digitsOnly = value.filter { $0.isNumber }
        
        if digitsOnly.count > 4 {
            return
        }
        
        if digitsOnly.count > 2 {
            expirationDate = String(digitsOnly.prefix(2)) + "/" + String(digitsOnly.suffix(2))
        } else {
            expirationDate = digitsOnly
        }
    }
    
    private func formatCVV(_ value: String) {
        let digitsOnly = value.filter { $0.isNumber }
        if digitsOnly.count <= 3 {
            cvv = digitsOnly
        }
    }
}

// Ekstra kart numarasını ayırmak için fonksiyon
extension String {
    func chunked(into size: Int) -> [String] {
        stride(from: 0, to: count, by: size).map {
            let startIndex = index(self.startIndex, offsetBy: $0)
            let endIndex = index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[startIndex..<endIndex])
        }
    }
}

#Preview {
    ReservationView(totalPrice: 350, selectedDate: Date(), selectedTime: "14:00")
}
