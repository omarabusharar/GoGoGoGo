import SwiftUI


struct ContentView: View {
    @Environment(\.horizontalSizeClass) var hSC
    
    // Lifetime Statistics
    @AppStorage("correct") var Correct: Int = 0
    @AppStorage("incorrect") var Incorrect: Int = 0
    @AppStorage("best_streak") var bestStreak: Int = 0
    
    // (Session Stats: Correct, Incorrect, Streak)
    @State var sessionStats: (Int, Int, Int) = (0,0,0)
    
    @State var attempts: Int = 0
    @State var kanji: Kanji = set.first!
    @State var input: String = ""
    @FocusState var isFocused: Bool
    @State var isCorrect = false
    @State var frontKanji = true
    @State var showList: Bool = false
    @State var kanjiSelection: [Kanji] = [set.randomElement()!, set.randomElement()!, set.randomElement()!,  set.randomElement()!]
    var layout: AnyLayout {
        AnyLayout(VStackLayout())
    }
    var body: some View {
        NavigationStack {
            layout {
                PromptScreen(prompt: frontKanji ? kanji.kanji : kanji.hiragana, note: frontKanji ? "kanji" : "hiragana", focused: isFocused)
                    .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                VStack {
                    if attempts == 3 && !isCorrect {
                        InfoCell(header: "Correct Answer", content: frontKanji ? kanji.hiragana : kanji.kanji)
                            .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                    } else if isCorrect {
                        InfoCell(header: "Correct", type: .symbol, content: "checkmark")
                            .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                    }
                    if attempts == 3 || isCorrect {
                        InfoCell(header: "Translation", content: kanji.meaning)
                            .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                    }
                    if attempts != 3 || deviceType == .mac {
                        if frontKanji {
                            HStack {
                                TextField("\(frontKanji ? "Hiragana or Romanji" : "Kanji") Here...", text: $input)
                                    .padding(.all)
                                  
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: 15)
#if os(macOS)
    .foregroundStyle(.quaternary.opacity(0.5))
#else
    .foregroundStyle(Material.thin)
#endif
                                    })
                                    .textFieldStyle(.plain)
                                    .focused($isFocused)
                                    .autocorrectionDisabled()
                                #if !os(macOS)
                                    .replaceDisabled()
                                #endif
                                    .onSubmit {
                                        if input != "" {
                                            withAnimation {
                                                if frontKanji {
                                                    if kanji.hiragana == input || kanji.romanji.lowercased() == input.lowercased() {
                                                        isCorrect = true
                                                        isFocused = false
                                                    }
                                                } else {
                                                    if kanji.kanji == input {
                                                        isCorrect = true
                                                        isFocused = false
                                                    }
                                                }
                                                if attempts < 2 {
                                                    attempts += 1
                                                } else {
                                                    attempts = 3
                                                }
                                                print(attempts)
                                            }
                                        }
                                    }
                                    .disabled(attempts == 3)
                                    .disabled(isCorrect)
                                if deviceType == .mac && input != "" {
                                    Group {
                                        if attempts != 3 && !isCorrect {
                                            Button(action: {
                                                withAnimation(.snappy(duration: 0.3)) {
                                                    if frontKanji {
                                                        if kanji.hiragana == input || kanji.romanji.lowercased() == input.lowercased() {
                                                            isCorrect = true
                                                        }
                                                    } else {
                                                        if kanji.kanji == input {
                                                            isCorrect = true
                                                        }
                                                    }
                                                    if attempts < 2 {
                                                        attempts += 1
                                                    } else {
                                                        attempts = 3
                                                    }
                                                    print(attempts)
                                                }
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .foregroundStyle(.red.opacity(0.2))
                                                    Text("Check")
                                                        .foregroundStyle(.red)
                                                        .font(.title3)
                                                      
                                                        .padding(.horizontal)
                                                } .fixedSize(horizontal: true, vertical: false)
                                               
                                            })
                                           
                                            .disabled(input == "")
                                            .disabled(attempts == 3)
                                            .keyboardShortcut(KeyboardShortcut.defaultAction)
                                            .tint(.accent)
                                            .animation(.easeInOut, value: input)
                                            
                                        } else {
                                            Button(action: {
                                                reset()
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .foregroundStyle(.mint.opacity(0.2))
                                                    Text("Continue")
                                                        .foregroundStyle(.mint)
                                                        .font(.title3)
                                        
                                                        .padding(.horizontal)
                                                } .fixedSize(horizontal: true, vertical: false)
                                               
                                            })
                                            .keyboardShortcut(KeyboardShortcut.defaultAction)
                                            .tint(.mint)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .buttonBorderShape(.roundedRectangle(radius: 15))
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 3)
                            .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                            .animation(.snappy, value: input)
             
                        } else {
                            VStack {
                                ForEach(kanjiSelection) { set in
                                    Button(action: {
                                        input = set.kanji
                                    }, label: {
                                        HStack {
                                            Spacer()
                                            Text(set.kanji)
                                            Spacer()
                                        } .padding(.vertical, 5)
                                    })
                                    .tint(input == set.kanji ? (isCorrect ? .mint : .red) : .secondary)
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.roundedRectangle(radius: 15))
                                    .frame(width: 300)
                                }
                            } .onAppear {
                                kanjiSelection =  [set.randomElement()!, set.randomElement()!, set.randomElement()!,  kanji].shuffled()
                                input = kanjiSelection.first!.kanji
                            }
                        }
                    }
                
                    if deviceType != .mac {
                    Group {
                        if attempts != 3 && !isCorrect {
                            Button(action: {
                                withAnimation(.snappy(duration: 0.3)) {
                                    if frontKanji {
                                        if kanji.hiragana == input || kanji.romanji.lowercased() == input.lowercased() {
                                            isCorrect = true
                                        }
                                    } else {
                                        if kanji.kanji == input {
                                            isCorrect = true
                                        }
                                    }
                                    if attempts < 2 {
                                        attempts += 1
                                    } else {
                                        attempts = 3
                                    }
                                    print(attempts)
                                }
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Check")
                                    Spacer()
                                } .padding(.vertical, 5)
                            })
                           
                            .disabled(input == "")
                            .disabled(attempts == 3)
                            .keyboardShortcut(KeyboardShortcut.defaultAction)
                            .tint(.accent)
                            .animation(.easeInOut, value: input)
                            
                        } else {
                            Button(action: {
                                reset()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Label("Next", systemImage: "arrow.forward")
                                    Spacer()
                                } .padding(.vertical, 5)
                            })
                            .keyboardShortcut(KeyboardShortcut.defaultAction)
                            .tint(.mint)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 15))
                    .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                }
            }
                AttemptRow(attempts: $attempts, isCorrect: $isCorrect)
                .frame(width: 300)
                .padding(.vertical)
                .padding(.all)
            }
            .sheet(isPresented: $showList, onDismiss: {
                showList = false
            }, content: {
       
                    VocabularyList(list: set)
             
            })
            #if os(iOS)
            .toolbar {
                if deviceType == .phone {
              
              
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                      
                      
                        Menu(content: {
                            Picker(selection: $frontKanji, content: {
                                Text("Kanji (漢字)")
                                    .tag(true)
                                Text("Hiragana (ひらがな)")
                                    .tag(false)
                            }, label: {
                                Label("Prompt", systemImage: "rectangle.portrait.topthird.inset.filled")
                                Text(frontKanji ? "Kanji" : "Hiragana")
                            }) .pickerStyle(.menu)
                                .onChange(of: frontKanji, {
                                    reset()
                                })
                            Section("Default Sets", content: {
                                Text("JLPT N5")
                                    .tag(true)
                                Text("JLPT N1")
                                    .tag(true)
                            })
                            Section("My Sets", content: {
                                Text("JLPT N5")
                                    .tag(true)
                                Text("JLPT N1")
                                    .tag(true)
                              
                            })
                            Button("Create New Set", systemImage: "plus", action: {})
                            Button("Manage Sets", systemImage: "pencil", action: {})
                        }, label: {
                            Label("Options", systemImage: "character.bubble.ja")
                        })
                        Menu(content: {
                            
                            
                            Menu(content: {
                                Button(action: {}, label: {
                                    Label("Correct", systemImage: "checkmark")
                                    Text(sessionStats.0.description)
                                })
                                Button(action: {}, label: {
                                    Label("Incorrect", systemImage: "xmark")
                                    Text(sessionStats.1.description)
                                })
                                Button(action: {}, label: {
                                    Label("Streak", systemImage: "flame")
                                    Text(sessionStats.2.description)
                                })
                                Section("Lifetime") {
                                    Button(action: {}, label: {
                                        Label("Correct", systemImage: "checkmark")
                                        Text(Correct.description)
                                    })
                                    Button(action: {}, label: {
                                        Label("Incorrect", systemImage: "xmark")
                                        Text(Incorrect.description)
                                    })
                                }
                                
                            }, label: {
                                Label("Stats", systemImage: "chart.bar.xaxis")
                                Text("\(sessionStats.2) - Streak")
                            })
                            Button("Vocabulary", systemImage: "character.book.closed.ja", action: {
                                showList = true
                            })
                        }, label: {
                            Label("Information", systemImage: "info.circle")
                        })
                    })
              }
            }
            #endif
        }
    }
    func randomKanji() -> [Kanji] {
        var randomSet: [Kanji] = []
        while randomSet.count < 4 {
            var randomKanji = set.randomElement()!
            if randomSet.contains(randomKanji)  {
                randomKanji = set.randomElement()!
            }
            if randomSet.contains(randomKanji) == false {
                randomSet.append(randomKanji)
            }
        }
        return randomSet
    }
    func reset() -> Void {
        withAnimation(.snappy) {
            if isCorrect {
                Correct += 1
                sessionStats.0 += 1
                sessionStats.2 += 1
            } else {
                Incorrect += 1
                sessionStats.1 += 1
                sessionStats.2 = 0
            }
            attempts = 0
            isCorrect = false
            var x = set.randomElement()!
            print(x.kanji)
            while x == kanji {
                x = set.randomElement()!
                print(x.kanji)
            }
            kanji = x
            input = ""
            isFocused = true
            
            // Reset Kanji
            if frontKanji == false {
                kanjiSelection =  randomKanji()
                kanji = kanjiSelection.randomElement()!
                 input = kanjiSelection.first!.kanji
            }
        }
    }
        
}
