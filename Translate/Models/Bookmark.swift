//
//  Bookmark.swift
//  Translate
//
//  Created by yc on 2021/12/29.
//

import Foundation

struct Bookmark: Codable {
    let sourceLanguage: Language
    let translatedLanguage: Language
    
    let sourceText: String
    let translatedText: String
}


