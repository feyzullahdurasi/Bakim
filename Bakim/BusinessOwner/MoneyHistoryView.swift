//
//  MoneyHistoryView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 28.10.2024.
//

import SwiftUI

// Sample MoneyRecord model
struct MoneyRecord: Identifiable {
    let id: UUID
    let date: Date
    let amount: Double
    let description: String
}

// ViewModel for managing money history
class MoneyHistoryViewModel: ObservableObject {
    @Published var records: [MoneyRecord] = []
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var endDate: Date = Date()
    
    // Filtered records based on the selected date range
    var filteredRecords: [MoneyRecord] {
        records.filter { record in
            record.date >= startDate && record.date <= endDate
        }
    }
    
    // Calculate total income for the filtered records
    var totalIncome: Double {
        filteredRecords.reduce(0) { $0 + $1.amount }
    }
    
    // Load initial sample data
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Replace with actual data-fetching logic
        let sampleRecords = [
            MoneyRecord(id: UUID(), date: Date(), amount: 500.0, description: "Haircut Service"),
            MoneyRecord(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, amount: 300.0, description: "Car Wash Service"),
            MoneyRecord(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, amount: 150.0, description: "Pet Grooming")
        ]
        self.records = sampleRecords
    }
}

struct MoneyHistoryView: View {
    @ObservedObject var viewModel: MoneyHistoryViewModel
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
            }
            .padding()
            
            if viewModel.filteredRecords.isEmpty {
                Text("No records for the selected period")
                    .font(.headline)
                    .padding()
            } else {
                List(viewModel.filteredRecords) { record in
                    MoneyRecordRow(record: record)
                }
                
                HStack {
                    Spacer()
                    Text("Total Income:")
                        .font(.headline)
                    Text("\(viewModel.totalIncome, specifier: "%.2f") TL")
                        .font(.title2)
                        .bold()
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Money History")
    }
}

// Reusable row view for each record
struct MoneyRecordRow: View {
    var record: MoneyRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.description)
                .font(.headline)
            Text("Date: \(record.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Amount: \(record.amount, specifier: "%.2f") TL")
                .font(.body)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let viewModel = MoneyHistoryViewModel()
    MoneyHistoryView(viewModel: viewModel)
}
