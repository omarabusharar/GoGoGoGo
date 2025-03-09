//
//  Data.swift
//  JapaneseQuiz
//
//  Created by Omar Abu Sharar on 2024-03-07.
//

import SwiftUI

enum DeviceType {
    case phone, pad, mac
}
var deviceType: DeviceType {
    #if os(macOS)
        return .mac
    #else
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return DeviceType.phone
        case .pad:
            return DeviceType.pad
        default:
            return DeviceType.mac
        }
    #endif
}


struct Kanji: Identifiable, Equatable {
    var kanji: String
    var hiragana: String
    var romanji: String
    var meaning: String
    var id: String {
        kanji
    }
    static func  == (lhs: Kanji, rhs: Kanji) -> Bool {
        return lhs.id.hash == rhs.id.hash
    }
  
}
let set: [Kanji] = [
    Kanji(kanji: "えい語", hiragana: "えいご", romanji: "eigo", meaning: "English"),
    Kanji(kanji: "か学", hiragana: "かがく", romanji: "kagaku", meaning: "Science"),
    Kanji(kanji: "高校生", hiragana: "こうこうせい", romanji: "koukousei", meaning: "High School Student"),
    Kanji(kanji: "男子", hiragana: "だんし", romanji: "danshi", meaning: "Boy"),
    Kanji(kanji: "女子", hiragana: "じょし", romanji: "jyoshi", meaning: "Girl"),
    Kanji(kanji: "大人", hiragana: "おとな", romanji: "otona", meaning: "Adult"),
    Kanji(kanji: "今日", hiragana: "きょう", romanji: "kyou", meaning: "Today"),
    Kanji(kanji: "今", hiragana: "いま", romanji: "ima", meaning: "Now"),
    Kanji(kanji: "今月", hiragana: "こんげつ", romanji: "kongetsu", meaning: "This Month"),
    Kanji(kanji: "聞く", hiragana: "きく", romanji: "kiku", meaning: "To Listen"),
    Kanji(kanji: "入る", hiragana: "はいる", romanji: "hairu", meaning: "To Enter"),
    Kanji(kanji: "出る", hiragana: "でる", romanji: "deru", meaning: "To Leave"),
    Kanji(kanji: "先生", hiragana: "せんせい", romanji: "sensei", meaning: "Teacher"),
    Kanji(kanji: "日本語", hiragana: "にほんご", romanji: "nihongo", meaning: "Japanese"),
    Kanji(kanji: "話して", hiragana: "はなして", romanji: "hanashite", meaning: "To Speak"),
    Kanji(kanji: "男の子", hiragana: "おとこのこが", romanji: "otokonokoga", meaning: "Boy"),
    Kanji(kanji: "学校", hiragana: "がっこうで", romanji: "kakkoude", meaning: "Cool"),
    Kanji(kanji: "本", hiragana: "ほん", romanji: "hon", meaning: "book"),
    Kanji(kanji: "水よう日", hiragana: "すいようび", romanji: "suiyoubini", meaning: "Wednesday"),
    Kanji(kanji: "大学", hiragana: "だいがく", romanji: "daigaku", meaning: "University"),
    Kanji(kanji: "見に行き", hiragana: "みにいきます", romanji: "miniikimasu", meaning: "Watch & Listen"),
    Kanji(kanji: "何月何日", hiragana: "なんがつなんにち", romanji: "nangatsu nannichi", meaning: "What month? What day?")
    ]
