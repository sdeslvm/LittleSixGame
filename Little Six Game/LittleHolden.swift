import WebKit
import SwiftUI
import Foundation

struct KronosWebStage: UIViewRepresentable {
    @ObservedObject var hydraModel: MedusaVM
    typealias Coordinator = TritonCoordinator

    func makeCoordinator() -> TritonCoordinator {
        TritonCoordinator(container: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let zeusConfig = WKWebViewConfiguration()
        zeusConfig.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let heraWeb = WKWebView(frame: .zero, configuration: zeusConfig)
        heraWeb.isOpaque = false
        heraWeb.backgroundColor = CyclopsColor(rgb: "#141f2b")
        
        let titanTypes: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        
        WKWebsiteDataStore.default().removeData(ofTypes: titanTypes, modifiedSince: Date.distantPast) {}
        
        print("WebStage: \(hydraModel.link)")
        
        heraWeb.navigationDelegate = context.coordinator

        hydraModel.bindWeb(heraWeb)
        return heraWeb
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let titanTypes: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: titanTypes, modifiedSince: Date.distantPast) {}
    }
}
