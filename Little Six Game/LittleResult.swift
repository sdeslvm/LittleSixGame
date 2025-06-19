import Foundation

// MARK: - Протоколы и расширения

/// Протокол для статусов с возможностью сравнения
protocol LittleWebStatusComparable {
    func isLittleEquivalent(to other: Self) -> Bool
}

// MARK: - Улучшенное перечисление статусов

/// Перечисление статусов веб-соединения с расширенной функциональностью
enum LittleWebStatus: Equatable, LittleWebStatusComparable {
    case littleStandby
    case littleProgressing(progress: Double)
    case littleFinished
    case littleFailure(reason: String)
    case littleNoConnection
    
    // MARK: - Пользовательские методы сравнения
    
    /// Проверка эквивалентности статусов с точным сравнением
    func isLittleEquivalent(to other: LittleWebStatus) -> Bool {
        switch (self, other) {
        case (.littleStandby, .littleStandby),
             (.littleFinished, .littleFinished),
             (.littleNoConnection, .littleNoConnection):
            return true
        case let (.littleProgressing(a), .littleProgressing(b)):
            return abs(a - b) < 0.0001
        case let (.littleFailure(reasonA), .littleFailure(reasonB)):
            return reasonA == reasonB
        default:
            return false
        }
    }
    
    // MARK: - Вычисляемые свойства
    
    /// Текущий прогресс подключения
    var littleProgress: Double? {
        guard case let .littleProgressing(value) = self else { return nil }
        return value
    }
    
    /// Индикатор успешного завершения
    var isLittleSuccessful: Bool {
        switch self {
        case .littleFinished: return true
        default: return false
        }
    }
    
    /// Индикатор наличия ошибки
    var hasLittleError: Bool {
        switch self {
        case .littleFailure, .littleNoConnection: return true
        default: return false
        }
    }
}

// MARK: - Расширения для улучшения функциональности

extension LittleWebStatus {
    /// Безопасное извлечение причины ошибки
    var littleErrorReason: String? {
        guard case let .littleFailure(reason) = self else { return nil }
        return reason
    }
}

// MARK: - Кастомная реализация Equatable

extension LittleWebStatus {
    static func == (lhs: LittleWebStatus, rhs: LittleWebStatus) -> Bool {
        lhs.isLittleEquivalent(to: rhs)
    }
}
