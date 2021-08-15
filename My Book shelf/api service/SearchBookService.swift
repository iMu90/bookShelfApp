//
//  SearchBookService.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import Foundation
import UIKit


class SearchBookApiService {
    
    let decoder = JSONDecoder()
    let constant = Constants()
    func searchBooks(userInput: String, completion: @escaping (Bool, Response?, Error?) ->()) {
        
        let googleUrl: String = "https://www.googleapis.com/books/v1/volumes?q=\(userInput)&key=\(constant.BOOK_API)&maxResults=\(constant.PER_PAGE_ITEMS)"
        
        var request = URLRequest(url: URL(string: googleUrl)!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                completion(false, nil, error)
                return
            }

            guard let data = data else {
                print("error here")
                completion(false, nil, nil)
                return
            }

            do {
                let responseObject = try self.decoder.decode(Response.self, from: data)
                completion(true, responseObject, nil)
                return

            } catch {
                completion(false, nil, error)
            }
        }
        
        task.resume()
        
    }
    
    func downloadImg(url: String, completion: @escaping (Data?, Error?) -> Void) {
        if let imgURL = URL(string: url) {
            let task = URLSession.shared.dataTask(with: imgURL) { data, response, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                if let data = data {
                    completion(data, nil)
                    return
                }
                
            }
            task.resume()
        }
        
    }
}
