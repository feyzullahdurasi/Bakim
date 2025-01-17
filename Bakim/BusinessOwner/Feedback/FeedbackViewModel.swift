//
//  FeedbackViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.01.2025.
//

import Foundation

@MainActor
class FeedbackViewModel: ObservableObject {
    @Published var comments: [UserComment] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showAlert = false
    
    private let repository: FeedbackRepositoryProtocol
    private let businessId: Int
    
    init(repository: FeedbackRepositoryProtocol = FeedbackRepository(),
         businessId: Int) {
        self.repository = repository
        self.businessId = businessId
    }
    
    func fetchComments() async {
        isLoading = true
        do {
            comments = try await repository.fetchComments(businessId: businessId)
        } catch {
            self.error = error
            showAlert = true
        }
        isLoading = false
    }
    
    func addComment(_ comment: String, rating: Int) async {
        isLoading = true
        do {
            let newComment = try await repository.addComment(
                businessId: businessId,
                comment: comment,
                rating: rating
            )
            comments.append(newComment)
        } catch {
            self.error = error
            showAlert = true
        }
        isLoading = false
    }
}

protocol FeedbackRepositoryProtocol {
    func fetchComments(businessId: Int) async throws -> [UserComment]
    func addComment(businessId: Int, comment: String, rating: Int) async throws -> UserComment
}

class FeedbackRepository: FeedbackRepositoryProtocol {
    private let networkService = NetworkService.shared
    
    func fetchComments(businessId: Int) async throws -> [UserComment] {
        return try await networkService.request(
            endpoint: "/businesses/\(businessId)/comments",
            method: "GET"
        )
    }
    
    func addComment(businessId: Int, comment: String, rating: Int) async throws -> UserComment {
        let commentRequest = CommentRequest(
            comment: comment,
            rating: rating,
            userId: UserDefaults.standard.integer(forKey: "userId")
        )
        
        return try await networkService.request(
            endpoint: "/businesses/\(businessId)/comments",
            method: "POST",
            body: try? JSONEncoder().encode(commentRequest)
        )
    }
}
