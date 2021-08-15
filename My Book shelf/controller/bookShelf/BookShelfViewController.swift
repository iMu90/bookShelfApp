//
//  BookShelfViewController.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 14/08/2021.
//

import Foundation
import UIKit
import CoreData

class BookShelfViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Books>!
    var bookShelf: [Books] = []
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupFetchedResultsController()
        self.getSavedBook()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getSavedBook()
        collectionView.reloadData()
    }
    
    @objc func removeBook(sender: UIButton) {
        let bookToDelete = bookShelf[sender.tag]
        dataController.viewContext.delete(bookToDelete)
        bookShelf.remove(at: sender.tag)
        collectionView.reloadData()
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Books> = Books.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "googleID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "bookShelf")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func getSavedBook() {
        let fetchRequest:NSFetchRequest<Books> = fetchedResultsController.fetchRequest
        do {
            bookShelf = try dataController.viewContext.fetch(fetchRequest)
        } catch {
            print("cannot fetch saved books")
        }
    }
    
    @IBAction func toBookShelfTable(_ sender: Any) {
        performSegue(withIdentifier: "toBookShelfTableSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableView = segue.destination as! TableViewController
        tableView.dataController = dataController
        tableView.bookShelf = bookShelf
    }
    
    
}

extension BookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BookShelfCollectionCell
        let book = bookShelf[indexPath.row]
        if let data = book.coverImageData {
            cell.bookCover.image = UIImage(data: data)
        } else {
            cell.bookCover.image = UIImage(systemName: "photo")
        }
        cell.title.text = book.title
        cell.authors.text = book.authors
        cell.bookDesc.text = book.bookDescription
        cell.bookCategory.text = book.bookCategory
        cell.publishedDate.text = book.publishedDate
        cell.removeBookBtn.tag = indexPath.row
        cell.removeBookBtn.addTarget(self, action: #selector(self.removeBook), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return CGSize(width: view.frame.width, height: view.frame.width/2)
    }
    
}
