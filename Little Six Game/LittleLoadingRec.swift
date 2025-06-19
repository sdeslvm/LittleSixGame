import SwiftUI
import Combine
import WebKit

// MARK: - Протоколы

/// Протокол для управления состоянием веб-загрузки
protocol LittleWebLoadable: AnyObject {
    var littleState: LittleWebStatus { get set }
    func littleSetConnectivity(_ available: Bool)
}

/// Протокол для мониторинга прогресса загрузки
protocol LittleProgressMonitoring {
    func littleObserveProgression()
    func littleMonitor(_ webView: WKWebView)
}

// MARK: - Основной загрузчик веб-представления

/// Класс для управления загрузкой и состоянием веб-представления
final class LittleWebLoader: NSObject, ObservableObject, LittleWebLoadable, LittleProgressMonitoring {
    // MARK: - Свойства
    
    @Published var littleState: LittleWebStatus = .littleStandby
    
    let littleResource: URL
    private var littleCancellables = Set<AnyCancellable>()
    private var littleProgressPublisher = PassthroughSubject<Double, Never>()
    private var littleWebViewProvider: (() -> WKWebView)?
    
    // MARK: - Инициализация
    
    init(littleResourceURL: URL) {
        self.littleResource = littleResourceURL
        super.init()
        littleObserveProgression()
    }
    
    // MARK: - Публичные методы
    
    /// Привязка веб-представления к загрузчику
    func littleAttachWebView(factory: @escaping () -> WKWebView) {
        littleWebViewProvider = factory
        littleTriggerLoad()
    }
    
    /// Установка доступности подключения
    func littleSetConnectivity(_ available: Bool) {
        switch (available, littleState) {
        case (true, .littleNoConnection):
            littleTriggerLoad()
        case (false, _):
            littleState = .littleNoConnection
        default:
            break
        }
    }
    
    // MARK: - Приватные методы загрузки
    
    /// Запуск загрузки веб-представления
    private func littleTriggerLoad() {
        guard let webView = littleWebViewProvider?() else { return }
        
        let request = URLRequest(url: littleResource, timeoutInterval: 12)
        littleState = .littleProgressing(progress: 0)
        
        webView.navigationDelegate = self
        webView.load(request)
        littleMonitor(webView)
    }
    
    // MARK: - Методы мониторинга
    
    /// Наблюдение за прогрессом загрузки
    func littleObserveProgression() {
        littleProgressPublisher
            .removeDuplicates()
            .sink { [weak self] progress in
                guard let self else { return }
                self.littleState = progress < 1.0 ? .littleProgressing(progress: progress) : .littleFinished
            }
            .store(in: &littleCancellables)
    }
    
    /// Мониторинг прогресса веб-представления
    func littleMonitor(_ webView: WKWebView) {
        webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] progress in
                self?.littleProgressPublisher.send(progress)
            }
            .store(in: &littleCancellables)
    }
}

// MARK: - Расширение для обработки навигации

extension LittleWebLoader: WKNavigationDelegate {
    /// Обработка ошибок при навигации
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        littleHandleNavigationError(error)
    }
    
    /// Обработка ошибок при provisional навигации
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        littleHandleNavigationError(error)
    }
    
    // MARK: - Приватные методы обработки ошибок
    
    /// Обобщенный метод обработки ошибок навигации
    private func littleHandleNavigationError(_ error: Error) {
        littleState = .littleFailure(reason: error.localizedDescription)
    }
}

// MARK: - Расширения для улучшения функциональности

extension LittleWebLoader {
    /// Создание загрузчика с безопасным URL
    convenience init?(littleUrlString: String) {
        guard let url = URL(string: littleUrlString) else { return nil }
        self.init(littleResourceURL: url)
    }
}
