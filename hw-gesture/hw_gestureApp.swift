//
//  hw_gestureApp.swift
//  hw-gesture
//
//  Created by falcon on 2021/4/10.
//

import SwiftUI

@main
struct hw_gestureApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(t: xTimer(time: 10, interval: 1, callback: {
            print("")
          }))
        }
    }
}
