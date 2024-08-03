// Created by zhejun.chen on 2024/08/04

import Foundation
import Combine

struct DataFetchStatus<T> {
    var data: T
    var isLoading: Bool = false
}

@MainActor
class UserRepoListViewModel: ObservableObject {
    private enum Constants {
        static let perPageNumber = 20
    }

    private let repo: GithubRepository
    private var coordinator: AppCoordinator
    @Published private(set) var repoList: DataFetchStatus<[UserRepo]> = .init(data: [])
    @Published private(set) var userDetail: DataFetchStatus<UserDetail?> = .init(data: nil)
    var login: String = ""

    init(repo: GithubRepository, coordinator: AppCoordinator) {
        self.repo = repo
        self.coordinator = coordinator
    }

    func loadAll() {
        if userDetail.data == nil {
            Task {
                await loadUserDetail()
            }
        }

        if repoList.data.isEmpty {
            Task {
                await loadList()
            }
        }
    }

    func loadUserDetail() async {
        guard !userDetail.isLoading else { return }
        userDetail.isLoading = true
        defer { userDetail.isLoading = false }

        do {
            userDetail.data = try await repo.getUserDetail(login: login)
        } catch {
            // TODO: handle error
        }
    }

    func loadList() async {
        guard !repoList.isLoading else { return }
        repoList.isLoading = true
        defer { repoList.isLoading = false }

        do {
            if repoList.data.isEmpty {
                repoList.data = try await repo.getUserRepoList(login: login, page: 0, perPage: Constants.perPageNumber)
            } else {
                let currentPage: Int = repoList.data.count / Constants.perPageNumber
                let newListItem = try await repo.getUserRepoList(login: login, page: currentPage + 1, perPage: Constants.perPageNumber)
                repoList.data += newListItem
            }
        } catch {
            // TODO: handle error
        }
    }

    func didSelect(repo: UserRepo) {
        if let url = URL(string: repo.svnUrl) {
            coordinator.push(destination: .userRepoDetail(url: url))
        }
    }
}
