//
//  ContentView.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/10.
//

import SwiftUI
import AVFoundation

enum sheets: Identifiable{
  case hint, result
  
  var id: Int{
    hashValue
  }
}

struct ContentView: View {
  
  @State var progress = 1.0;
  @State var t: xTimer
  
  @State var questions: Array<Word> = []
  
  @State var offsets: Array<CGSize> = []
  @State var lastOffsets: Array<CGSize> = []
  @State var dropZones: Array<CGRect> = []
  @State var pipGeometries: Array<CGRect> =  []
  
  @State var placedWords: Array<String> = []
  
  @State var currentQuestionIndex: Int = 0
  @State var currentQuestion: Word!
  
  
  @State var viewIsReady: Bool = false
  @State var isComplete: Bool = false
  @State var isGameFinish: Bool = false
//  @State var showSheet: Bool = true
  @State var isFirstTimeSee: Bool = true
  
  @State var totalPlayed: Int = 0
  @State var completePlayed: Int = 0
  
  @State var cheat: Bool = false
//  @State var showHint: Bool = false
  
  @State var currentSheet: sheets? = .result
  
  let systemFont: Font = .system(size: 30, design: .monospaced)
  let customFont: Font = .custom("Galactic-Basic-Standard", size: 30)
  
  
  func dropHandler(_ index: Int){
    let pipObjectOffset = offsets[index]
    
    let geometry = pipGeometries[index]
    
    let pipGeometry = CGRect(
      x: geometry.minX + pipObjectOffset.width - geometry.width,
      y:  geometry.minY + pipObjectOffset.height - geometry.height,
      width: geometry.width,
      height: geometry.height
    )
    for dropZone in dropZones {
      if pipGeometry.intersects(dropZone) {
        print("INTERSECTS")
        offsets[index] = CGSize(
          width: dropZone.midX - geometry.midX,
          height: dropZone.midY - geometry.midY
        )
        
        let zoneIndex = Int(dropZones.firstIndex(of: dropZone)!)
        
        print("Dropped at zone \(zoneIndex) ( \(dropZone) in \(dropZones) )")
        
        placedWords[zoneIndex] = currentQuestion.answerPool[index]
        lastOffsets[index] = offsets[index]
        print(placedWords)
        isComplete = currentQuestion.concat(answer: placedWords)
        if(isComplete){
          currentSheet = .result
          viewIsReady = false
          self.completePlayed += 1
          t.stop()
        }
      }
      if(currentQuestionIndex == questions.count - 1){
        isGameFinish = true
      }
    }
    print("-----------")
  }
  
  var body: some View {
    ZStack{
      Image("stars")
        .resizable()
        .scaledToFill()
        .edgesIgnoringSafeArea(.all)
      VStack{
        TimerView(progress: $progress)
          .onAppear {
            self.playBGM()
            self.initView()
          }
          .padding(.top, 40)
        HStack{
          Button("Hint"){
            self.currentSheet = .hint
          }
          Spacer()
          Text("CHEAT")
          Toggle(isOn: $cheat){
          }
        }
        Spacer()
        if(viewIsReady){
          VStack{
            Spacer()
            
            HStack{
              ForEach(currentQuestion.wordArray.indices, id: \.self){ index in
                if(currentQuestion.indexIsRedacted(index)){
                  Color(red: 0.85, green: 0.85, blue: 0.85)
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(
                      GeometryReader(content: { geometry in
                        Color.clear
                          .onAppear {
                            dropZones[currentQuestion.getRedactIndex(index)] = geometry.frame(in: .global)
                          }
                      })
                    )
                }
                else{
                  ZStack{
                    Color
                      .gray
                      .frame(width: 50, height: 50, alignment: .center)
                    Text("\(currentQuestion.wordArray[index])")
                      .font((cheat) ? systemFont : customFont )
                  }
                }
              }
            }
            
            Spacer()
            
            HStack{
              ForEach(currentQuestion.answerPool.indices, id: \.self){ index in
                Text("\(currentQuestion.answerPool[index])")
                  .font((cheat) ? systemFont : customFont )
                  .background(Color.red)
                  .offset(offsets[index])
                  .overlay(
                    GeometryReader(content: { geometry in
                      Color.red
                        .opacity(0.2)
                        .onAppear {
                          pipGeometries[index] = geometry.frame(in: .global)
                        }
                    })
                  )
                  .gesture(
                    DragGesture()
                      .onChanged({ dragValue in
                        offsets[index].width = lastOffsets[index].width + dragValue.translation.width
                        offsets[index].height = lastOffsets[index].height + dragValue.translation.height
                      })
                      .onEnded({ _ in
                        lastOffsets[index] = offsets[index]
                        dropHandler(index)
                      })
                  )
              }
            }
            Spacer()
          }
        }
      }
    }.sheet(item: $currentSheet, content: { item in
      switch item{
        case .result:
          PassSheet(
            currentSheet: $currentSheet,
            isComplete: $isComplete,
            isGameFinish: $isGameFinish,
            isFirstTimeSee: $isFirstTimeSee,
            resetGame: self.resetGame,
            initGame: self.initView,
            totalPlayed: $totalPlayed,
            completePlayed: $completePlayed
          )
          .onAppear {
            self.isGameFinish = (self.currentQuestionIndex == self.questions.count - 1)
          }
        case .hint:
          HintSheet(
            cq: self.currentQuestion,
            currentSheet: $currentSheet
          )
      }
    })
  }
  
  
  func initView() {
    self.timerInit()
    self.questionInit()
  }
  
  func timerInit(){
    let time = 30.0
    let interval = 0.005
    self.progress = 1.0
    self.t = xTimer(
      time: time,
      interval: interval,
      callback: {
        self.progress -= interval / time
      },
      callbackOnTimerDone: {
        self.progress = 0.0
        self.currentSheet = .result
        t.stop()
        self.viewIsReady = false
        return 0
      }
    )
  }
  
  func playBGM(){
    let soundResource = Bundle.main.url(forResource: "bgm", withExtension: "m4a")
    do{
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      let player: AVAudioPlayer? = try AVAudioPlayer(contentsOf: soundResource!, fileTypeHint: AVFileType.m4a.rawValue)
      player?.numberOfLoops = -1
      player?.play()
    }
    catch{
      print(error)
    }
  }
  
  func questionInit(){
    let qs = JSONLoader.readLocalJson(fileName: "questions")
    
    for q in qs{
      questions.append(Word(wordRaw: q.word, imagePath: q.image, redactedIndices: q.holes))
    }
    for q in questions{
      print(q.imagePath)
    }
    self.questions.shuffle()
    self.getQuestion()
    self.totalPlayed = 0
    self.completePlayed = 0
  }
  
  func getQuestion(){
    
    let w = questions[currentQuestionIndex]
    let holes = w.makeQuestion(holes: w.redactedIndices)
    let qary = w.getQuestionArray()
    
    print(qary)
    print(holes.count)
    print(w.wordArray.count)
    
    let holeCounts = holes.count
    let answerCounts = w.answerPool.count
    
    self.currentQuestion = questions[self.currentQuestionIndex]
    self.offsets = [CGSize].init(repeating: .zero, count: answerCounts)
    self.lastOffsets = [CGSize].init(repeating: .zero, count: answerCounts)
    self.pipGeometries = [CGRect].init(repeating: .zero, count: answerCounts)
    self.dropZones = [CGRect].init(repeating: .zero, count: holeCounts)
    self.placedWords = [String].init(repeating: "_", count: holeCounts)
    self.totalPlayed += 1
  }
  
  func resetGame(progress: Bool = true){
    self.timerInit()
    if(progress){ self.currentQuestionIndex += 1 }
    self.getQuestion()
    t.start()
    self.viewIsReady = true
    print("GAME START")
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
