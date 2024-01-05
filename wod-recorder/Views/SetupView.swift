//
//  SetupView.swift
//  wod-recorder
//
//  Created by Nicky Advokaat on 03/01/2024.
//

import SwiftUI

struct SetupView: View {
    @State private var username: String
    @State private var workout: String = ""
    
    @State private var favoriteColor = 0
    
    @FocusState private var focusedField: FocusedField?

    
    enum FocusedField {
        case username, workout
    }
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor( Color.accentColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        _username = State(initialValue: (UserDefaults.standard.object(forKey:"username") as? String ?? ""))
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField("Athlete name...", text: $username).onChange(of: username) {
                        UserDefaults.standard.set(username, forKey: "username")
                    }.focused($focusedField, equals: .username)
                } header: {
                    Text("Athlete name")
                } footer: {
                    Text("Athlete name is required")
                        .foregroundStyle(Color(.systemRed))
                }
                
                Section {
                    TextField("Workout title...", text: $workout)
                } header: {
                    Text("Workout")
                }
                
                Section {
                    Picker("Workout type", selection: $favoriteColor) {
                        Text("AMRAP").tag(0)
                        Text("For Time").tag(1)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Workout type")
                }
                
                Section {
                    LabeledContent(
                        "Minutes",
                        value: 5.0,
                        format: .number.precision(.fractionLength(0))
                    )
                    LabeledContent(
                        "Seconds",
                        value: 0.0,
                        format: .number.precision(.fractionLength(0))
                    )
                } header: {
                    Text("Time")
                }
            }.onAppear {
                focusedField = .username
            }
            
            VStack {
                Button {
                    Router.shared.path.append("Recorder")
                } label: {
                    Text("Ready")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
        }.background(Color(.systemGroupedBackground))
            .onAppear {
                        focusedField = .username
                    }
    }
}

#Preview {
    SetupView()
}
