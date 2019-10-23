import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    let myArray = [1,2,3]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()

        cell.textLabel?.text = "\(myArray[indexPath.row])"

        return cell
    }
}


//https://developer.apple.com/documentation/uikit/uitableviewdatasource
