import SwiftUI

struct HighScoreView: View {
    @ObservedObject var gameState: GameState
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("High Scores")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(gameState.highScores) { highScore in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Player: \(highScore.playerName)")
                                .font(.headline)
                            Text("Score: \(highScore.score)")
                                .font(.subheadline)
                            Text("Time: \(Int(highScore.time)) seconds")
                                .font(.subheadline)
                            Text("Level: \(levelName(for: highScore.level))")
                                .font(.subheadline)
                        }
                    }
                }
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
    
    private func levelName(for level: GameLevel) -> String {
        switch level {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}

#Preview {
    HighScoreView(gameState: GameState()) {
        print("Back to Home")
    }
}
