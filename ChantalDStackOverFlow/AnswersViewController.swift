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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        
        print(questionId!)
    }
}

extension AnswersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
