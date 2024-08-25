import SwiftUI

struct GuideView: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("How to Play This Game?")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("1. Choose a game level: Easy, Medium, or Hard.")
                        .padding(.bottom)
                    Text("2. A grid of squares will appear, with each square assigned a color.")
                        .padding(.bottom)
                    Text("3. Tap on a square to reveal its color.")
                        .padding(.bottom)
                    Text("4. Try to match two squares with the same color.")
                        .padding(.bottom)
                    Text("5. If the colors match, you score a point.")
                        .padding(.bottom)
                    Text("6. If the colors don't match, the game is over.")
                        .padding(.bottom)
                    Text("7. Your final score and time will be displayed.")
                        .padding(.bottom)
                    Text("8. You can view your high scores or play again.")
                        .padding(.bottom)
                }
                .font(.title2)
                .padding()
            }
            
            Button(action: {
                onBack()
            }) {
                Text("Back")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    GuideView {
        print("Back to Home")
    }
}
