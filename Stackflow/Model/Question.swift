//
//  Question.swift
//  Stackflow
//
//  Created by Tendai Maswaya on 9/18/21.
//

import Foundation

struct Questions : Codable {
    var items: [Question] 
    let has_more: Bool
}

struct Question : Codable {
    let content_license,
        link,
        title: String?
    let tags: [String]
    let answer_count,
        creation_date,
        last_activity_date,
        last_edit_date,
        question_id,
        score,
        view_count: Int?
    let is_answered: Bool
    let owner: Owner
}
