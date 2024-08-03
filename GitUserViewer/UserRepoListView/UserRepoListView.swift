// Created by zhejun.chen on 2024/08/03

import SwiftUI
import Combine

struct UserDetailView: View {
    let viewData: UserDetail?

    var body: some View {
        let viewData = viewData ?? .init(login: "unknow", id: 0, avatarUrl: "", name: "unknow", followers: 0, following: 0)
        VStack {
            RemoteImage(url: URL(string: viewData.avatarUrl))
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .cornerRadius(50)
                .padding(.bottom, 20)
            HStack {
                Text(viewData.name)
                    .font(.title)
            }
            .padding(.bottom, 8)
            HStack(spacing: 8, content: {
                Text("Followers: \(viewData.followers)")
                Text("Following: \(viewData.following)")
            })
            .foregroundColor(.secondary)
        }
    }
}

struct RepoListItemView: View {
    let viewData: UserRepo

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(viewData.name)
                .underline()
                .font(.title2)
            if let description = viewData.description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .font(.title3)
            }
            Spacer()
            Text("Language: \(viewData.language ?? "unknow")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Stars: \(viewData.stargazersCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct UserRepoListView: View {
    @ObservedObject private var viewModel: UserRepoListViewModel

    init(viewModel: UserRepoListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0, content: {
                    UserDetailView(viewData: viewModel.userDetail.data)
                    .padding()

                    let list = viewModel.repoList.data.filter { $0.fork == false }
                    ForEach(0..<list.count, id: \.self) { index in
                        let item = list[index]
                        Rectangle().frame(height: 1)
                            .foregroundColor(.gray)
                        RepoListItemView(viewData: item)
                            .contentShape(Rectangle())
                            .padding()
                            .onTapGesture {
                                viewModel.didSelect(repo: item)
                            }
                    }
                    Rectangle()
                        .hidden()
                        .onAppear {
                            Task {
                                await viewModel.loadList()
                            }
                        }
                    if viewModel.repoList.isLoading {
                        ProgressView()
                    } else if list.isEmpty {
                        Button("Reload") {
                            Task {
                                await viewModel.loadList()
                            }
                        }
                    }
                })
            }
        }
        .onAppear {
            viewModel.loadAll()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.login)
    }
}

#Preview {
    let vm = DependencyContainer.shared.makeUserRepoListViewModel(loginName: "mojombo")
    return NavigationStack {
        UserRepoListView(viewModel: vm)
    }
}
