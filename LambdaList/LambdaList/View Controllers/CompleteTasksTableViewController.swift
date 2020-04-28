//
//  CompleteTasksTableViewController.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class CompleteTasksTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Actions
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    // MARK: - Properties
    let taskController = TaskController()
    var completeTasks: [Task] = []
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        completeTasks = taskController.getIncompleteTasks()
    }
    
    
    // MARK: - Table view data source
    
    //Setting the # of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Setting Amount of Rows/Cells for incompleteTasks
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completeTasks.count
    }
    
    //Setting the cells properties
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
        
        guard let myCell = cell as? TaskTableViewCell else {
            return cell
        }
        
        myCell.task = completeTasks[indexPath.row]
        
        //myCell.task
        return myCell
     }
    
    //    // Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetailSegue" {
            // TODO: ? - Get the new view controller using segue.destination.
            // TODO: ? - Pass the selected object to the new view controller.
        } else if segue.identifier == "AddTaskModalSegue" {
            // TODO: ? - Get the new view controller using segue.destination.
            // TODO: ? - Pass the selected object to the new view controller.
        }
    }
    
    
    // MARK: - Methods
    
    
}
