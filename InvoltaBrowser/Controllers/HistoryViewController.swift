//
//  HistoryViewController.swift
//  InvoltaBrowser
//
//  Created by Zhassulan Aimukhambetov on 07.05.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var history: [URL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "History"
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webHistory", for: indexPath)
        let urlString = history[indexPath.row].absoluteString
        cell.textLabel?.text = urlString
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let browserVC = storyboard.instantiateViewController(identifier: "browserVC") as? BrowserViewController {
            browserVC.urlHistory = history[indexPath.row]
            browserVC.history = history
            browserVC.isHistoryMode = true
            navigationController?.show(browserVC, sender: nil)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
