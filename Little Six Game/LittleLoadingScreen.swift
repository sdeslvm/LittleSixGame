import SwiftUI

struct PoseidonScreen: View {
    @StateObject var tritonState: MedusaVM
    
    init(vm: MedusaVM) {
        _tritonState = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            KronosWebStage(hydraModel: tritonState)
                .opacity(tritonState.krakenStatus == .done ? 1 : 0.3)
            if case .progress(let percent) = tritonState.krakenStatus {
                Color.clear.olympusProgressBar(percent)
            } else if case .error(let err) = tritonState.krakenStatus {
                Text("Erroring: \(err.localizedDescription)").foregroundColor(.pink)
            } else if case .offline = tritonState.krakenStatus {
                Text("")
            }
        }
    }
}
