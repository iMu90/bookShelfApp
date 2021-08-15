//
//  Response.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import Foundation

class Response: Codable {
    let totalItems: Int?
    let items: [Items]?
}


class Items: Codable {
    let id: String?
    let selfLink: String?
    let volumeInfo: BookInfo?
}

class BookInfo: Codable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let imageLinks: ImageLinks?
}

class ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
