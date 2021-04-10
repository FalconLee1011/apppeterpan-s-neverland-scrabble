//
//  ContentView.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/10.
//

import SwiftUI

struct ContentView: View {
  
  @State var progress = 1.0;
  @State var t: xTimer
  
  @State var data = ["A", "B", "C"]
  @State var offsets: Array<CGSize> = [CGSize.zero, CGSize.zero, CGSize.zero]
  @State var lastOffsets: Array<CGSize> = [CGSize.zero, CGSize.zero, CGSize.zero]
  
  @State var dropZones: Array<CGRect> = []
  
  @State var pipGeometries: [CGRect] =  []
  
  @State var currentIndex: Int = 0
  
  
  func dropHandler(_ pipGeometry: CGRect){
    for dropZone in dropZones {
      if dropZone.intersects(pipGeometry) {
        print("INTERSECTS")
      }
    }
    print("-----------")
  }
  
  var body: some View {
    //    VStack{
    //      TimerView(progress: $progress)
    //      Spacer()
    //      Button("BTN") {
    //        self.t.start()
    //      }
    //    }.onAppear(perform: timerInit)
    VStack{
      Color
        .orange
        .frame(width: 50, height: 50, alignment: .center)
        .overlay(
          GeometryReader(content: { geometry in
//            let _ = updateHandler(geomerty: geometry)
            Color.clear.onAppear {
              dropZones.append(geometry.frame(in: .global))
            }
          })
        )
        
      ForEach(data, id: \.self){ d in
        Text("\(d)")
          .offset(offsets[data.firstIndex(of: d)!])
          .overlay(
            GeometryReader(content: { geometry in
              Color.red
                .opacity(0.2)
                .onAppear {
                  pipGeometries.append(geometry.frame(in: .global))
                }
            })
          )
          .gesture(
            DragGesture()
              .onChanged({ dragValue in
                let currentIndex = data.firstIndex(of: d)!
                offsets[currentIndex].width = lastOffsets[currentIndex].width + dragValue.translation.width
                offsets[currentIndex].height = lastOffsets[currentIndex].height + dragValue.translation.height
              })
              .onEnded({ _ in
                let currentIndex = data.firstIndex(of: d)!
                lastOffsets[currentIndex] = offsets[currentIndex]
                dropHandler(pipGeometries[currentIndex])
                print(pipGeometries)
              })
          )
      }
    }
  }
  
  func timerInit(){
    self.t = xTimer(time: 10, interval: 0.01, callback: {
      self.progress -= 0.001
    })
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
