//
//  HintSheet.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/11.
//

import SwiftUI

struct HintSheet: View {
  @State var cq: Word
  @Binding var currentSheet: sheets?
  var body: some View {
    Text("Hint")
    Image(cq.imagePath)
      .resizable()
      .scaledToFit()
      .frame(height: 200, alignment: .center)
    
    Button("Close"){
      currentSheet = nil
    }
  }
}
