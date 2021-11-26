//
//  ViewController.swift
//  News
//
//  Created by Dauren Omarov on 18.11.2021.
//

import UIKit
import SDWebImage

class NewsFeedScreen: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var newsFeed: UITableView!
    
    let urlString = "https://newsapi.org/v2/everything?apiKey=3b32ec69007e44d6bcde02d3042454b9&q="
    
    var newsManager = NewsManager()
    var news: NewsModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeed.delegate = self
        newsFeed.dataSource = self
        
        newsFeed.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        //Clearing cache form thumbnail images
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        if let input = searchTextField.text {
            newsManager.fetchNews(query: input)
        } else {
            print("Something is wrong with the input text of the searchTextField")
        }
    }
}
