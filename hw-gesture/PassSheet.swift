//
//  PassSheet.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/11.
//

import SwiftUI

struct PassSheet: View {
  @Binding var currentSheet: sheets?
  @Binding var isComplete: Bool
  @Binding var isGameFinish: Bool
  @Binding var isFirstTimeSee: Bool
  
  var resetGame: (Bool) -> Void
  var initGame: () -> Void
  
  @Binding var totalPlayed: Int
  @Binding var completePlayed: Int
  
  var body: some View {
    if(isFirstTimeSee){
      Text("Press start to start.")
      Button("Start"){
        currentSheet = nil
        isFirstTimeSee = false
        self.resetGame(false)
      }
    }
    else if(isGameFinish){
      if(completePlayed >= 10){
        Text("Your score \(completePlayed)/\(totalPlayed)")
        Text("Congratulations! Game Finished!")
        Image("whyleave")
        Button("Stay, and play again"){
          currentSheet = nil
          isGameFinish = false
          self.initGame()
          self.resetGame(true)
        }
      }
      else{
        Text("Your score \(completePlayed)/\(totalPlayed)")
        Image("yoda-blame")
        Text("Failed, you have, harder next time you will try.") // I know the sentence looks damn weird, but that's how Yoda talks.
        Button("Start Over"){
          currentSheet = nil
          isGameFinish = false
          self.initGame()
          self.resetGame(true)
        }
      }
    }
    else{
      Text("\( (isComplete) ? "Congratulations!" : "Failed" )")
      Button("Dismiss"){
        currentSheet = nil
        isComplete = false
        self.resetGame(true)
      }
    }
  }
}

