//
//  TableViewController.swift
//  My Book shelf
//
//  Created by Muteb Alolayan on 15/08/2021.
//

import Foundation
import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Books>!
    var bookShelf: [Books] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFetchedResultsController()
//        self.getSavedBook()
        tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableCell") as! TableCell
        
        let index = bookShelf[indexPath.row]
        
        if let data = index.coverImageData {
            cell.coverImage.image = UIImage(data: data)
        }
        cell.bookTitle.text = index.title
        cell.authors.text = index.authors
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookToDelete = bookShelf[indexPath.row]
            dataController.viewContext.delete(bookToDelete)
            bookShelf.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
