import SwiftUI
import WebKit

// MARK: - Протоколы и расширения

/// Протокол для создания градиентных представлений
protocol LittleGradientProviding {
    func littleCreateGradientLayer() -> CAGradientLayer
}

// MARK: - Улучшенный контейнер с градиентом

/// Кастомный контейнер с градиентным фоном
final class LittleGradientContainerView: UIView, LittleGradientProviding {
    // MARK: - Приватные свойства
    
    private let littleGradientLayer = CAGradientLayer()
    
    // MARK: - Инициализаторы
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        littleSetupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        littleSetupView()
    }
    
    // MARK: - Методы настройки
    
    private func littleSetupView() {
        layer.insertSublayer(littleCreateGradientLayer(), at: 0)
    }
    
    /// Создание градиентного слоя
    func littleCreateGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(littleHex: "#1BD8FD").cgColor,
            UIColor(littleHex: "#0FC9FA").cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }
    
    // MARK: - Обновление слоя
    
    override func layoutSubviews() {
        super.layoutSubviews()
        littleGradientLayer.frame = bounds
    }
}

// MARK: - Расширения для цветов

extension UIColor {
    /// Инициализатор цвета из HEX-строки с улучшенной обработкой
    convenience init(littleHex hexString: String) {
        let sanitizedHex = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        let redComponent = CGFloat((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = CGFloat((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = CGFloat(colorValue & 0x0000FF) / 255.0
        
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}

// MARK: - Представление веб-вида

struct LittleWebViewBox: UIViewRepresentable {
    // MARK: - Свойства
    
    @ObservedObject var littleLoader: LittleWebLoader
    
    // MARK: - Координатор
    
    func makeCoordinator() -> LittleWebCoordinator {
        LittleWebCoordinator { [weak littleLoader] status in
            DispatchQueue.main.async {
                littleLoader?.littleState = status
            }
        }
    }
    
    // MARK: - Создание представления
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = littleCreateWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        littleSetupWebViewAppearance(webView)
        littleSetupContainerView(with: webView)
        
        webView.navigationDelegate = context.coordinator
        littleLoader.littleAttachWebView { webView }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Here you can update the WKWebView as needed, e.g., reload content when the loader changes.
        // For now, this can be left empty or you can update it as per loader's state if needed.
    }
    
    // MARK: - Приватные методы настройки
    
    private func littleCreateWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        return configuration
    }
    
    private func littleSetupWebViewAppearance(_ webView: WKWebView) {
        webView.backgroundColor = .clear
        webView.isOpaque = false
    }
    
    private func littleSetupContainerView(with webView: WKWebView) {
        let containerView = LittleGradientContainerView()
        containerView.addSubview(webView)
        
        webView.frame = containerView.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func littleClearWebsiteData() {
        let dataTypes: Set<String> = [
            .littleDiskCache,
            .littleMemoryCache,
            .littleCookies,
            .littleLocalStorage
        ]
        
        WKWebsiteDataStore.default().removeData(
            ofTypes: dataTypes,
            modifiedSince: .distantPast
        ) {}
    }
}

// MARK: - Расширение для типов данных

extension String {
    static let littleDiskCache = WKWebsiteDataTypeDiskCache
    static let littleMemoryCache = WKWebsiteDataTypeMemoryCache
    static let littleCookies = WKWebsiteDataTypeCookies
    static let littleLocalStorage = WKWebsiteDataTypeLocalStorage
}

