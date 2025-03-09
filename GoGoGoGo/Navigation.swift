//
//  Navigation.swift
//  JapaneseQuiz
//
//  Created by Omar Abu Sharar on 2024-03-08.
//

import SwiftUI

struct Navigational: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentTab: Tab? = .read
    @State private var activitiesExpanded: Bool = true
    @State private var referencesExpanded: Bool = true
    @State private var showVocab: Bool = false
    
    // Character Table
    @State private var hiragana: Bool = true
    @State private var dakuten: Bool = false
    var body: some View {
  
        if deviceType == .phone {
            NavigationStack {
                Detail(currentTab: $currentTab, hiragana: $hiragana, dakuten: $dakuten)
                .toolbar {
                    ToolbarItem(placement: topTrailing, content: {
                        
                        HStack(spacing: 0) {
                            
                            Text("**GoGoGo** ")
                                .fontWidth(.expanded)
                            
                            Menu(content: {
                                Picker("Tab", selection: $currentTab, content: {
                                    Label("Kanji Reading", systemImage: "character.ja")
                                        .tag(Tab.read)
                                    Label("Verb Conjugation", systemImage: "pencil")
                                        .tag(Tab.conjugation)
                                }) .pickerStyle(.inline)
                                
                            }, label: {
                                HStack {
                                    
                                    Text("- \(currentTab == .read ? "Reading" : "Conjugation")")
                                        .foregroundStyle(.secondary)
                                        .contentTransition(.numericText(countsDown: currentTab == .read))
                                    Image(systemName: "chevron.down")
                                        .font(.footnote)
                                        .imageScale(.small)
                                        .foregroundStyle(.secondary)
                                    
                                }
                                .animation(.bouncy, value: currentTab)
                            }) .foregroundStyle(.primary)
                        }
                        
                        
                    })
                    
                }
            }
        } else {
            NavigationSplitView(sidebar: {
                List(selection: $currentTab) {
                    Text("**GoGoGoGo**")
                        .fontWidth(.expanded)
                        .font(.largeTitle)
                   
                    Section("Options", content: {
                        ZStack {
                            switch currentTab {
                            case .read:
                                VStack {
                                 
                                    #if targetEnvironment(macCatalyst) || os(macOS)
                                    LabeledContent("Prompt", content: {
                                        Text("Kanji")
                                            .foregroundStyle(.secondary)
                                    })
                                    #endif
                                    Picker("Prompt Selector", selection: .constant(true), content: {
                                        Text("Kanji (漢字)")
                                            .tag(true)
                                        Text("Hiragana (ひらがな)")
                                            .tag(false)
                                    })
                                 
                                    
                                    #if targetEnvironment(macCatalyst) || os(macOS)
                                    .labelsHidden()
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.vertical, 5)
                                    .labelsHidden()
                                    #else
                                    .hoverEffect(.highlight)
                                    .pickerStyle(.menu)
                                    .tint(.secondary)
                                    #endif
                                   
                                       
                                        #if targetEnvironment(macCatalyst) || os(macOS)
                                        LabeledContent("Chracter Set", content: {
                                            Button("Create New Set", systemImage: "plus", action: {
                                                print("hello")
                                            })
                                            .buttonStyle(HoverButtonStyle())
                                            Button("Manage Sets", systemImage: "ellipsis", action: {
                                                print("hello")
                                            })
                                            .buttonStyle(HoverButtonStyle())
                                        
                                        })
                                        .buttonStyle(.borderless)
                                        .tint(.secondary)
                                        .labelStyle(.iconOnly)
                                    Picker(selection: .constant("Set"), label: Text("Sets"), content: {
                                        Section("Default Sets", content: {
                                            Text("JLPT N5")
                                                .tag("Set")
                                            Text("JLPT N4")
                                            Text("JLPT N2")
                                        })
                                        Section("My Sets", content: {
                                            Text("Nothing to display")
                                        })
                                      
                                        })
                                    .labelsHidden()
                                   
                                
                                    .padding(.vertical, 5)
                 
                                       
                                       
                                        #else
                                        Picker("Set", selection: $currentTab, content: {
                                           Text("JLPT N5")
                                                .tag(Tab.read)
                                            Text("JLPT N2")
                                                .tag(Tab.conjugation)
                                        })
                                  
                                       
                                        .pickerStyle(.menu)
                                        .tint(.secondary)
                                        #endif
                                    
                                    Divider()
                                    .padding(.vertical, 5)
                             
                                    HStack {
                                      Menu(content: {
                                          Text("Streak")
                                      }, label: {
                                          Label("Statistics", systemImage: "chart.bar.xaxis")
                                      })
                                     
                                        Spacer()
                                        Button("Vocabulary", systemImage: "character.book.closed.ja", action: {
                                            showVocab.toggle()
                                        })
                                       
                                    }
                                    .buttonStyle(HoverButtonStyle())
                                    .padding(.all, 5)
                                    #if targetEnvironment(macCatalyst) || os(macOS)
                                    .labelStyle(.titleAndIcon)
                                    #else
                                    .labelStyle(.iconOnly)
                                    #endif
                                    .buttonStyle(.borderless)
                                        .foregroundStyle(.secondary)
                                }
                            case .conjugation:
                                Text("Test")
                            case .table:
                                VStack {
                                    #if targetEnvironment(macCatalyst) || os(macOS)
                                    LabeledContent("Set", content: {
                                        Text(hiragana ? "Hiragana (ひらがな)" : "Katakana (カタカナ)")
                                            .foregroundStyle(.secondary)
                                    })
                                    #endif
                                    Picker("Character Type", selection: $hiragana, content: {
                                        Text("Hiragana")
                                            .tag(true)
                                        Text("Katakana")
                                            .tag(false)
                                    })
                                 
                                    
                                    #if targetEnvironment(macCatalyst) || os(macOS)
                                    .labelsHidden()
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.vertical, 5)
                                    .labelsHidden()
                                    #else
                                    .hoverEffect(.highlight)
                                    .pickerStyle(.menu)
                                    .tint(.secondary)
                                    #endif
                                    Toggle("Dakuten / Handakuon", isOn: $dakuten)
                                        .tint(.accent)
                                    #if os(macOS) || targetEnvironment(macCatalyst)
                                        .toggleStyle(.checkbox)
                                    #else
                                        .toggleStyle(.button)
                                    #endif
                                }
                            default:
                                Text(": )")
                            }
                        }
                       
                        .padding(.all, 15)
                        .background {
                            RoundedRectangle(cornerRadius: deviceType == .pad ? 15 : 5)
                                .foregroundStyle(.windowBackground.opacity(colorScheme == .dark ? 0.3 :  0.6))
                                .ignoresSafeArea()
                        }
                        #if os(iOS)
                            .animation(.snappy, value: currentTab)
                        #endif
                    })
                    Section("Activities", isExpanded: $activitiesExpanded) {
                        ForEach(activities, content: { tab in
                            Label(tab.title, systemImage: tab.icon)
                        })
                    }
                    Section("References", isExpanded: $referencesExpanded) {
                        ForEach(references, content: { tab in
                            Label(tab.title, systemImage: tab.icon)
                        })
                    }
                }

            }, detail: {
                Detail(currentTab: $currentTab, hiragana: $hiragana, dakuten: $dakuten)
                    .frame(minWidth: 500, idealWidth: 700)
                    .toolbarTitleDisplayMode(.inline)
                #if os(iOS)
                    .navigationTitle(deviceType == .phone || activities.contains(where: {$0.tab == currentTab})  ? "" : (activities.first(where: {$0.tab == currentTab}) ?? references.first(where: {$0.tab == currentTab}))!.title)
                #else
                    .navigationTitle((activities.first(where: {$0.tab == currentTab}) ?? references.first(where: {$0.tab == currentTab}))!.title)
                    .navigationSubtitle(activities.contains(where: {$0.tab == currentTab}) ? "SET NAME" : "GoGoGoGo")
                
                #endif
            })
            .sheet(isPresented: $showVocab) {
                NavigationStack {
                    VocabularyList(list: set)
                }
            }
        }

       }
  
    
}

struct Detail: View {
    @Binding var currentTab: Tab?
    
    // Table Variables
    @Binding var hiragana: Bool
    @Binding var dakuten: Bool
    var body: some View {
        Group {
            switch currentTab {
            case .read:
                ContentView()
            case .conjugation:
                VerbConjugator()
            case .table:
               CharacterTable(hiragana: $hiragana, dakuten: $dakuten)
            case .settings:
                Settings()
            default:
                ContentView()
            }
        }
       
        
    }
}

enum Tab {
    // activities
    case read, conjugation
    // references
    case table, settings
}

let activities: [TabFull] = [
    TabFull("Kanji Reading", "character.ja", .read),
    TabFull("Verb Conjugation", "pencil", .conjugation)
]

let references:[TabFull] = [
    TabFull("Character Table", "tablecells", .table),
    TabFull("Settings", "gear",  .settings)
]

struct TabFull: Identifiable {
    var id: Tab {
        tab
    }
    var title: String
    var icon: String
    var tab: Tab
    init(_ title: String, _ icon: String, _ tab: Tab) {
        self.title = title
        self.icon = icon
        self.tab = tab
    }
}

#Preview {
    Navigational()
}


