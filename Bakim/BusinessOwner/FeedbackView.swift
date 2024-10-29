//
//  FeedbackView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 28.10.2024.
//

import SwiftUI

struct FeedbackView: View {
    @ObservedObject var viewModel: FeedbackViewModel
    
    @State private var newComment = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView {
                ForEach(viewModel.comments) { comment in
                    CommentRow(comment: comment)
                }
            }
            
            
        }
        .navigationTitle("Feedback")
        .padding()
        .onAppear {
            viewModel.fetchComments()
        }
    }
}

// Row view for each comment
struct CommentRow: View {
    var comment: Comment
    
    var body: some View {
        HStack( spacing: 5) {
            Text(comment.userName)
                .font(.subheadline)
                .bold()
            Text(comment.text)
                .font(.body)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

// ViewModel to handle comment fetching and adding
class FeedbackViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    func fetchComments() {
        // Simulate loading comments (replace with actual data fetching logic)
        comments = [
            Comment(id: UUID(), userName: "User1", text: "Great service!"),
            Comment(id: UUID(), userName: "User2", text: "Very satisfied with my appointment."),
            Comment(id: UUID(), userName: "User3", text: "Professional and friendly.")
        ]
    }
    
    func addComment(_ comment: Comment) {
        comments.append(comment)
    }
}

struct Barber {
    let id: Int
    let barberName: String
    let localeName: String
    let barberImage: String
}

struct Comment: Identifiable {
    let id: UUID
    let userName: String
    let text: String
}

#Preview {
    FeedbackView(viewModel: FeedbackViewModel())
}
