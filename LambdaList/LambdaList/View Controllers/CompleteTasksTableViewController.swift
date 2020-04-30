//
//  CompleteTasksTableViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit
import CoreData

class CompleteTasksTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Actions
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        allowUserToSort()
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    // MARK: - Properties
    let taskController = TaskController()
    var completeTasks: [Task] = []
    var sortedByKey: String = "sort"
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == %@", NSNumber(value: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        // swiftlint:disable force_try
        try! fetchedResultsController.performFetch()
        // swiftlint:enable force_try
        return fetchedResultsController
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        completeTasks = taskController.getIncompleteTasks()
    }
    
    
    // MARK: - Table view data source
    
    //Setting Amount of Rows/Cells for incompleteTasks
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections![section].numberOfObjects
    }
    
    //Setting the cells properties
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
        
        guard let myCell = cell as? TaskTableViewCell else {
            return cell
        }
        
        myCell.task = fetchedResultsController.object(at: indexPath)
        
        //myCell.task
        return myCell
     }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let tasks = fetchedResultsController.fetchedObjects else {
                 return
            }
            
            //TODO: Delete Task From Server
            
            let task = tasks[indexPath.row]
            CoreDataStack.shared.mainContext.delete(task)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("Error Saving Delete")
            }
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        var objects = fetchedResultsController.fetchedObjects!

        fetchedResultsController.delegate = nil

        let object = objects[sourceIndexPath.row]
        objects.remove(at: sourceIndexPath.row)
        objects.insert(object, at: destinationIndexPath.row)

        var i: Int64 = 1
        for object in objects {
            object.sort = i
            i += 1
        }

        try! CoreDataStack.shared.mainContext.save()

        fetchedResultsController.delegate = self
    }
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetailSegue" {
            
            //Get Tasks
            let tasks = fetchedResultsController.fetchedObjects
            
            //Unwrapping
            guard let destination = segue.destination as? TaskDetailViewController,
                let row = tableView.indexPathForSelectedRow?.row,
                let tempTasks = tasks else {
                return
            }
            
            destination.task = tempTasks[row]
            
            // TODO: ? - Get the new view controller using segue.destination.
            // TODO: ? - Pass the selected object to the new view controller.
        } else if segue.identifier == "AddTaskModalSegue" {
            // TODO: ? - Get the new view controller using segue.destination.
            // TODO: ? - Pass the selected object to the new view controller.
        }
    }
    
    
    // MARK: - Methods
    
    private func allowUserToSort() {
        // Create the alert
               let alert = UIAlertController(title: "Sort By:",
                                             message: "",
                                             preferredStyle: .alert)
               
               // Add actions
               alert.addAction(UIAlertAction(title: "Alphabetical", style: .default, handler: { _ in
                   self.sortedByKey = "taskName"
                   self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: self.sortedByKey, ascending: true)]
                   // swiftlint:disable force_try
                   try! self.fetchedResultsController.performFetch()
                   // swiftlint:enable force_try
                   self.tableView.reloadData()
               }))
               
               alert.addAction(UIAlertAction(title: "Most Recent", style: .default, handler: { _ in
                   self.sortedByKey = "createdDate"
                   self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: self.sortedByKey, ascending: false)]
                   // swiftlint:disable force_try
                   try! self.fetchedResultsController.performFetch()
                   // swiftlint:enable force_try
                   self.tableView.reloadData()
               }))
               
               alert.addAction(UIAlertAction(title: "Manual", style: .default, handler: { _ in
                   self.sortedByKey = "sort"
                   self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: false)]
                   // swiftlint:disable force_try
                   try! self.fetchedResultsController.performFetch()
                   // swiftlint:enable force_try
                   self.tableView.reloadData()
               }))
               
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
               // Present the alert
               self.present(alert, animated: true) { }
    }
    
    private func updateViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showEditing(sender:)))
    }
    
    @objc func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
}

extension CompleteTasksTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension CompleteTasksTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text,
            !searchTerm.isEmpty {
            
            let predicate = NSPredicate(format: "(taskName contains[cd] %@)", searchTerm)

            fetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            } catch let err {
                print(err)
            }

        }
        
        if searchBar.text == "" {
                let predicate = NSPredicate(format: "completed == %@", NSNumber(value: false))

                
                fetchedResultsController.fetchRequest.predicate = predicate
                
                do {
                    try fetchedResultsController.performFetch()
                    tableView.reloadData()
                } catch let err {
                    print(err)
                }
            }
    }
    
}
