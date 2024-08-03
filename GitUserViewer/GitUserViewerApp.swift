// Created by zhejun.chen on 2024/08/03

import SwiftUI

@main
struct GitUserViewerApp: App {
    @StateObject private var appCoordinator = DependencyContainer.shared.appCoordinator

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                appCoordinator.view()
            }
            .navigationViewStyle(.stack)
        }
    }
}
