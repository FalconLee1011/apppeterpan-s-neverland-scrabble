//
//  PassSheet.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/11.
//

import SwiftUI

struct PassSheet: View {
  @Binding var showSheet: Bool
  @Binding var isComplete: Bool
  @Binding var isGameFinish: Bool
  @Binding var isFirstTimeSee: Bool
  
  var resetGame: (Bool) -> Void
  var initGame: () -> Void
  
  var body: some View {
    if(isFirstTimeSee){
      Text("Press start to start.")
      Button("Start"){
        showSheet = false
        isFirstTimeSee = false
        self.resetGame(false)
      }
    }
    else if(isGameFinish){
      Text("Congratulations! Game Finished!")
      Button("Start Over"){
        showSheet = false
        isFirstTimeSee = false
        self.initGame()
        self.resetGame(true)
      }
    }
    else{
      Text("\( (isComplete) ? "Congratulations!" : "Failed" )")
      Button("Dismiss"){
        showSheet = false
        isComplete = false
        self.resetGame(true)
      }
    }
  }
}

