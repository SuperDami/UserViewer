// Created by zhejun.chen on 2024/08/03

import Foundation

struct User: Codable, Identifiable, Hashable {
    let login: String
    let id: Int
    let avatarUrl: String
    let reposUrl: String
}

struct UserRepo: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String
    let fork: Bool
    let svnUrl: String
    let stargazersCount: Int
    let language: String?
    let description: String?
}

//https://api.github.com/users/mojombo
struct UserDetail: Codable, Identifiable, Hashable {
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String
    let followers: Int
    let following: Int
}
