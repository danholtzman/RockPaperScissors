//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Dan Holtzman on 7/2/26.
//

import SwiftUI

enum MoveChoice: CaseIterable {
    case rock, paper, scissors
    
    var emoji: String {
        switch self {
            case .rock: "🪨"
            case .paper: "📄"
            case .scissors: "✂️"
        }
    }

    var counterMove: MoveChoice {
        switch self {
            case .rock: .paper
            case .paper: .scissors
            case .scissors: .rock
        }
    }
}

let maxNumQuestions = 10

struct ContentView: View {
    @State private var opponentChoice = MoveChoice.allCases.randomElement()!
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionNum = 1
    @State private var showGameOver = false
    
    func ask() {
        opponentChoice = MoveChoice.allCases.randomElement() ?? .rock
        shouldWin.toggle()
    }
    
    func scoreAnswer(_ moveChoice: MoveChoice) -> Int {
        if moveChoice == opponentChoice {
            return 0
        } else if (shouldWin && moveChoice == opponentChoice.counterMove) || (!shouldWin && moveChoice != opponentChoice.counterMove) {
            return 1
        } else {
            return -1
        }
    }
    
    func reset() {
        score = 0
        questionNum = 1
        ask()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue], startPoint: .top, endPoint: .center).ignoresSafeArea()
            
            VStack {
                Text("Question \(questionNum)")
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                
                Text("Score: \(score)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(opponentChoice.emoji)
                    .font(.system(size: 200))
                
                
                Text(shouldWin ? "How do you win?" : "How do you lose?")
                    .font(.title)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                HStack {
                    ForEach(MoveChoice.allCases, id: \.self) { moveChoice in
                        Button {
                            score += scoreAnswer(moveChoice)
                            
                            if questionNum == maxNumQuestions {
                                showGameOver = true
                            } else {
                                questionNum += 1
                                ask()
                            }
                        } label: {
                            Text(moveChoice.emoji)
                                .font(.system(size: 100))
                        }
                        
                    }
                }
                .alert("Game Over", isPresented: $showGameOver) {
                    Button("Try again", action: reset)
                } message: {
                    Text("Final score: \(score)")
                }
                
                Spacer()
                
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
