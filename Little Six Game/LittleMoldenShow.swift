import Foundation
import SwiftUI
import WebKit

// MARK: - Протоколы

/// Протокол для состояний загрузки с расширенной функциональностью
protocol LittleWebLoadStateRepresentable {
    var littleType: LittleWebLoadState.LittleStateType { get }
    var littlePercent: Double? { get }
    var littleError: String? { get }
    
    func isLittleEqual(to other: Self) -> Bool
}

// MARK: - Улучшенная структура состояния загрузки

/// Структура для представления состояний веб-загрузки
struct LittleWebLoadState: Equatable, LittleWebLoadStateRepresentable {
    // MARK: - Перечисление типов состояний
    
    /// Типы состояний загрузки с порядковым номером
    enum LittleStateType: Int, CaseIterable {
        case littleIdle = 0
        case littleProgress
        case littleSuccess
        case littleError
        case littleOffline
        
        /// Человекочитаемое описание состояния
        var littleDescription: String {
            switch self {
            case .littleIdle: return "Ожидание"
            case .littleProgress: return "Загрузка"
            case .littleSuccess: return "Успешно"
            case .littleError: return "Ошибка"
            case .littleOffline: return "Нет подключения"
            }
        }
    }
    
    // MARK: - Свойства
    
    let littleType: LittleStateType
    let littlePercent: Double?
    let littleError: String?
    
    // MARK: - Статические конструкторы
    
    /// Создание состояния простоя
    static func littleIdle() -> LittleWebLoadState {
        LittleWebLoadState(littleType: .littleIdle, littlePercent: nil, littleError: nil)
    }
    
    /// Создание состояния прогресса
    static func littleProgress(_ percent: Double) -> LittleWebLoadState {
        LittleWebLoadState(littleType: .littleProgress, littlePercent: percent, littleError: nil)
    }
    
    /// Создание состояния успеха
    static func littleSuccess() -> LittleWebLoadState {
        LittleWebLoadState(littleType: .littleSuccess, littlePercent: nil, littleError: nil)
    }
    
    /// Создание состояния ошибки
    static func littleError(_ err: String) -> LittleWebLoadState {
        LittleWebLoadState(littleType: .littleError, littlePercent: nil, littleError: err)
    }
    
    /// Создание состояния отсутствия подключения
    static func littleOffline() -> LittleWebLoadState {
        LittleWebLoadState(littleType: .littleOffline, littlePercent: nil, littleError: nil)
    }
    
    // MARK: - Методы сравнения
    
    /// Пользовательская реализация сравнения
    func isLittleEqual(to other: LittleWebLoadState) -> Bool {
        guard littleType == other.littleType else { return false }
        
        switch littleType {
        case .littleProgress:
            return littlePercent == other.littlePercent
        case .littleError:
            return littleError == other.littleError
        default:
            return true
        }
    }
    
    // MARK: - Реализация Equatable
    
    static func == (lhs: LittleWebLoadState, rhs: LittleWebLoadState) -> Bool {
        lhs.isLittleEqual(to: rhs)
    }
}

// MARK: - Расширения для улучшения функциональности

extension LittleWebLoadState {
    /// Проверка текущего состояния
    var isLittleLoading: Bool {
        littleType == .littleProgress
    }
    
    /// Проверка успешного состояния
    var isLittleSuccessful: Bool {
        littleType == .littleSuccess
    }
    
    /// Проверка состояния ошибки
    var hasLittleError: Bool {
        littleType == .littleError
    }
}

// MARK: - Расширение для отладки

extension LittleWebLoadState: CustomStringConvertible {
    /// Строковое представление состояния
    var description: String {
        switch littleType {
        case .littleIdle: return "Состояние: Ожидание"
        case .littleProgress: return "Состояние: Загрузка (\(littlePercent?.formatted() ?? "0")%)"
        case .littleSuccess: return "Состояние: Успешно"
        case .littleError: return "Состояние: Ошибка (\(littleError ?? "Неизвестная ошибка"))"
        case .littleOffline: return "Состояние: Нет подключения"
        }
    }
}

