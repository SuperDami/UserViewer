// Created by zhejun.chen on 2024/08/04

import Combine
import Foundation
import Kingfisher
import SwiftUI

public struct RemoteImage: View {
    private let url: URL?
    private let placeholder: SwiftUI.Image?

    public init(url: URL?, placeholder: SwiftUI.Image? = nil) {
        self.url = url
        self.placeholder = placeholder
    }

    public var body: some View {
        KFImage
            .url(url, cacheKey: url?.absoluteString)
            .placeholder {
                placeholder
            }
            .resizable()
    }
}
