// Created by zhejun.chen on 2024/08/03

import Foundation
import Combine

@MainActor
class UserListViewModel: ObservableObject {
    private enum Constants {
        static let perPageNumber = 30
    }

    private let repo: GithubRepository
    private var coordinator: AppCoordinator

    @Published private(set) var userList: [User] = []
    @Published private(set) var isLoading: Bool = false

    init(repo: GithubRepository, coordinator: AppCoordinator) {
        self.repo = repo
        self.coordinator = coordinator
    }

    func loadList() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            if let lastUserId = userList.last?.id  {
                let newListItem = try await repo.getUserList(since: lastUserId, perPage: Constants.perPageNumber)
                userList += newListItem
            } else {
                userList = try await repo.getUserList(since: nil, perPage: Constants.perPageNumber)
            }
        } catch {
            // show error
        }
    }

    func didTapOnUser(loginName: String) {
        coordinator.push(destination: .userRepoList(loginName: loginName))
    }

    func viewDidAppear() {
        if userList.isEmpty {
            Task {
                await loadList()
            }
        }
    }
}
