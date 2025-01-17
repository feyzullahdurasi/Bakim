//
//  FeedbackView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 28.10.2024.
//

import SwiftUI

struct FeedbackView: View {
    @StateObject private var viewModel: FeedbackViewModel
    @State private var newComment = ""
    @State private var rating = 5
    @FocusState private var isTextFieldFocused: Bool
    
    init(businessId: Int) {
        _viewModel = StateObject(wrappedValue: FeedbackViewModel(businessId: businessId))
    }
    
    var body: some View {
        LoadingView(isLoading: viewModel.isLoading) {
            VStack(alignment: .leading, spacing: 20) {
                commentsList
                addCommentSection
            }
        }
        .navigationTitle("Feedback")
        .padding()
        .task {
            await viewModel.fetchComments()
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
    
    private var commentsList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.comments) { comment in
                    CommentRow(comment: comment)
                }
            }
        }
    }
    
    private var addCommentSection: some View {
        VStack {
            RatingPicker(rating: $rating)
            
            HStack {
                TextField("Add your comment", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocused)
                
                Button("Send") {
                    Task {
                        await viewModel.addComment(newComment, rating: rating)
                        newComment = ""
                        isTextFieldFocused = false
                    }
                }
                .disabled(newComment.isEmpty)
            }
        }
        .padding()
    }
}

struct RatingPicker: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { number in
                Image(systemName: number <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}