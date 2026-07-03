//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Dan Holtzman on 7/2/26.
//

import SwiftUI

enum MoveChoice: CaseIterable {
    case rock, paper, scissors
}

let moveChoiceToEmoji: Dictionary<MoveChoice, String> = [
    .rock: "🪨",
    .paper: "📄",
    .scissors: "✂️"
]

let winningMoves: Dictionary<MoveChoice, MoveChoice> = [
    .rock: .paper,
    .paper: .scissors,
    .scissors: .rock
]

let MAX_NUM_QUESTIONS = 10

struct ContentView: View {
    @State private var opponentChoice = (MoveChoice.allCases.randomElement() ?? .rock)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionNum = 1
    @State private var showGameOver = false
    
    var winningAnswer: MoveChoice {
        winningMoves[opponentChoice] ?? .rock
    }
    
    func ask() {
        opponentChoice = MoveChoice.allCases.randomElement() ?? .rock
        shouldWin.toggle()
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
                
                Text(moveChoiceToEmoji[opponentChoice] ?? "none")
                    .font(.system(size: 200))
                
                
                Text(shouldWin ? "How do you win?" : "How do you lose?")
                    .font(.title)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                HStack {
                    ForEach(MoveChoice.allCases, id: \.self) { moveChoice in
                        Button() {
                            if moveChoice == opponentChoice {
                                // no-op - no score change
                            } else if (shouldWin && moveChoice == winningAnswer) || (!shouldWin && moveChoice != winningAnswer) {
                                score += 1
                            } else {
                                score -= 1
                            }
                            
                            if questionNum == MAX_NUM_QUESTIONS {
                                showGameOver = true
                            } else {
                                questionNum += 1
                                ask()
                            }
                        } label: {
                            Text(moveChoiceToEmoji[moveChoice] ?? "none")
                                .font(.system(size: 100))
                        }
                        .alert("Game Over", isPresented: $showGameOver) {
                            Button("Try again", action: reset)
                        } message: {
                            Text("Final score: \(score)")
                        }
                    }
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
