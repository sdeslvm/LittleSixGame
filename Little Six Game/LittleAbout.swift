import SwiftUI

struct LittleAboutView: View {
    @State private var animationAmount: Double = 1
    @State private var isTapped: Bool = false
    @State private var textFieldText: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Title
                    Text("A Little About")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 30)

                    Divider()

                    // Random thoughts section
                    Text("Random Thoughts:")
                        .font(.title2)

                    ForEach(0..<5) { index in
                        HStack {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 10, height: 10)
                            Text("This is line number \(index + 1), it means all.")
                                .font(.subheadline)
                        }
                    }

                    Divider()

                    // Input field
                    TextField("Type something here", text: $textFieldText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    // Action button
                    Button(action: {
                        self.isTapped.toggle()
                        self.animationAmount += 0.5
                    }) {
                        Text("Tap Me!")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isTapped ? Color.green : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .scaleEffect(animationAmount)
                            .animation(.spring(), value: animationAmount)
                    }

                    Divider()

                    // Colored blocks
                    HStack(spacing: 10) {
                        ForEach(0..<4) { idx in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hue: Double.random(in: 0...1), saturation: 0.7, brightness: 0.9))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("\(idx)")
                                        .foregroundColor(.black)
                                )
                        }
                    }

                    Divider()

                    // Show alert button
                    Button("Show Alert") {
                        showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Hello!"), message: Text("This is a test alert."), dismissButton: .default(Text("OK")))
                    }

                    // List of random numbers
                    List {
                        ForEach((0..<10), id: \.self) { _ in
                            Text("\(Int.random(in: 100...999)) - \(UUID().uuidString.prefix(5))")
                        }
                    }
                    .listStyle(.plain)

                    // Navigation link
                    NavigationLink(destination: Text("Next Screen")) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                            Text("Go Further")
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
