//
//  ViewController.swift
//  News
//
//  Created by Dauren Omarov on 18.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let urlString = "https://newsapi.org/v2/everything?apiKey=3b32ec69007e44d6bcde02d3042454b9&q="
    
    var newsManager = NewsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsManager.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        if let input = searchTextField.text {
            newsManager.fetchNews(query: input)
        } else {
            print("Something is wrong with the input text of the searchTextField")
        }
    }
}

extension ViewController: NewsManagerDelegate {
    func didUpdateNews(_ NewsManager: NewsManager, news: NewsModel) {
        DispatchQueue.main.async {
            print(news.author)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewCell", for: indexPath)
        
        cell.textLabel?.text = "Cell number: \(indexPath)"
        return cell
    }
    
    
}
