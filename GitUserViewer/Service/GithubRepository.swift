// Created by zhejun.chen on 2024/08/03

import Foundation
import Alamofire
import Combine
import Kingfisher

protocol GithubRepository {
    func getUserList(since userId: Int?, perPage: Int) async throws -> [User]
    func getUserRepoList(login: String, page: Int?, perPage: Int) async throws -> [UserRepo]
    func getUserDetail(login: String) async throws -> UserDetail
}

class GithubRepositoryImp: GithubRepository {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func getUserList(since userId: Int? = nil, perPage: Int = 30) async throws -> [User] {
        var query = "?per_page=\(perPage)"
        if let userId {
            query += "&&since=\(userId)"
        }

        return try await AF.request("\(baseURL)users\(query)").asyncResponse([User].self)
    }

    func getUserRepoList(login: String, page: Int? = nil, perPage: Int = 30) async throws -> [UserRepo] {
        var query = "?per_page=\(perPage)"
        if let page {
            query += "&&page=\(page)"
        }
        return try await AF.request("\(baseURL)users/\(login)/repos\(query)").asyncResponse([UserRepo].self)
    }

    //    https://api.github.com/users/login
    func getUserDetail(login: String) async throws -> UserDetail {
        return try await AF.request("\(baseURL)users/\(login)").asyncResponse(UserDetail.self)
    }
}

extension DataRequest {
    func asyncResponse<T>(_ type: T.Type) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            self.response { response in
                switch response.result {
                case .success(let element): do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedResponse = try decoder.decode(type, from: element!)
                    continuation.resume(returning: decodedResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
