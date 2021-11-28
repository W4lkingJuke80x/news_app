//
//  NewsFeedExtensions.swift
//  News
//
//  Created by Dauren Omarov on 26.11.2021.
//

import UIKit

extension NewsFeedScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Subject to change
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell

        cell.newsLabel.text = news?.title[indexPath.row]
        cell.dateLabel.text = news?.datePublished[indexPath.row]
        if let urlString = news?.imageURL[indexPath.row] {
            cell.thumbnailImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(systemName: "photo"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "DetailScreen") as? DetailScreen
        if let safeText = news?.content[indexPath.row],
           let safeURL = news?.imageURL[indexPath.row],
           let safeDate = news?.datePublished[indexPath.row],
           let safeSourceURL = news?.sourceURL[indexPath.row],
           let safeTitle = news?.title[indexPath.row] {
            detailScreen?.newsText = safeText
            detailScreen?.imageURL = safeURL
            detailScreen?.date = safeDate
            detailScreen?.source = safeSourceURL
            detailScreen?.newsTitle = safeTitle
        }
        
        
        self.navigationController?.pushViewController(detailScreen!, animated: true)
    }
    
    // NotificationCenter Observers' selector
    @objc func onDidReceiveData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: NewsModel] {
            news = nil
            let unsafeNews = data["Model"]
            if let safeNews = unsafeNews {
                // Assigning the news to a class variable for access in the table view
                self.news = safeNews
                DispatchQueue.main.async {
                   // self.newsFeed.isHidden = false
            
                    //Updating cells
                    self.newsFeed.reloadData()
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: .didReceiveData, object: nil)
    }
}

extension NewsFeedScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //Dismissing keyboard if Search button got pressed
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = searchTextField.text {
            newsManager.fetchNews(query: input)
        } else {
            print("Something is wrong with the input text of the searchTextField")
        }
        
        searchTextField.text = ""
    }
}
