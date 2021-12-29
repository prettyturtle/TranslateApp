//
//  TranslateRequestModel.swift
//  Translate
//
//  Created by yc on 2021/12/29.
//

import Foundation

struct TranslateRequestModel: Codable {
    let source: String
    let target: String
    let text: String
}
