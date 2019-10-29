//
//  QuestionModels.swift
//  ChantalDStackOverFlow
//
//  Created by Demissie, Chantal (Contractor) on 10/26/19.
//  Copyright © 2019 Demissie, Chantal (Contractor). All rights reserved.
//

import Foundation

struct Question: Decodable {
    let title: String
    let question_id: Int
    let body: String?
    // let is_answered: Bool?
    let accepted_answer_id: Int?
    let answers: [Answer]?
    let owner: ShallowUser
}

struct QuestionsResponse: Decodable {
    let items: [Question]
}

struct Answer: Decodable {
    let body: String?
    let is_accepted: Bool
    //let score: Int
    let owner: ShallowUser
}

// maybe print the amount of answers answers.count so user can see how many answeres there are.
// this would be a good way to differentiate between the different answers
// get image data from url first then convert data to UIImage and assign to imageview.
struct ShallowUser: Decodable {
    let display_name: String
    let profile_image: String
}

// source: https://stackoverflow.com/a/47480859
extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}



//https://stackoverflow.com/questions/56184147/how-to-display-json-image-on-custom-cell-of-tableview-in-swift/56184328
