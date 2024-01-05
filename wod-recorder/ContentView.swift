//
//  ContentView.swift
//  wod-recorder
//
//  Created by Nicky Advokaat on 03/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                Button {
                    Router.shared.path.append("Setup")
                } label: {
                    Label("New Recording", systemImage: "video")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .navigationDestination(for: String.self) { route in
                    if(route == "Setup"){
                        SetupView()
                            .navigationTitle("New Recording") .navigationBarTitleDisplayMode(.large)
                    } else {
                        RecorderView().navigationBarHidden(true)
                    }
                }
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(Text("WOD Recorder"))
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
