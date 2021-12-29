//
//  TranslateResponseModel.swift
//  Translate
//
//  Created by yc on 2021/12/29.
//

import Foundation

struct TranslateResponseModel: Decodable {
    
    private let message: Message
    
    var translatedText: String { message.result.translatedText }
    
    struct Message: Decodable {
        let result: Result
    }
    
    struct Result: Decodable {
        let translatedText: String
    }
}
