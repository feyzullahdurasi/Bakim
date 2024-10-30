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
    @State private var selectedDate = Date()
    @State private var selectedTime = "09:00"
    @State private var selectedFeatures: Set<ServiceFeature> = []
    @State private var newComment = ""
    @State private var isReservationActive = false
    
    let service: Service
    let business: Business
    let availableHours = (9...18).map { String(format: "%02d:00", $0) }
    
    init(service: Service, business: Business) {
        self.service = service
        self.business = business
        _viewModel = StateObject(wrappedValue: ServiceDetailViewModel(service: service, business: business))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    serviceInfoSection
                    serviceFeaturesSection
                    dateTimeSection
                    locationSection
                    commentsSection
                    addCommentSection
                }
                .padding()
            }
            .navigationTitle(service.serviceType.description)
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Information"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("Ok"))
                )
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
            AsyncImage(url: URL(string: business.BusinessImage)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            HStack {
                VStack(alignment: .leading) {
                    Text(business.BusinessName)
                        .font(.title)
                    Text(business.BusinessAddress)
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(business.BusinessPrice)
                        .font(.headline)
                    Text(business.BusinessHours)
                        .font(.subheadline)
                }
            }
        }
    }
    
    private var serviceFeaturesSection: some View {
        VStack(alignment: .leading) {
            Text("Available Services")
                .font(.headline)
            
            ForEach(service.serviceFeature, id: \.name) { feature in
                Toggle(isOn: Binding(
                    get: { selectedFeatures.contains(feature) },
                    set: { isSelected in
                        if isSelected {
                            selectedFeatures.insert(feature)
                        } else {
                            selectedFeatures.remove(feature)
                        }
                    }
                )) {
                    HStack {
                        Text(feature.name)
                        Spacer()
                        Text("\(feature.price)₺ (\(feature.duration) min)")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading) {
            Text("Select Date & Time")
                .font(.headline)
            
            DatePicker("Select Date",
                      selection: $selectedDate,
                      in: Date()...,
                      displayedComponents: .date)
            
            Picker("Select Time", selection: $selectedTime) {
                ForEach(availableHours, id: \.self) { hour in
                    Text(hour).tag(hour)
                }
            }
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(.headline)
            
            if let location = business.location.first {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )), interactionModes: [])
                .frame(height: 200)
                .cornerRadius(10)
                
                Text(location.adress)
                    .font(.subheadline)
                    .padding(.top, 5)
            }
        }
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading) {
            Text("Reviews")
                .font(.headline)
            
            ForEach(business.comments, id: \.username) { comment in
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
                }
                .padding(.vertical, 4)
                Divider()
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
                    viewModel.addUserComment(newComment)
                    newComment = ""
                }
                .disabled(newComment.isEmpty)
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total Price")
                    .font(.subheadline)
                Text("\(totalPrice)₺")
                    .font(.headline)
            }
            
            Spacer()
            
            Button {
                if !selectedFeatures.isEmpty {
                    isReservationActive = true
                } else {
                    viewModel.showAlert(message: "Please select at least one service")
                }
            } label: {
                Text("Make Appointment")
                    .padding()
                    .background(selectedFeatures.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedFeatures.isEmpty)
        }
        .padding()
    }
    
    private var totalPrice: Int {
        selectedFeatures.reduce(0) { $0 + $1.price }
    }
}


