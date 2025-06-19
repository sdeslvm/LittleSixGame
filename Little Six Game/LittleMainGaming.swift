import SwiftUI
import Foundation

struct LittleGameEntryScreen: View {
    @StateObject private var littleLoader: LittleWebLoader

    init(littleLoader: LittleWebLoader) {
        _littleLoader = StateObject(wrappedValue: littleLoader)
    }

    var body: some View {
        ZStack {
            LittleWebViewBox(littleLoader: littleLoader)
                .opacity(littleLoader.littleState == .littleFinished ? 1 : 0.5)
            switch littleLoader.littleState {
            case .littleProgressing(let percent):
                LittleProgressIndicator(littleValue: percent)
            case .littleFailure(let err):
                LittleErrorIndicator(littleErr: err) // err теперь String
            case .littleNoConnection:
                LittleOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct LittleProgressIndicator: View {
    let littleValue: Double
    var body: some View {
        GeometryReader { geo in
            LittleLoadingOverlay(littleProgress: littleValue)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct LittleErrorIndicator: View {
    let littleErr: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(littleErr)").foregroundColor(.red)
    }
}

private struct LittleOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
