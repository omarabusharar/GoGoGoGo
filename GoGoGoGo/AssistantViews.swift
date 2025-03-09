//
//  AssistantViews.swift
//  JapaneseQuiz
//
//  Created by Omar Abu Sharar on 2024-03-07.
//

import SwiftUI
var topTrailing: ToolbarItemPlacement {
    #if os(macOS)
    return ToolbarItemPlacement.principal
    #else
        return .topBarTrailing
    #endif
}


struct AttemptIcon: View {
    @Binding var attempts: Int
    @Binding var isCorrect: Bool
    var id: Int
    var body: some View {
        Group {
            if attempts - 1 == id && isCorrect  {
                Image(systemName: "checkmark")
                    .foregroundStyle(.mint.gradient)
                    .shadow(color: .mint, radius: 15)
                    .transition(.blurReplace())
            } else if attempts > id {
                Image(systemName: "xmark")
                    .foregroundStyle(.red.gradient)
                    .shadow(color: .red, radius: 15)
                    .transition(.blurReplace())
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.tertiary)
                    .transition(.blurReplace())
            }
        }
            
    }
}

struct AttemptRow: View {
    @Binding var attempts: Int
    @Binding var isCorrect: Bool
    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<3) { int in
                AttemptIcon(attempts: $attempts, isCorrect: $isCorrect, id: int)
                Spacer()
            }
        
        }
        .foregroundStyle(.tertiary)
    }
}

struct VocabularyList: View {
    var list: [Kanji]
    @State var searchQuery: String = ""
    @Environment(\.dismiss) var dismiss
    var searchResult: [Kanji] {
        list.filter({searchQuery == "" || $0.hiragana.contains(searchQuery) || $0.kanji.contains(searchQuery) || $0.romanji.contains(searchQuery.lowercased()) || $0.meaning.lowercased().contains(searchQuery.lowercased())})
    }
    var body: some View {
            NavigationStack {
                List {
                   
                    ForEach(searchResult, id: \.kanji) { item in
                       
                     
                            Section {
                               DefinitionRow(item)
                                #if os(macOS)
                                Divider()
                                #endif
                            }
                            #if os(macOS)
                            .listRowSeparator(.hidden)
                            #endif
                         
                            .transition(.opacity.combined(with: .slide))
                            .animation(.snappy, value: searchQuery)
                        
                    }
                    
                }
               

            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Vocabulary List")
                
                .toolbar {
                   
                    ToolbarItemGroup(placement: .automatic, content: {
                        Picker(selection: .constant("Set"), label: Text(""), content: {
                            Section("Default Sets", content: {
                                Text("JLPT N5")
                                    .tag("Set")
                                Text("JLPT N4")
                                Text("JLPT N2")
                            })
                            Section("My Sets", content: {
                                Text("Nothing to display")
                                    .foregroundStyle(.secondary)
                                    .disabled(true)
                            })
                          
                            })
                        // have it filter and accpet all four character types
                        #if os(macOS) || targetEnvironment(macCatalyst)
                        TextField(text: $searchQuery, label: {
                            Label("Search Vocabulary...", systemImage: "magnifyingglass")
                               
                        })
                        .textFieldStyle(.roundedBorder)
                        .containerRelativeFrame(.horizontal, count: 5, spacing: 0)
                        #endif
                    })
                    #if os(iOS) && !targetEnvironment(macCatalyst)
                   
                    ToolbarItem(placement: .topBarLeading, content: {
                        TextField(text: $searchQuery, label: {
                            Label("Search Vocabulary...", systemImage: "magnifyingglass")
                               
                        })
        
                    })
                    #endif
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Close", systemImage: "xmark", action: {
                            dismiss()
                        })
                        #if targetEnvironment(macCatalyst) || os(macOS)
                        .labelStyle(.titleOnly)
                        .toolbarTitleDisplayMode(.inline)
                        #else
                        .buttonStyle(.borderless)
                        .buttonBorderShape(.circle)
                       
                        #endif
                    })
                }
              
            }
            .frame(minWidth: 600, idealWidth: 800, maxWidth: .infinity, minHeight: 500, idealHeight: 550, maxHeight: .infinity, alignment: .center)
    }
}

struct DefinitionRowSection: View {
    var value: String
    var label: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay(alignment: .bottomTrailing, content: {
                    Text(label.uppercased())
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    
                })
            Text(value)
                .font(.title)
                .lineLimit(4)
                .padding(.vertical, 15)
        }
    }
    init(_ label: String, _ value: String) {
        self.value = value
        self.label = label
    }
}

struct DefinitionRow: View {
    var kanji: Kanji
    var body: some View {
        HStack {
            DefinitionRowSection("Kanji", kanji.kanji)
            Divider()
            DefinitionRowSection("Hiragana", kanji.hiragana)
            Divider()
            DefinitionRowSection("Romanji", kanji.romanji)
            Divider()
            DefinitionRowSection("English", kanji.meaning)
        } .padding(.vertical, 5)
    }
    init(_ kanji: Kanji) {
        self.kanji = kanji
    }
}

struct PromptScreen: View {
    var prompt: String
    var note: String
    var focused: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
            #if targetEnvironment(macCatalyst) || os(macOS)
                .aspectRatio(3/1, contentMode: .fit)
            #else
                .aspectRatio(focused ? 3/1 : 4/3, contentMode: .fit)
            #endif
            #if os(macOS)
                .foregroundStyle(.quaternary.opacity(0.5))
            #else
                .foregroundStyle(Material.thin)
            #endif
            Text(.init(prompt))
            #if targetEnvironment(macCatalyst) || os(macOS)
                .font(.system(size: 100))
            #else
                .font(.system(size: 60))
            #endif
                .contentTransition(.opacity)
                .minimumScaleFactor(0.3)
        }
        .overlay(alignment: .bottomTrailing, content: {
            Text(note.uppercased())
                .foregroundStyle(.secondary)
                .contentTransition(.opacity)
                .font(.footnote)
                .padding(.all)
        })
        .animation(.snappy, value: focused)
        
    }
}


enum InfoType {
    case text, symbol
}

struct InfoCell: View {
    var header: String
    var type: InfoType = .text
    var content: String
    var body: some View {
        HStack {
            Text(header)
            Spacer()
            Group {
                switch type {
                case .text:
                    Text(content)
                case .symbol:
                    Image(systemName: content)
                }
            }
                .foregroundStyle(.secondary)
              
        }
        .padding(.all)

        .background(content: {
            RoundedRectangle(cornerRadius: 15)
#if os(macOS)
    .foregroundStyle(.quaternary.opacity(0.5))
#else
    .foregroundStyle(Material.thin)
#endif
        })
        .transition(.opacity)
        .animation(.snappy)
    }
}



struct HoverButtonStyle: ButtonStyle {
    @State private var hoverOn = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.secondary)
            .padding(.all, 5)
            .background(content: {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.secondary)
                    .opacity(hoverOn ? 0.2 : 0)
            })
            .onHover(perform: { hovering in
                if hovering {
                    hoverOn = true
                } else {
                    hoverOn = false
                }
            })
    }
}
