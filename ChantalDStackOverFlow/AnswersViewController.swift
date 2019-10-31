//
//  AnswersViewController.swift
//  ChantalDStackOverFlow
//
//  Created by Demissie, Chantal (Contractor) on 10/26/19.
//  Copyright © 2019 Demissie, Chantal (Contractor). All rights reserved.
//
//
import UIKit
import Foundation
import Alamofire


class AnswersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var questionId: Int? = nil
    var question: Question? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        if questionId == nil {
            return
        }
        
        print(questionId!)
        
        // custom filter !-*jbN-o8P3E5 includes question body and answers, plus answer body
        let questionsUrl = "http://api.stackexchange.com/2.2/questions/\(questionId!)?site=stackoverflow&filter=!-*jbN-o8P3E5"
        
        Alamofire.request(questionsUrl, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Success")
                    do {
                        let decoder = JSONDecoder()
                        let json = response.data!
                        print(String(data: json, encoding: String.Encoding.utf8)!)
                        let questionsResponse = try decoder.decode(QuestionsResponse.self, from: json)
                        // items is where the array of questions is in the json
                        self.question = questionsResponse.items.first
                        print(self.question!)
                    } catch {
                        print(error)
                        return
                    }
                    self.tableView.reloadData()
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
}

extension AnswersViewController: UITableViewDataSource {
    // Get number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRowsForQuestion = 2
        if let question = question, let answers = question.answers {
            return numRowsForQuestion + answers.count
        } else {
            return numRowsForQuestion
        }
    }
    
    // Fill in each row cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        if let question = question {
            if indexPath.row == 0 {
                cell.textLabel?.text = question.title.htmlDecoded
                let imageUrl = URL(string: question.owner.profile_image)
                URLSession.shared.dataTask(with: imageUrl!) { (data, urlResponse, error) in
                    DispatchQueue.main.async {
                        if let data = data {
                            cell.imageView?.image = UIImage(data: data)
                        }
                    }
                    }.resume()
            } else if indexPath.row == 1 {
                cell.textLabel?.text = question.body?.htmlDecoded
            } else if let answers = question.answers { // row > 1
                // first two rows are question title and body,
                // so need to subtract 2 from row index to get answer index
                let answer = answers[indexPath.row - 2]
                cell.textLabel?.text = answer.body?.htmlDecoded
                if answer.is_accepted {
                    cell.accessoryType = .checkmark
                }
                let imageUrl = URL(string: answer.owner.profile_image)
                URLSession.shared.dataTask(with: imageUrl!) { (data, urlResponse, error) in
                    DispatchQueue.main.async {
                        if let data = data {
                            cell.imageView?.image = UIImage(data: data)
                        }
                    }
                    }.resume()
            }
        }
        return cell
    }
    
    // UITableView.automaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
