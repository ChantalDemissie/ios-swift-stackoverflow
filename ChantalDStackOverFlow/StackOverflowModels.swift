//
//  QuestionModels.swift
//  ChantalDStackOverFlow
//
//  Created by Demissie, Chantal (Contractor) on 10/26/19.
//  Copyright © 2019 Demissie, Chantal (Contractor). All rights reserved.
//
import UIKit
import Foundation

struct Question: Decodable {
    let title: String
    let question_id: Int
    let body: String?
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
    let owner: ShallowUser
}

struct ShallowUser: Decodable {
    let display_name: String?
    let profile_image: String?
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

func getProfileImage(profileImage: String, cell: UITableViewCell) {
    let imageUrl = URL(string: profileImage)
    URLSession.shared.dataTask(with: imageUrl!) { (data, urlResponse, error) in
        DispatchQueue.main.async {
            if let data = data {
                cell.imageView?.image = UIImage(data: data)
            }
        }
    }.resume()
}

func cacheProfileImage(profileImage: String, imageCache: inout [String: UIImage], dispatchGroup: DispatchGroup) {
    let imageUrl = URL(string: profileImage)
    URLSession.shared.dataTask(with: imageUrl!) { (data, urlResponse, error) in
        DispatchQueue.main.sync {
            if let data = data, let image = UIImage(data: data) {
                imageCache[profileImage] = resizeImage(image: image, newWidth: 80)
            }
            dispatchGroup.leave()
        }
    }.resume()
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}


//https://developer.apple.com/documentation/dispatch/dispatchqueue
//https://developer.apple.com/documentation/uikit/1623922-uigraphicsbeginimagecontext
