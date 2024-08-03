// Created by zhejun.chen on 2024/08/04

import Foundation
import SwiftUI

@MainActor
class DependencyContainer {
    static var shared: DependencyContainer = .init()

    lazy var githubRepo: GithubRepository = {
        return GithubRepositoryImp(baseURL: "https://api.github.com/")
    }()

    lazy var appCoordinator: AppCoordinatorImp = {
        return AppCoordinatorImp(path: NavigationPath())
    }()

    lazy var rootViewModel: UserListViewModel = {
        return UserListViewModel(repo: githubRepo, coordinator: appCoordinator)
    }()

    func makeUserRepoListViewModel(loginName: String) -> UserRepoListViewModel {
        let vm = UserRepoListViewModel(repo: githubRepo, coordinator: appCoordinator)
        vm.login = loginName
        return vm
    }
}
