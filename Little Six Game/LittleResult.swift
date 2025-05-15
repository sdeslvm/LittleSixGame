import Foundation
import SwiftUI
import WebKit

enum KrakenState: Equatable {
    case idle
    case progress(percent: Double)
    case done
    case error(Error)
    case offline
    
    static func == (lhs: KrakenState, rhs: KrakenState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.done, .done), (.offline, .offline):
            return true
        case (.progress(let lp), .progress(let rp)):
            return lp == rp
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

