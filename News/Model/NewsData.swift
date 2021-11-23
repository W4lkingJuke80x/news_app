//
//  NewsData.swift
//  News
//
//  Created by Dauren Omarov on 19.11.2021.
//

import Foundation

struct NewsData: Decodable {
    var articles: [News]
}

struct News: Decodable {
    var source: Source
    var author: String?
    var title: String
    var description: String
    var url: URL
    var urlToImage: URL
    var publishedAt: String
    var content: String
}

struct Source: Decodable {
    var name: String
}
