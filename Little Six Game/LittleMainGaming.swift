import Foundation
import SwiftUI

class CyclopsColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((value & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(value & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

func launchOdyssey() -> some View {
    let url = URL(string: "https://littlesixgame.top/get")!
    return PoseidonScreen(vm: .init(link: url))
        .background(Color(CyclopsColor(rgb: "#373332")))
}

struct OdysseyEntry: View {
    var body: some View {
        launchOdyssey()
    }
}

#Preview {
    OdysseyEntry()
}
