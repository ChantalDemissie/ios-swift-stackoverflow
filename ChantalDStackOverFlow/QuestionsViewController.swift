import UIKit
import Foundation
import Alamofire

struct Question: Decodable {
    let title: String
    //let question_id: Int
    //let body: String
    //let is_answered: Bool
    let accepted_answer_id: Int?
    //let profile_image: string
    
}

struct QuestionsResponse: Decodable {
    let items: [Question]
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

class QuestionsViewController: UIViewController, UITableViewDataSource {
    var questions: [Question] = Array()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        let questionsUrl = "http://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow"
        
        Alamofire.request(questionsUrl, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Success")
                    do {
                        let decoder = JSONDecoder()
                        let json = response.data!
                        print(json)
                        let questionsResponse = try decoder.decode(QuestionsResponse.self, from: json)
                        // items is where the array of questions is in the json
                        self.questions = questionsResponse.items
                        print(self.questions)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = question.title.htmlDecoded
        if question.accepted_answer_id != nil {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

/**

JSON PROJECT NEEDS

Question title
JSON in items, as "title"


JSON "question_id": 58469748,
Type: Int

Question content
JSON "body": "<blockquote>\n  <p>What is the best synchronization scheme to make sure the threads get unlocked in the same order they get locked?</p>\n</blockquote>\n\n<p>The best synchronization scheme is not to use locks in the first place. Use Grand Central Dispatch instead. A serial queue does what locks do, coherently and simply and with vastly less chance of your making a mistake. </p>\n"
Type: String


Question list of answers
"body": "<p>ios13 doesn't allow PushKit for non VOIP scenarios. you will have to add a NSE as they advertise. It isnt just for images anymore.</p>\n"
Type: String

"answer_id": 58476063,
Type: Int


Question accepted answer
JSON "is_accepted": false,
Type Boolean


EXTRA CREDIT
 
Hit actual API (2)
 
Questions: https://api.stackexchange.com/2.2/questions?pagesize=50&order=desc&sort=activity&tagged=Objective-C&site=stackoverflow
Answers: https://api.stackexchange.com/2.2/questions/{question_id}/answers?site=stackoverflow&filter=withbody
 
Profile image into the row of each answer. (users responding to questions)
JSON "profile_image": "https://i.stack.imgur.com/duhm9.jpg?s=128&g=1",
TYPE string


Profile image into the row of each question. (users asking the question)
JSON "profile_image": "https://www.gravatar.com/avatar/fbb4d027695dfdf76bf448b15d7e306a?s=128&d=identicon&r=PG",
TYPE string



https://developer.apple.com/documentation/uikit/uitableviewdatasource
 
https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data

https://grokswift.com/json-swift-4/
 
// https://guides.codepath.com/ios/Table-View-Guide
 */
