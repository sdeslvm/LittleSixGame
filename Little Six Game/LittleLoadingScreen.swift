import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol LittleProgressDisplayable {
    var littleProgressPercentage: Int { get }
}

protocol LittleBackgroundProviding {
    associatedtype LittleBackgroundContent: View
    func littleMakeBackground() -> LittleBackgroundContent
}

// MARK: - Расширенная структура загрузки

struct LittleLoadingOverlay<Background: View>: View, LittleProgressDisplayable {
    let littleProgress: Double
    let littleBackgroundView: Background
    
    var littleProgressPercentage: Int { Int(littleProgress * 100) }
    
    init(littleProgress: Double, @ViewBuilder background: () -> Background) {
        self.littleProgress = littleProgress
        self.littleBackgroundView = background()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                littleBackgroundView
                littleContent(in: geo)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func littleContent(in geometry: GeometryProxy) -> some View {
        let isLittleLandscape = geometry.size.width > geometry.size.height
        
        return Group {
            if isLittleLandscape {
                littleHorizontalLayout(in: geometry)
            } else {
                littleVerticalLayout(in: geometry)
            }
        }
    }
    
    private func littleVerticalLayout(in geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            Image("chck")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.7)
            
            littleProgressSection(width: geometry.size.width * 0.7)
            
            Image("title")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: geometry.size.width * 0.8)
                .padding(.top, 40)
            
            Spacer()
        }
    }
    
    private func littleHorizontalLayout(in geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            VStack {
                Image("chck")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.3)
                
                littleProgressSection(width: geometry.size.width * 0.3)
            }
            
            VStack {
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: geometry.size.width * 0.4)
            }
            
            Spacer()
        }
    }
    
    private func littleProgressSection(width: CGFloat) -> some View {
        VStack(spacing: 14) {
            Text("Loading \(littleProgressPercentage)%")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .shadow(radius: 1)
            
            LittleProgressBar(littleValue: littleProgress)
                .frame(width: width, height: 10)
        }
        .padding(14)
        .background(Color.black.opacity(0.22))
        .cornerRadius(14)
        .padding(.bottom, 20)
    }
}

// MARK: - Фоновые представления

extension LittleLoadingOverlay where Background == LittleBackground {
    init(littleProgress: Double) {
        self.init(littleProgress: littleProgress) { LittleBackground() }
    }
}

struct LittleBackground: View, LittleBackgroundProviding {
    func littleMakeBackground() -> some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    var body: some View {
        littleMakeBackground()
    }
}

// MARK: - Индикатор прогресса с анимацией

struct LittleProgressBar: View {
    let littleValue: Double
    
    var body: some View {
        GeometryReader { geometry in
            littleProgressContainer(in: geometry)
        }
    }
    
    private func littleProgressContainer(in geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            littleBackgroundTrack(height: geometry.size.height)
            littleProgressTrack(in: geometry)
        }
    }
    
    private func littleBackgroundTrack(height: CGFloat) -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.15))
            .frame(height: height)
    }
    
    private func littleProgressTrack(in geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color(littleHex: "#F3D614"))
            .frame(width: CGFloat(littleValue) * geometry.size.width, height: geometry.size.height)
            .animation(.linear(duration: 0.2), value: littleValue)
    }
}

// MARK: - Превью

#Preview("Vertical") {
    LittleLoadingOverlay(littleProgress: 0.2)
}

#Preview("Horizontal") {
    LittleLoadingOverlay(littleProgress: 0.2)
        .previewInterfaceOrientation(.landscapeRight)
}

