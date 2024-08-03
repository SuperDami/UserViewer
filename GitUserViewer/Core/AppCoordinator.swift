// Created by zhejun.chen on 2024/08/04

import SwiftUI

enum RouteDestination: Hashable {
    case userRepoList(loginName: String)
    case userRepoDetail(url: URL)
}

@MainActor
protocol AppCoordinator {
    func push(destination: RouteDestination)
}

@MainActor
final class AppCoordinatorImp: AppCoordinator, ObservableObject {
    @Published var path: NavigationPath
    init(path: NavigationPath) {
        self.path = path
    }

    @ViewBuilder
    func view() -> some View {
        UserListView(viewModel: DependencyContainer.shared.rootViewModel)
            .navigationDestination(for: RouteDestination.self) { value in
                switch value {
                case .userRepoList(let loginName):
                    let vm = DependencyContainer.shared.makeUserRepoListViewModel(loginName: loginName)
                    UserRepoListView(viewModel: vm)
                case .userRepoDetail(let url):
                    SwiftUIWebView(url: url)
                }
            }
    }

    func push(destination: RouteDestination) {
        path.append(destination)
    }
}
