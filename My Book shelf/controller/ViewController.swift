//
//  ViewController.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 12/08/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    let searchBookApi = SearchBookApiService()
    var result: [Items] = []
    var bookShelf: [Books] = []
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Books>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupFetchedResultsController()
        self.getSavedBook()
        updateViewLayout()
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
    
    @IBAction func toBookSelf(_ sender: Any) {
        performSegue(withIdentifier: "toBookShelfSegue", sender: self)
//        let bookShelfView = storyboard?.instantiateViewController(identifier: "bookShelfController") as! BookShelfViewController
//        bookShelfView.dataController = dataController
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookShelfView = segue.destination as! BookShelfViewController
        bookShelfView.dataController = dataController
    }
    
    // reference: https://stackoverflow.com/questions/42437966/how-to-adjust-height-of-uicollectionview-to-be-the-height-of-the-content-size-of
    fileprivate func updateViewLayout() {
        let height: CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func searchBook(_ sender: Any) {
        if let text = userInput.text {
            if text.count > 0 {
                searchBtnOutlet.isEnabled = false
                searchBtnOutlet.setTitle("Searching...", for: .normal)
                searchBtnOutlet.backgroundColor = .gray
                searchBookApi.searchBooks(userInput: text) { success, data, error in
                    if !success {
                        DispatchQueue.main.async {
                            self.generateAlert(title: "ERROR", message: error?.localizedDescription ?? "OOPS! something went wrong!", actionTitle: "OK")
                        }
                        return
                    }
                    
                    if let data = data {
                        if let items = data.items {
                            DispatchQueue.main.async {
                                self.result = items
                                self.collectionView.reloadData()
                                self.updateViewLayout()
                                self.searchBtnOutlet.isEnabled = true
                                self.searchBtnOutlet.backgroundColor = UIColor.init(named: "customGreen")
                                self.searchBtnOutlet.setTitle("Search", for: .normal)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.generateAlert(title: "ERROR", message: "No books found!", actionTitle: "OK")
                                self.searchBtnOutlet.isEnabled = true
                                self.searchBtnOutlet.backgroundColor = UIColor.init(named: "customGreen")
                                self.searchBtnOutlet.setTitle("Search", for: .normal)
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    @objc func addToFav(sender: UIButton) {
        print("tag: \(sender.tag)")
        sender.isEnabled = false
        sender.setImage(UIImage(systemName: "rays"), for: .normal)
        
        let bookFromResult = result[sender.tag]
        
        let bookToSave = Books(context: dataController.viewContext)
        bookToSave.googleID = bookFromResult.id
        bookToSave.bookDescription = bookFromResult.volumeInfo?.description
        bookToSave.publishedDate = bookFromResult.volumeInfo?.publishedDate
        bookToSave.title = bookFromResult.volumeInfo?.title
        bookToSave.authors = bookFromResult.volumeInfo?.authors?.joined(separator: ",")
        bookToSave.bookCategory = bookFromResult.volumeInfo?.categories?.joined(separator: ",")
        searchBookApi.downloadImg(url: (bookFromResult.volumeInfo?.imageLinks?.thumbnail)!) { data, error in
            if error == nil {
                if let data = data {
                    bookToSave.coverImageData = data
                }
                self.bookShelf.append(bookToSave)
                try? self.dataController.viewContext.save()
            }
        }
        
        
        
        collectionView.reloadData()
    }
    
    @objc func removeFav(sender: UIButton) {
        sender.isEnabled = false
        sender.setImage(UIImage(systemName: "rays"), for: .normal)
        let bookFromResult = result[sender.tag]
        
        let bookToDelete = bookShelf.filter { book in
            book.googleID == bookFromResult.id
        }.first
        
        if let deleted = bookToDelete {
            dataController.viewContext.delete(deleted)
            bookShelf = bookShelf.filter { item in
                item.googleID != bookFromResult.id
            }
            
            collectionView.reloadData()
        }
        
    }
    

}

