//
//  CreateChangeViewController.swift
//  FruitLens
//
//  Created by admin on 13.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class CreateChangeViewController: UIViewController, UITextViewDelegate  {

    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changeJournalEntry : JournalEntry?

    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changeJournalEntry != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( noteTextTextView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if self.changeJournalEntry != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    
    func setJournalEntry(changeJournalEntry : JournalEntry) {
        self.changeJournalEntry = changeJournalEntry
    }
    
    private func addItem() -> Void {
        let note = JournalEntry(
            noteTitle: noteTitleTextField.text!,
            noteText: noteTextTextView.text,
            noteTimeStamp: noteCreationTimeStamp)

        JournalEntryStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {
        // get changed note instance
        if let changeJournalEntry = self.changeJournalEntry {
            // change the note through note storage
            JournalEntryStorage.storage.changeNote(
                noteToBeChanged: JournalEntry(
                    noteId: changeJournalEntry.noteId,
                    noteTitle: noteTitleTextField.text!,
                    noteText: noteTextTextView.text,
                    noteTimeStamp: noteCreationTimeStamp)
            )
            // navigate back to list of notes
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingReallySimpleNote = self.changeJournalEntry {
            // in change mode: initialize for fields with data coming from note to be changed
            noteDateLabel.text = DateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            noteTextTextView.text = changingReallySimpleNote.noteText
            noteTitleTextField.text = changingReallySimpleNote.noteTitle
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // in create mode: set initial time stamp label
            noteDateLabel.text = DateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
        }
        
        // initialize text view UI - border width, radius and color
        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextTextView.layer.borderWidth = 1.0
        noteTextTextView.layer.cornerRadius = 5

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changeJournalEntry != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( noteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }

}
