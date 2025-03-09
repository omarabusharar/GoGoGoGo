//
//  Verbconjugator.swift
//  JapaneseQuiz
//
//  Created by Omar Abu Sharar on 2024-03-07.
//

import SwiftUI

struct VerbConjugator: View {
    var body: some View {
       VStack {
           Text("howdy")
        .overlay(alignment: .bottomTrailing, content: {
            Text("present formal".uppercased())
                .foregroundStyle(.secondary)
                .font(.footnote)
                .padding(.all)
        })
        PromptScreen(prompt: "howdy", note: "Present tense", focused: false)
        .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
        ZStack {
            RoundedRectangle(cornerRadius: 15)
#if os(macOS)
    .foregroundStyle(.quaternary.opacity(0.5))
#else
    .foregroundStyle(Material.thin)
#endif
                .frame(height: 50)
            TextField("Enter in plain past", text: .constant(""))
                .padding(.horizontal)
        }
        .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
         }
    }
}

#Preview {
    VerbConjugator()
}
