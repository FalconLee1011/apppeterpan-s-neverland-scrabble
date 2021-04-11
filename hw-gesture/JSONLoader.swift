//
//  xJSONLoader.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/11.
//

import Foundation

struct Question: Codable {
  let word: String
  let holes: Array<Int>
  let image: String
}

class JSONLoader {
  
  static func readLocalJson(fileName: String) -> Array<Question>{
    
    let path = Bundle.main.path(forResource: fileName, ofType: "json")
    do{
      let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
      let decoder = JSONDecoder()
      let result = try decoder.decode([Question].self, from: data)
      return result
    }
//    do{
//      let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
//      let jsonR = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//      print(jsonR)
//      let parsed = jsonR as? Array<question> ?? []
//      print(parsed)
//      return parsed
//    }
    catch {
      print("Something went wrong")
      return []
    }

  }

}
