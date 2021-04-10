//
//  TimerView.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/10.
//

import SwiftUI

struct TimerView: View {
  @Binding var progress: Double
  var body: some View {
    ZStack {
      ProgressView(value: self._checkProgress(progress: progress)).scaleEffect(x: 1, y: 5, anchor: .center).accentColor(.green)
      Text("\(self._checkProgress(progress: progress))")
    }
  }
  
  func _checkProgress(progress: Double) -> Double{
    return (progress >= 0.0) ? progress : 0.0
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {

    TimerView(progress: .constant(0.0))
  }
}
