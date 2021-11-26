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
        return 10
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
    
    // NotificationCenter Observers' selector
    @objc func onDidReceiveData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: NewsModel] {
            news = nil
            let unsafeNews = data["Model"]
            if let safeNews = unsafeNews {
                // Assigning the news to a class variable for access in the table view
                self.news = safeNews
                DispatchQueue.main.async {
                    self.newsFeed.isHidden = false
            
                    //Updating cells
                    self.newsFeed.reloadData()
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: .didReceiveData, object: nil)
    }
}
