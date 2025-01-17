//
//  ServiceDetailView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import SwiftUI
import MapKit

struct ServiceDetailView: View {
    @StateObject private var viewModel: ServiceDetailViewModel
    
    // View state'leri
    @State private var selectedDate = Date()
    @State private var selectedTime = "09:00"
    @State private var selectedFeatures: Set<ServiceFeature> = []
    @State private var newComment = ""
    @State private var isReservationActive = false
    
    private var availableHours: [String] {
        // Backend'den çalışma saatlerini al
        let businessHours = viewModel.business.hours.split(separator: "-")
        guard businessHours.count == 2,
              let start = Int(businessHours[0]),
              let end = Int(businessHours[1]) else {
            return (9...18).map { String(format: "%02d:00", $0) }
        }
        return (start...end).map { String(format: "%02d:00", $0) }
    }
    
    init(service: Service, business: Business) {
        _viewModel = StateObject(wrappedValue: ServiceDetailViewModel(
            service: service,
            business: business,
            repository: ServiceRepository()
        ))
    }
    
    var body: some View {
        LoadingView(isLoading: viewModel.isLoading) {
            mainContent
        }
        .navigationTitle(viewModel.service.serviceType.description ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Information"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var mainContent: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    serviceInfoSection
                    serviceFeaturesSection
                    dateTimeSection
                    locationSection
                    commentsSection
                    addCommentSection
                }
                .padding()
            }
            .navigationDestination(isPresented: $isReservationActive) {
                ReservationView(
                    totalPrice: totalPrice,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime
                )
            }
            
            Spacer()
            Divider()
            bottomBar
        }
    }
    
    private var serviceInfoSection: some View {
        VStack {
            BusinessImageView(imageURL: viewModel.business.image)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            BusinessInfoHeader(business: viewModel.business)
        }
    }
    
    private var serviceFeaturesSection: some View {
        VStack(alignment: .leading) {
            Text("Available Services")
                .font(.headline)
            
            ForEach(viewModel.service.serviceFeature) { feature in
                ServiceFeatureRow(
                    feature: feature,
                    isSelected: selectedFeatures.contains(feature),
                    onToggle: { isSelected in
                        if isSelected {
                            selectedFeatures.insert(feature)
                        } else {
                            selectedFeatures.remove(feature)
                        }
                    }
                )
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading) {
            Text("Select Date & Time")
                .font(.headline)
            
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: Calendar.current.startOfDay(for: Date())...,
                displayedComponents: .date
            )
            
            Picker("Select Time", selection: $selectedTime) {
                ForEach(availableHours, id: \.self) { hour in
                    Text(hour).tag(hour)
                }
            }
        }
    }
    
    private var locationSection: some View {
        LocationView(location: viewModel.business.location)
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading) {
            Text("Reviews")
                .font(.headline)
            
            if let comments = viewModel.business.comments {
                LazyVStack(alignment: .leading) {
                    ForEach(comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
            } else {
                Text("No reviews yet")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var addCommentSection: some View {
        VStack(alignment: .leading) {
            Text("Add Review")
                .font(.headline)
            
            HStack {
                TextField("Write your review", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add") {
                    Task {
                        await viewModel.addUserComment(newComment)
                        newComment = ""
                    }
                }
                .disabled(newComment.isEmpty)
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            PriceDisplay(totalPrice: totalPrice)
            Spacer()
            ReservationButton(
                isEnabled: !selectedFeatures.isEmpty,
                action: {
                    if !selectedFeatures.isEmpty {
                        Task {
                            await viewModel.makeReservation(
                                date: selectedDate,
                                time: selectedTime,
                                features: selectedFeatures
                            )
                            isReservationActive = true
                        }
                    }
                }
            )
        }
        .padding()
    }
    
    private var totalPrice: Int {
        selectedFeatures.reduce(0) { $0 + Int($1.price) }
    }
}

// MARK: - Supporting Views
struct BusinessImageView: View {
    let imageURL: String?
    
    var body: some View {
        Group {
            if let imageUrl = URL(string: imageURL ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image("berber")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("berber")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct BusinessInfoHeader: View {
    let business: Business
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(business.name)
                    .font(.title)
                Text(business.address)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(business.price)
                    .font(.headline)
                Text(business.hours)
                    .font(.subheadline)
            }
        }
    }
}

struct ServiceFeatureRow: View {
    let feature: ServiceFeature
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    private var formattedPrice: String {
        let price = NSDecimalNumber(decimal: Decimal(feature.price)).intValue
        return "\(price)₺"
    }
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isSelected },
            set: onToggle
        )) {
            HStack {
                Text(feature.name)
                Spacer()
                Text("\(formattedPrice) (\(feature.duration) min)")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct LocationView: View {
    let location: Location?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(.headline)
            
            if let location = location,
               let latitude = location.latitude,
               let longitude = location.longitude {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01)
                )), interactionModes: [])
                .frame(height: 200)
                .cornerRadius(10)
                
                Text(location.address)
                    .font(.subheadline)
                    .padding(.top, 5)
            } else {
                Text("Location not available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CommentRow: View {
    let comment: UserComment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.username)
                    .font(.subheadline)
                    .bold()
                Spacer()
                Text("\(comment.rating)/5")
            }
            if let commentText = comment.commentText {
                Text(commentText)
                    .font(.subheadline)
            }
            Divider()
        }
        .padding(.vertical, 4)
    }
}

struct LoadingView<Content: View>: View {
    let isLoading: Bool
    let content: Content
    
    init(isLoading: Bool, @ViewBuilder content: () -> Content) {
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .frame(width: 100, height: 100)
                            .shadow(radius: 5)
                    )
            }
        }
    }
}
