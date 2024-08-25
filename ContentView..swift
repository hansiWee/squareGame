import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    @State private var userName: String = ""
    @State private var isGameStarted: Bool = false
    @State private var showHighScores: Bool = false
    @State private var showGuide: Bool = false
    
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            
            VStack {
                if !isGameStarted && !showHighScores && !showGuide {
                    // Landing page
                    VStack {
                        Text("Welcome to the Square Game!")
                            .font(.largeTitle)
                            .padding()
                        
                        TextField("Enter your name", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .font(.title2)
                        
                        Button(action: {
                            if !userName.isEmpty {
                                isGameStarted = true
                            }
                        }) {
                            Text("START GAME")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.title2)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        
                        Button(action: {
                            showHighScores = true
                        }) {
                            Text("HIGH SCORES")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .font(.title2)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        
                        Button(action: {
                            showGuide = true
                        }) {
                            Text("GUIDE")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .font(.title2)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                } else if showHighScores {
                    HighScoreView(gameState: gameState, onBack: {
                        showHighScores = false
                    })
                } else if showGuide {
                    GuideView(onBack: {
                        showGuide = false
                    })
                } else {
                    GameView(gameState: gameState, playerName: userName) {
                        isGameStarted = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
