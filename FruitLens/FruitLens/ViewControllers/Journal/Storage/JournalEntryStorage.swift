//
//  JournalEntryStorage.swift
//  FruitLens
//
//  Created by admin on 13.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import CoreData

class JournalEntryStorage {
    
    static let storage : JournalEntryStorage = JournalEntryStorage()
    
    private var noteIndexToIdDict : [Int:UUID] = [:]
    private var currentIndex : Int = 0

    private(set) var managedObjectContext : NSManagedObjectContext
    private var managedContextHasBeenSet : Bool = false
    
    private init() {
        // init ManagedObjectContext
        // This will be overwritten when setManagedContext is called from the view controller.
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = CoreDataHelper.readNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = CoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
    
    func addNote(noteToBeAdded: JournalEntry) {
        if managedContextHasBeenSet {
            // add note UUID to the dictionary
            noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
            CoreDataHelper.createNoteInCoreData(
                noteToBeCreated:          noteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
            // update index to enter UUID at right index
            currentIndex += 1
        }
    }
    
    func removeNote(at: Int) {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            CoreDataHelper.deleteNoteFromCoreData(
                noteIdToBeDeleted:        noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            // update noteIndexToIdDict dictionary
            if (at < currentIndex - 1) {
                for i in at ... currentIndex - 2 {
                    noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                }
            }
            // remove the last element
            noteIndexToIdDict.removeValue(forKey: currentIndex)
            // decrease current index
            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> JournalEntry? {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return nil
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            let noteReadFromCoreData: JournalEntry?
            noteReadFromCoreData = CoreDataHelper.readNoteFromCoreData(
                noteIdToBeRead:           noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    func changeNote(noteToBeChanged: JournalEntry) {
        if managedContextHasBeenSet {
            // check if UUID is in the dictionary
            var noteToBeChangedIndex : Int?
            noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                CoreDataHelper.changeNoteInCoreData(
                noteToBeChanged: noteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
                // TODO error handling
            }
        }
    }

    
    func count() -> Int {
        return CoreDataHelper.count
    }


}
