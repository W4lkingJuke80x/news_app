//
//  NewsManager.swift
//  News
//
//  Created by Dauren Omarov on 19.11.2021.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ NewsManager: NewsManager, news: NewsModel)
    func didFailWithError(error: Error)
}

struct NewsManager {
    let newsURL = "https://newsapi.org/v2/everything?apiKey=3b32ec69007e44d6bcde02d3042454b9"
    
    var delegate: NewsManagerDelegate?
    
//MARK: - FetchWeather for cityName and coordinates
    func fetchNews(query: String) {
        let urlString = "\(newsURL)&q=\(query)"
        
        performRequest(with: urlString)
    }

//MARK: - PerformRequest Function
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                } else {
                }
                if let safeData = data {
                    if let news = self.parseJSON(safeData) {
                        // Data is passed here
                        self.delegate?.didUpdateNews(self, news: news)
                    }
                }
            }
            task.resume()
        }
    }

//MARK: - ParseJSON Function
    func parseJSON(_ newsData: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        let news: NewsModel
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            
            var auth: [String] = []
            var title: [String] = []
            var srcName: [String] = []
            var desc: [String] = []
            var published: [String] = []
            var content: [String] = []
            var srcURL: [String] = []
            
            for n in 0...2 {
                if let author = decodedData.articles[n].author {
                    auth.append(author)
                } else {
                    auth.append("No Author Provided")
                }
                title.append(decodedData.articles[n].title)
                srcName.append(decodedData.articles[n].source.name)
                desc.append(decodedData.articles[n].description)
                published.append(decodedData.articles[n].publishedAt)
                content.append(decodedData.articles[n].content)
                srcURL.append(decodedData.articles[n].url.absoluteString)
            }
            
            news = NewsModel(author: auth, title: title, sourceName: srcName, description: desc, datePublished: published, content: content, sourceURL: srcURL)
            
            return news
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}

//if let url = NSURL(string: self.restaurants[indexPath.row].restaurantImage) {
//         if let data = NSData(contentsOfURL: url) {
//             if let image = UIImage(data: data) {
//                 dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                     cell.restaurantImage.image = image
//                 }
//             }
//         }
//     }
