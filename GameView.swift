import SwiftUI
import Combine

enum ColorOption: CaseIterable {
    case red, green, blue
}

enum GameLevel {
    case easy, medium, hard
}

class GameState: ObservableObject {
    @Published var buttons: [ButtonState] = []
    @Published var selectedButtons: [Int] = []
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var level: GameLevel = .easy
    @Published var highScores: [HighScore] = []
    private var timer: AnyCancellable?
    
    var playerName: String = ""  // Store the player's name
    
    func buttonTapped(index: Int) {
        guard !gameOver else { return }
        guard !selectedButtons.contains(index) else { return }
        
        selectedButtons.append(index)
        
        if selectedButtons.count == 2 {
            let firstIndex = selectedButtons[0]
            let secondIndex = selectedButtons[1]
            
            if buttons[firstIndex].color == buttons[secondIndex].color {
                score += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.buttons[firstIndex].color = ColorOption.allCases.randomElement()!
                    self.buttons[secondIndex].color = ColorOption.allCases.randomElement()!
                }
            } else {
                endGame()
            }
            selectedButtons.removeAll()
        }
    }
    
    func startGame(level: GameLevel, playerName: String) {
        gameOver = false
        score = 0
        elapsedTime = 0
        selectedButtons.removeAll()
        self.level = level
        self.playerName = playerName  // Set the player's name
        
        let buttonCount: Int
        switch level {
        case .easy:
            buttonCount = 4
        case .medium:
            buttonCount = 9
        case .hard:
            buttonCount = 16
        }
        
        buttons = Array(repeating: ButtonState(color: .red), count: buttonCount)
        buttons = buttons.map { _ in ButtonState(color: ColorOption.allCases.randomElement()!) }
        startTimer()
    }
    
    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.elapsedTime += 1
            }
    }
    
    private func endGame() {
        gameOver = true
        timer?.cancel()
        saveHighScore()
    }
    
    private func saveHighScore() {
        let highScore = HighScore(playerName: playerName, score: score, time: elapsedTime, level: level)
        highScores.append(highScore)
    }
}

struct ButtonState: Identifiable {
    let id = UUID()
    var color: ColorOption
}

struct HighScore: Identifiable {
    let id = UUID()
    let playerName: String
    let score: Int
    let time: TimeInterval
    let level: GameLevel
}

struct GameView: View {
    @ObservedObject var gameState: GameState
    var playerName: String
    var onBack: () -> Void
    
    @State private var isGameLevelChosen: Bool = false
    
    var body: some View {
        VStack {
            if !isGameLevelChosen {
                VStack {
                    Text("Select Game Level")
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: {
                        startGame(level: .easy)
                    }) {
                        Text("EASY LEVEL")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                    Button(action: {
                        startGame(level: .medium)
                    }) {
                        Text("MEDIUM LEVEL")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                    Button(action: {
                        startGame(level: .hard)
                    }) {
                        Text("HARD LEVEL")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                    Button(action: {
                        // Go back to the home page
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
            } else {
                if !gameState.gameOver {
                    Text("Score: \(gameState.score)")
                        .font(.title)
                        .padding()
                    
                    Text("Time: \(Int(gameState.elapsedTime)) seconds")
                        .font(.title2)
                        .padding()
                    
                    let columns = Array(repeating: GridItem(.flexible()), count: gridColumns())
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(gameState.buttons.indices, id: \.self) { index in
                            Button(action: {
                                gameState.buttonTapped(index: index)
                            }) {
                                Rectangle()
                                    .fill(color(for: gameState.buttons[index].color))
                                    .frame(height: 100)
                            }
                        }
                    }
                } else {
                    GameOverView(score: gameState.score, elapsedTime: gameState.elapsedTime) {
                        isGameLevelChosen = false
                    }
                }
            }
        }
        .padding()
    }
    
    private func startGame(level: GameLevel) {
        isGameLevelChosen = true
        gameState.startGame(level: level, playerName: playerName)
    }
    
    private func gridColumns() -> Int {
        switch gameState.level {
        case .easy:
            return 2
        case .medium:
            return 3
        case .hard:
            return 4
        }
    }
    
    private func color(for option: ColorOption) -> Color {
        switch option {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}

struct GameOverView: View {
    let score: Int
    let elapsedTime: TimeInterval
    let onRestart: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.red)
            
            Text("Final Score: \(score)")
                .font(.title)
                .padding()
            
            Text("Time Taken: \(Int(elapsedTime)) seconds")
                .font(.title2)
                .padding()
            
            Button(action: {
                onRestart()
            }) {
                Text("Restart")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title2)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()
        }
    }
}

#Preview {
    GameView(gameState: GameState(), playerName: "Player1") {
        print("Back to Home")
    }
}
