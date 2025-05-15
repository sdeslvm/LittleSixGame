import SwiftUI

extension View {
    func olympusProgressBar(_ value: Double) -> some View {
        self.modifier(OlympusProgressModifier(progress: value))
    }
}

struct OlympusProgressModifier: ViewModifier {
    var progress: Double
    
    func body(content: Content) -> some View {
        ZStack {
            // Основной контент
            content
            
            // Полупрозрачный градиент для фокуса на индикаторе
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    .black.opacity(0.2),
//                    .black.opacity(0.6)
//                ]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 24) {
                        // Круговой прогресс-бар с анимацией
                        CircleProgressView(progress: progress)
                            .frame(width: 100, height: 100)
                        
                        // Текст с эффектом свечения
                        Text("Done: \(Int(progress * 100))%")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.2))
                                    .blur(radius: 4)
                            )
                            .shadow(color: .gray.opacity(0.7), radius: 8, x: 0, y: 0)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct CircleProgressView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            // Фоновое кольцо
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 12)
            
            // Прогресс-кольцо
            Circle()
                .trim(from: 0, to: CGFloat(min(max(progress, 0), 1)))
                .stroke(Color.blue, lineWidth: 12)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut(duration: 0.3), value: progress)
            
            // Центральный текст
//            Text("\(Int(progress * 100))%")
//                .font(.system(size: 20, weight: .bold))
//                .foregroundColor(.white)
        }
    }
}

#Preview {
    Text("Preview")
        .olympusProgressBar(0.2)
}

