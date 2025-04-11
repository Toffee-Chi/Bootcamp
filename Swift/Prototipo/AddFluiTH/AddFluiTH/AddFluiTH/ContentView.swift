//
//  ContentView.swift
//  AddFluiTH
//
//  Created by Bootcamp on 4/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        LeaveListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LeaveRequest.self, inMemory: true)
}
