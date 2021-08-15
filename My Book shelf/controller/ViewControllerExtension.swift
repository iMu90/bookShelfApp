//
//  ViewControllerExtension.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCollectionCell", for: indexPath) as! CollectionViewCell
        cell.bookCoverImage.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal)
        cell.activityIndicator.startAnimating()
        let res = result[indexPath.row]
        
        let image = UIImage(systemName: "photo")
        
        if let url = res.volumeInfo?.imageLinks?.thumbnail {
            self.searchBookApi.downloadImg(url: url) {data, error in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        cell.bookTitle.text! = res.volumeInfo?.title ?? "empty"
                        let authors = self.getAuthorName(author: (res.volumeInfo?.authors) ?? [])
                        cell.authorNames.text! = authors
                        cell.bookDesc.text = res.volumeInfo?.description
                        cell.bookCategory.text = self.getAuthorName(author: (res.volumeInfo?.categories) ?? [])
                        cell.publishedDate.text = res.volumeInfo?.publishedDate
                        let exist = self.bookShelf.filter { bookShelf in
                            bookShelf.googleID == res.id
                        }.count > 0
                        
                    
                        cell.addToFavioriate.tag = indexPath.row
                        
                        if exist {
                            cell.addToFavioriate.tintColor = .systemRed
                            cell.addToFavioriate.addTarget(self, action: #selector(self.removeFav), for: .touchUpInside)
                        } else {
                            cell.addToFavioriate.addTarget(self, action: #selector(self.addToFav), for: .touchUpInside)
                        }
                        
                        if let data = data {
                            cell.bookCoverImage.image = UIImage(data: data)
                        } else {
                            cell.bookCoverImage.image = image
                        }
                        cell.activityIndicator.stopAnimating()
                    }
                   
                }
            }
        }
        return cell
    }
    
    fileprivate func getAuthorName(author: [String]) -> String {
        var result: String = ""
        result += author.joined(separator: ",")
        return result
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return CGSize(width: view.frame.width, height: view.frame.width/2)
    }
}
