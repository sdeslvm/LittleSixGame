import WebKit
import SwiftUI

class MedusaVM: ObservableObject {
    @Published var krakenStatus: KrakenState = .idle
    let link: URL
    private var webRef: WKWebView?
    private var progressObs: NSKeyValueObservation?
    private var progressValue: Double = 0.0
    
    init(link: URL) {
        self.link = link
    }
    
    func bindWeb(_ webView: WKWebView) {
        self.webRef = webView
        observeWebProgress(webView)
        reloadWeb()
    }
    
    func reloadWeb() {
        guard let webView = webRef else { return }
        let req = URLRequest(url: link, timeoutInterval: 15.0)
        DispatchQueue.main.async { [weak self] in
            self?.krakenStatus = .progress(percent: 0.0)
            self?.progressValue = 0.0
        }
        webView.load(req)
    }
    
    private func observeWebProgress(_ webView: WKWebView) {
        progressObs = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let prog = webView.estimatedProgress
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if prog > self.progressValue {
                    self.progressValue = prog
                    self.krakenStatus = .progress(percent: self.progressValue)
                }
                if prog >= 1.0 {
                    self.krakenStatus = .done
                }
            }
        }
    }
    
    func setOnline(_ isOnline: Bool) {
        if isOnline && krakenStatus == .offline {
            reloadWeb()
        } else if !isOnline {
            DispatchQueue.main.async { [weak self] in
                self?.krakenStatus = .offline
            }
        }
    }
}
