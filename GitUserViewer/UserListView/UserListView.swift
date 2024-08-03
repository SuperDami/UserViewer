// Created by zhejun.chen on 2024/08/03

import SwiftUI
import Combine

struct UserListView: View {
    @ObservedObject var viewModel: UserListViewModel

    public init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            let list = viewModel.userList
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0, content: {
                    ForEach(0..<list.count, id: \.self) { index in
                        let item = list[index]
                        HStack {
                            RemoteImage(url: URL(string: item.avatarUrl))
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                            Text(item.login)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: {
                            viewModel.didTapOnUser(loginName: item.login)
                        })
                        .padding()
                    }
                    Rectangle()
                        .hidden()
                        .onAppear {
                            Task {
                                await viewModel.loadList()
                            }
                        }
                    if viewModel.isLoading {
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
            viewModel.viewDidAppear()
        }
        .navigationViewStyle(.stack)
        .navigationTitle("Git Users")
    }
}

#Preview {
    NavigationStack {
        UserListView(viewModel: DependencyContainer.shared.rootViewModel)
    }
}
