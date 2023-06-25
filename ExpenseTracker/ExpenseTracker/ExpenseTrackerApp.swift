//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Vinay Kumar Thapa on 2023-05-29.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
  @StateObject var transationListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transationListVM)
        }
    }
}
