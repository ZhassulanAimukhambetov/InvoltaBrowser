//
//  ViewController.swift
//  InvoltaBrowser
//
//  Created by Zhassulan Aimukhambetov on 07.05.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    var webView: WKWebView!
    var searchBar: UISearchBar!
    var progressView: UIProgressView!
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    var history = [URL]()
    var urlHistory: URL?
    var isHistoryMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchText))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                           target: self,
                                                           action: #selector(showHistory))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let url = urlHistory {
            webView.load(URLRequest(url: url))
            searchBar.searchTextField.text = url.absoluteString
        }
        urlHistory = nil
    }
    
    @objc func searchText() {
        guard let searchText = searchBar.searchTextField.text else { return }
        webView.load(searchText.urlRequest())
        searchBar.endEditing(true)
    }
    
    @objc func showHistory() {
        guard let historyVC = storyboard?.instantiateViewController(identifier: "history") as? HistoryViewController else { return }
        historyVC.history = self.history
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
//MARK:-LoadUI
    private func loadUI() {
        //load webView
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        //load searchBar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.searchTextField.keyboardType = .webSearch
        //load progressView
        progressView = UIProgressView(progressViewStyle: .default)
        guard let navigationBar = navigationController?.navigationBar else { return }
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)
        progressView.isHidden = true
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }
}

//MARK:- WKNavigationDelegate
extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let searchText = searchBar.searchTextField.text else { return }
        webView.load(searchText.searchRequest())
    }
    
//MARK: ProgressBar animation
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
        UIView.animate(withDuration: 0.33, animations: {
            self.progressView.alpha = 1.0
        })
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33, animations: {
                           self.progressView.alpha = 0.0
                       }, completion: { isFinished in
                        self.progressView.isHidden = isFinished
        })
    }
//MARK: Save URL in history
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url, !isHistoryMode {
            history.append(url)
        }
        isHistoryMode = false
    }
}
//MARK:- UISearchBarDelegate
extension BrowserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.searchTextField.text else { return }
        webView.load(searchText.urlRequest())
        searchBar.endEditing(true)
    }
}


