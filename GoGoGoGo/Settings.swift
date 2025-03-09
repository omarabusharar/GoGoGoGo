//
//  Settings.swift
//  GoGoGoGo
//
//  Created by Omar Abu Sharar on 2024-03-19.
//

import SwiftUI

struct Settings: View {
    let colors: [Color] = [
        Color.gray,
        Color.blue,
        Color.purple,
        Color.pink,
        Color.red,
        Color.orange,
        Color.yellow,
        Color.green
    ]
    var body: some View {
        Form {
            // have this trigger the language specific settings to change
            Section("About", content: {
                Text("Polyglot")
            })
            Section("Options") {
                Picker("Learning Language", selection: .constant("Japanese"), content: {
                    Text("Arabic")
                        .tag("Arabic")
                    Text("Japanese")
                        .tag("Japanese")
                })
                .pickerStyle(.inline)
                LabeledContent("Accent Color") {
                    HStack {
                        ForEach(colors, id: \.self, content: { color in
                            Button(action: {}, label: {
                                ZStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(color)
                                        .shadow(color: color, radius: color == Color.red ? 5 : 0)
                                }
                            })
                                .buttonStyle(.plain)
                                .buttonBorderShape(.circle)
                           
                        })
                    }
                }
                Text("App Icon")
            }
            Section("Reset", content: {
                Button("Reset All Data", systemImage: "arrow.counterclockwise", role: .destructive, action: {})
            })
        } .formStyle(GroupedFormStyle())
    }
}

#Preview {
    Settings()
}
