import UIKit
import Foundation
import Alamofire


class QuestionsViewController: UIViewController {
    var questions: [Question] = Array()
    var cachedProfileImages: [String: UIImage] = [:]
    var selectedQuestion: Question? = nil

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
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
                        let imageLoadingDispatchGroup = DispatchGroup()
                        for question in self.questions {
                            if let profile_image = question.owner.profile_image {
                                imageLoadingDispatchGroup.enter()
                                cacheProfileImage(profileImage: profile_image,
                                                  imageCache: &self.cachedProfileImages,
                                                  dispatchGroup: imageLoadingDispatchGroup)
                            }
                        }
                        imageLoadingDispatchGroup.notify(queue: .main) {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                        return
                    }
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let answersViewController = segue.destination as! AnswersViewController
        
        // set a variable in the second view controller
        if let selectedQuestion = selectedQuestion {
            answersViewController.questionId = selectedQuestion.question_id
        } else {
            //TODO: show error message to user
        }
        
    }

}

extension QuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = question.title.htmlDecoded
        // Used for auto-sizing cell height. Source: https://stackoverflow.com/a/48585451
        cell.textLabel?.numberOfLines = 0
        if question.accepted_answer_id != nil {
            cell.accessoryType = .checkmark
        }
        if let profileImage = question.owner.profile_image {
            cell.imageView?.image = cachedProfileImages[profileImage]
        }
        if indexPath.row % 2 == 0 {
            // peach
            cell.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
        } else {
            // pink petal
            cell.backgroundColor = UIColor(red: 230/255, green: 183/255, blue: 190/255, alpha: 1)
        }
        return cell
    }
    
    // UITableView.automaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QuestionsViewController: UITableViewDelegate {
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedQuestion = questions[indexPath.row]
        // Segue to the answers view controller
        self.performSegue(withIdentifier: "answers", sender: self)
    }
}
