// Created by zhejun.chen on 2024/08/04

import Foundation

import SwiftUI
import WebKit

struct SwiftUIWebView: View {
    @State var url: URL
    var body: some View {
        WebView(url: url)
    }
}

#Preview {
    SwiftUIWebView(url: URL(string: "https://google.com")!)
}

struct WebView: UIViewRepresentable {
    let webView: WKWebView
    let url: URL

    init(url: URL) {
        self.webView = WKWebView(frame: .zero)
        self.url = url
    }

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
