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
                    CommentRow( comment: comment)
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
    var comment: UserComment
    
    var body: some View {
        HStack( spacing: 5) {
            Text(comment.username)
                .font(.subheadline)
                .bold()
                .padding()
            Text(comment.commentText ?? "boş")
                .font(.body)
                .foregroundColor(.gray)
            Spacer()
            Text(comment.rating.description)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
                .cornerRadius(8)
                .shadow(radius: 5)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    FeedbackView(viewModel: FeedbackViewModel())
}

// ViewModel to handle comment fetching and adding
class FeedbackViewModel: ObservableObject {
    @Published var comments: [UserComment] = []
    
    func fetchComments() {
        // Simulate loading comments (replace with actual data fetching logic)
        comments = [
            UserComment(id: UUID(), username: "User1", rating: 4, commentText: "Great service!"),
            UserComment(id: UUID(), username: "User2", rating: 5, commentText: "Very satisfied with my appointment."),
            UserComment(id: UUID(), username: "User3", rating: 4, commentText: "Professional and friendly.")
        ]
    }
    
    func addComment(_ comment: UserComment) {
        comments.append(comment)
    }
}

struct Barber {
    let id: Int
    let barberName: String
    let localeName: String
    let barberImage: String
}




