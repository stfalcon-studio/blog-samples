//
//  ViewController.swift
//  MagicalRecord_project
//
//  Created by Victor Amelin on 11/21/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "Model")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        let fetchRequest = NSFetchRequest<Person>()
        fetchRequest.entity = Person.entity()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.persistentContainer.viewContext,
                                             sectionNameKeyPath: "name",
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //create data
        createPersonObject(name: "Name A", about: "some inform...", image: UIImage(named: "01")!)
        createPersonObject(name: "Name B", about: "some inform...", image: UIImage(named: "02")!)
        
        perform(#selector(insertAfterDelay), with: nil, afterDelay: 2.0)
        
        //fetch data in controller
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    //MARK: Actions
    func createPersonObject(name: String, about: String, image: UIImage) {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: persistentContainer.viewContext) as! Person
        person.name = name
        person.about = about
        person.avatar = UIImageJPEGRepresentation(image, 1.0) as NSData?
    }
    
    func insertAfterDelay() {
        createPersonObject(name: "Name C", about: "some inform...", image: UIImage(named: "03")!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        
        guard let sections = fetchedResultsController.sections else {
            fatalError("Sections missing")
        }
        
        let section = sections[indexPath.section]
        guard let itemsInSection = section.objects as? [Person] else {
            fatalError("Items missing")
        }
        
        let person = itemsInSection[indexPath.row]
        
        cell.aboutLbl.text = person.about
        cell.nameLbl.text = person.name
        cell.avatarImView.image = UIImage(data: person.avatar! as Data)
        
        return cell
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update: tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move: tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert: tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete: tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move, .update: tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        }
    }
}


































