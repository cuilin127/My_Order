//
//  Lin_MyORDERApp.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-09-22.
//  Student ID: 991456394

import SwiftUI

@main
struct Lin_MyORDERApp: App {
    
    let persistenceController = PersistenceController.shared
    let coreDBHelper = CoreDBHelper(context: PersistenceController.shared.container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            OrderView()
                .environmentObject(coreDBHelper)
        }
    }
}
