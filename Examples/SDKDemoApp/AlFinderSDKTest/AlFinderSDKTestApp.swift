//
//  AlFinderSDKTestApp.swift
//  AlFinderSDKTest
//
//  Created by Mina Haleem on 16.12.25.
//

import SwiftUI
import AlFinderSDK

@main
struct AlFinderSDKTestApp: App {
    init() {
        AlFinderClient.configure(
            storeId: "864490362",
            provider: .salla,
            defaultLang: .en
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
