import WebKit
import Foundation

class LittleWebCoordinator: NSObject, WKNavigationDelegate {
    private let littleCallback: (LittleWebStatus) -> Void
    private var littleDidStart = false

    init(onLittleStatus: @escaping (LittleWebStatus) -> Void) {
        self.littleCallback = onLittleStatus
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if !littleDidStart { littleCallback(.littleProgressing(progress: 0.0)) }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        littleDidStart = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        littleCallback(.littleFinished)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        littleCallback(.littleFailure(reason: error.localizedDescription))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        littleCallback(.littleFailure(reason: error.localizedDescription))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other && webView.url != nil {
            littleDidStart = true
        }
        decisionHandler(.allow)
    }
}
