//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yasmin araujo on 07/06/2024.
//

import SwiftUI

// project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
struct FlagImage: View {
    var image: String
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland","Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    // 1.Add an @State property to store the user’s score
    @State private var userScore = 0
    @State private var restartGame = false
    @State private var numberOfQuestions = 1
    //The challenge
    @State private var isCorrect = false
    @State private var selectedNumber = 0
    @State private var isFadeOutOpacity = false
    @State private var isDiferenttEffect = false
    
    var body: some View {
        ZStack {
           Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 40, opaque: true)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.semibold))
                    .padding(.bottom)
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.bold))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .textCase(.uppercase)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                            }
                           
                        } label: {
                            FlagImage(image: countries[number])
                            //CHALLENGE 1.When you tap a flag, make it spin around 360 degrees on the Y axis.
                                .rotation3DEffect(.degrees(isCorrect && selectedNumber == number ? 360 : 0),axis: (x: 0, y: 1, z: 0))
                            //CHALLENGE 2.Make the other two buttons fade out to 25% opacity.
                                .opacity(isFadeOutOpacity && selectedNumber != number ? 0.25 : 1)
                            //CHALLENGE 3.Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
                                .scaleEffect(isDiferenttEffect && selectedNumber != number ? 0.8 : 1)

                        }
                    }
                }
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .font(.title.bold())
                    .padding()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
           // 1.modify it when they get an answer right or wrong, then display it in the alert and in the score label
       Text("Your score is \(userScore)")
        }
        .alert("Game Over", isPresented: $restartGame) {
            Button("New Game", action: resetGame)
        } message: {
            Text("Your final is score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedNumber = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            isCorrect = true
            isFadeOutOpacity = true
            isDiferenttEffect = true
            
            
        } else {
            //2.When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
    
        }
        
        showingScore = true
        
        if numberOfQuestions == 8 {
            restartGame = true
            showingScore = false
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        numberOfQuestions += 1
        isCorrect = false
        isDiferenttEffect = false
        isFadeOutOpacity = false
        
    }
    // 3.Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game.
    func resetGame() {
        askQuestion()
        numberOfQuestions = 1
        userScore = 0
    }
}

#Preview {
    ContentView()
}
