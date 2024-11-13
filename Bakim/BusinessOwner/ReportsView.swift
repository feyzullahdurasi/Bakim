//
//  ReportsView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.11.2024.
//

import SwiftUI
import Charts

struct ReportsView: View {
    @StateObject private var viewModel = ReportsViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("daily_revenue")
                    .font(.title)
                    .bold()

                if let data = viewModel.dailyRevenueData {
                    Chart(data) { item in
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            y: .value("Revenue", item.revenue)
                        )
                        .foregroundStyle(Color(red: 0.2, green: 0.4, blue: 0.8)) // Set color
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 7)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel(date.formatted(.dateTime.month().day()))
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 300)
                } else {
                    ProgressView()
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("reports")
        }
        .onAppear {
            viewModel.fetchDailyRevenue()
        }
    }
}

class ReportsViewModel: ObservableObject {
    @Published var dailyRevenueData: [DailyRevenueItem]?
    @Published var maxRevenue: Double = 0

    func fetchDailyRevenue() {
        let sampleData = [
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -6 * 24 * 3600), revenue: 1200),
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -5 * 24 * 3600), revenue: 2500),
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -4 * 24 * 3600), revenue: 1800),
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -3 * 24 * 3600), revenue: 1000),
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -2 * 24 * 3600), revenue: 1900),
            DailyRevenueItem(date: Date(timeIntervalSinceNow: -1 * 24 * 3600), revenue: 2100),
            DailyRevenueItem(date: Date(), revenue: 2300)
        ]

        dailyRevenueData = sampleData
        maxRevenue = sampleData.max { $0.revenue < $1.revenue }?.revenue ?? 0
    }
}

#Preview {
    ReportsView()
}


