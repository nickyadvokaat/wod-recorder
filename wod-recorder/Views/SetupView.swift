import SwiftUI

struct SetupView: View {
    @State private var username: String
    @State private var workout: String = ""
    @State private var workoutType = 0
    @State private var minutes = "0"
    @State private var seconds = "0"
    
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
                    Picker("Workout type", selection: $workoutType) {
                        Text("AMRAP").tag(0)
                        Text("For Time").tag(1)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Workout type")
                }
                
                Section {
                    LabeledContent {
                        TextField("0", value: $minutes, formatter: NumberFormatter()).keyboardType(.numberPad).multilineTextAlignment(.trailing)
                    } label: {
                        Text("Minutes")
                    }
                    LabeledContent {
                        TextField("0", value: $seconds, formatter: NumberFormatter()).keyboardType(.numberPad).multilineTextAlignment(.trailing)
                    } label: {
                        Text("Seconds")
                    }
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
