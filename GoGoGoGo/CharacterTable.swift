//
//  CharacterTable.swift
//  GoGoGoGo
//
//  Created by Omar Abu Sharar on 2024-03-18.
//

import Foundation
import SwiftUI

struct CharacterRow {
    var character: String = ""
    var row: [(String, String, String)] {
        var temp_row:[(String, String, String)] = []
        let vowels = ["a","e","i","o","u"]
        let specialCases: [String: String] = [
        "tu" : "tsu",
        "hu" : "fu",
        "si" : "shi",
        "ti" : "chi",
        "du" : "づ",
        "di" : "ぢ",
        "zi" : "じ"
        ]
        for vowel in vowels {
            var romanji: String = (character + vowel)
            for key in specialCases.keys {
                if romanji == key {
                    romanji = specialCases[key]!
                }
            }
            let hiragana = transliterate(romanji, true)
            let katakana = transliterate(romanji, false)
            temp_row.append((romanji, hiragana, katakana))
        }
        return temp_row
    }
   
    func transliterate(_ romanji: String, _ hiragana: Bool) -> String {
        let char: NSMutableString = NSMutableString(string: romanji)
        if CFStringTransform(char, nil, kCFStringTransformLatinHiragana, false) {
            if hiragana == false {
                CFStringTransform(char, nil, kCFStringTransformHiraganaKatakana, false)
            }
            let transformedString = char as String
            return transformedString as String
        } else {
            return "fail"
        }
     
    }
}

struct CharacterTable: View {
    @Binding var hiragana: Bool
    @Binding var dakuten: Bool
    let characters = ["","k","s","t","n","h","m","y","r","w"]
    let chars_daketun = ["","g","z","d","b","p"]
    var body: some View {
        List {
            ForEach(dakuten ? chars_daketun : characters, id: \.self) { char in
                Section(char == "" ? "Vowels": "\(char.uppercased())-Row"){
                    HStack {
                 
                        ForEach(CharacterRow(character: char).row, id: \.0) { jp_char in
                            HStack {
                                DefinitionRowSection(jp_char.0, hiragana ? jp_char.1 : jp_char.2)
                                if jp_char.0.last != "u" {
                                    Divider()
                                }
                            }
                        }
                       
                    }
          
                }
            }
          
        }
        .listStyle(.plain)
       
    }
}

#Preview {
    CharacterTable(hiragana: .constant(true), dakuten: .constant(false))
}
