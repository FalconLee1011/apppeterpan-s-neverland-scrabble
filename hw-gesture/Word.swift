//
//  Word.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/11.
//

import Foundation

class Word: Codable {

  var wordRaw: String
  var wordArray: Array<String>
  var redactedIndices: Array<Int> = []
  var answerPool: Array<String> = []
  var imagePath: String? = ""
  
  init(wordRaw: String, imagePath: String? = nil, redactedIndices: Array<Int>? = []) {
    self.wordRaw = wordRaw
    self.wordArray = wordRaw.map{ String($0) }
    self.imagePath = imagePath
    self.redactedIndices = redactedIndices!
    self.redactedIndices.sort(by: { (a, b) -> Bool in
      return b > a
    })
  }
  
  func makeRandomQuestion(holes: Int?) -> Array<Int> {
    let _holes = holes ?? Int.random(in: 0...Int(self.wordRaw.count / 2))
    self.redactedIndices = _rndIndexGenerator(count: _holes, max: self.wordRaw.count)
    self.redactedIndices.sort(by: { (a, b) -> Bool in
      return b > a
    })
    self.answerPool = _answerPoolGenerator(count: Int(Double(self.redactedIndices.count) * 1.5))
    return Array(self.redactedIndices)
  }
  
  func makeQuestion(holes: Array<Int>) -> Array<Int> {
    self.redactedIndices = holes
    self.redactedIndices.sort(by: { (a, b) -> Bool in
      return b > a
    })
    self.answerPool = _answerPoolGenerator(count: Int(Double(self.redactedIndices.count) * 1.5))
    return Array(self.redactedIndices)
  }
  
  func getQuestionArray() -> Array<String> {
    var questionArray = Array<String>()
    for charIndex in 0..<self.wordRaw.count{
      if self.redactedIndices.contains(charIndex) {
        questionArray.append("")
      }
      else{
        let index = self.wordRaw.index(self.wordRaw.startIndex, offsetBy: charIndex)
        let char = self.wordRaw[index...index]
        questionArray.append(String(char))
      }
    }
    return questionArray
  }
  
  func indexIsRedacted(_ index: Int) -> Bool{
    return self.redactedIndices.contains(index)
  }
  
  func getRedactIndex(_ index: Int) -> Int{
    return Array(self.redactedIndices).firstIndex(of: index) ?? -1
  }
  
  func concat(answer: Array<String>) -> Bool {
    var concated = ""
    var cur = 0
    for charIndex in 0..<self.wordRaw.count{
      if self.redactedIndices.contains(charIndex) {
        concated += answer[cur]
        cur += 1
      }
      else{
        let index = self.wordRaw.index(self.wordRaw.startIndex, offsetBy: charIndex)
        concated += self.wordRaw[index...index]
      }
    }
    print("concated -> \(concated) ans -> \(self.wordRaw)")
    return (concated == self.wordRaw)
  }

  func _rndIndexGenerator(count: Int, max: Int) -> Array<Int> {
    return Array(Set((0..<count).map{ _ in Int.random(in: 0...max) }))
  }
  
  func _answerPoolGenerator(count: Int) -> Array<String>{
    var pool = Array<String>()
    for redactedIndex in self.redactedIndices {
      pool.append(self.wordArray[redactedIndex])
    }
    for _ in 0..<count {
      let baseChar = Int(("a" as UnicodeScalar).value)
      let char = Character(UnicodeScalar(baseChar + Int.random(in: 0..<26))!)
      pool.append(
        String(char)
      )
    }
    pool.shuffle()
    return pool
  }

}
