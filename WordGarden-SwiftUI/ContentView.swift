//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Sammy on 1/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var gameStatusMessage = "How Many Guesses to find the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = 8
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another Word?"
    @FocusState private var textFieldIsFocused: Bool
    
    private let wordsToGuess = ["UBIQUITOUS", "DOG","CAT"]
    private let maximumGuesses = 8
    
    var body: some View {
        VStack {
            HStack{
                VStack (alignment: .leading){
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center )
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            Spacer()
            //TODO: Switch to wordsToGuess[currentWord]
            Text(revealedWord)
                .font(.title)
            
            if playAgainHidden {
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth:2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) { _ in guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last
                            else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                    }
                    .onSubmit {
                        guard guessedLetter != "" else {
                            return
                        }
                        guessALetter()
                        updateGamePlay()
                    }
                        .focused($textFieldIsFocused)
                    Button("Guess a Letter") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button(playAgainButtonLabel) {
                    // If all words have been guessed...
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    // Reset after a word was guessed or missed
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    lettersGuessed = ""
                    guessesRemaining = maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear() {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
            guessesRemaining = maximumGuesses
        }
    }
    func guessALetter() {
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord = ""
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + "\(letter) "
            } else {
                revealedWord = revealedWord + "_ "
            }
        }
        revealedWord.removeLast()
        
    }
    
    func updateGamePlay() {
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            imageName = "flower\(guessesRemaining)"
        }
        
        //When do we play another word?
        if !revealedWord.contains("_") {
            gameStatusMessage = "You've Guessed It! It Took You \(lettersGuessed.count)"
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else if guessesRemaining == 0 {
            gameStatusMessage = "So Sorry. You're All Out of Guesses."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else {
            gameStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
        
        guessedLetter = ""
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
