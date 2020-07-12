//
//  JournalViewController.swift
//  FruitLens
//
//  Created by admin on 12.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class MasterJournalViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            let alert = UIAlertController(
                title: "Could not get app delegate",
                message: "Could not get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated:true)
            
            return
        
        }
            // create context
        let managedContext = appDelegate.persistentContainer.viewContext
            
            // set context in the storage
        JournalEntryStorage.storage.setManagedContext(managedObjectContext: managedContext)
            
            
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
                detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            }
    }

    override func viewWillAppear(_ animated: Bool) {
            clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
            super.viewWillAppear(animated)
    }

    @objc func insertNewObject(_ sender: Any) {
            performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
        
    //Segue to right cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = JournalEntryStorage.storage.readNote(at: indexPath.row)
                //Segue to DetailViewController
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }

    //Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return number of objects
        return JournalEntryStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteUITableViewCell
        //read object from storage 
        if let object = JournalEntryStorage.storage.readNote(at: indexPath.row) {
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
        //convert date to show seconds
        cell.noteDateLabel!.text = DateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Here we remove notes from storage if editing style is set to delete
        if editingStyle == .delete {
            JournalEntryStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           //insert note 
        }
    }

}
    



