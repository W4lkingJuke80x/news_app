//
//  NewsManager.swift
//  News
//
//  Created by Dauren Omarov on 19.11.2021.
//

import Foundation

struct NewsManager {
    let newsURL = "https://newsapi.org/v2/everything?apiKey=3b32ec69007e44d6bcde02d3042454b9"

    func fetchNews(query: String) {
        let urlString = "\(newsURL)&q=\(query)"
        
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                } else {
                }
                if let safeData = data {
                    if let news = self.parseJSON(safeData) {
                        // Data is passed here
                        NotificationCenter.default.post(name: .didReceiveData, object: self, userInfo: ["Model": news])
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ newsData: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        let news: NewsModel
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            
            var auth: [String] = []
            var title: [String] = []
            var srcName: [String] = []
            var desc: [String] = []
            var pubDate: [String] = []
            var content: [String] = []
            var srcURL: [String] = []
            var imgURL: [String] = []
            
            
            for n in 0...9 { // n is subject to change
                if let author = decodedData.articles[n].author {
                    auth.append(author)
                } else {
                    auth.append("No Author Provided")
                }
                
                //Formatting date published using substrings:
                let rawDateString = decodedData.articles[n].publishedAt
                let endOfString = rawDateString.firstIndex(of: "T")!
                let finalDateString = String(rawDateString[...endOfString].dropLast())
                
                pubDate.append(finalDateString)
                title.append(decodedData.articles[n].title)
                srcName.append(decodedData.articles[n].source.name)
                desc.append(decodedData.articles[n].description)
                content.append(decodedData.articles[n].content)
                srcURL.append(decodedData.articles[n].url)
                imgURL.append(decodedData.articles[n].urlToImage)
            }
            
            news = NewsModel(author: auth, title: title, sourceName: srcName, description: desc, datePublished: pubDate, content: content, sourceURL: srcURL, imageURL: imgURL)
            
            return news
        }
        catch {
            print(error)
            return nil
        }
    }

}
