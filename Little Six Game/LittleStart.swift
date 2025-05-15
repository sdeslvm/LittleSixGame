import WebKit

class TritonCoordinator: NSObject, WKNavigationDelegate {
    let container: KronosWebStage
    var flag = false
    
    init(container: KronosWebStage) {
        self.container = container
    }
    
    private func setKraken(_ state: KrakenState) {
        DispatchQueue.main.async { [weak self] in
            self?.container.hydraModel.krakenStatus = state
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if !flag { setKraken(.progress(percent: 0.0)) }
    }
    
    func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
        flag = false
    }
    
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        setKraken(.done)
    }
    
    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        setKraken(.error(error))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        setKraken(.error(error))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other && webView.url != nil {
            flag = true
        }
        decisionHandler(.allow)
    }
}
