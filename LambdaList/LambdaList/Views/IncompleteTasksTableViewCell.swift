//
//  IncompleteTasksTableViewCell.swift
//  LambdaList
//
//  Created by Shawn James on 4/27/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import UIKit

class IncompleteTasksTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // this property will get it's value from dependancy injection via cellForRowAt
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    // TODO: ? - connect outlets
    
    // MARK: - Lifecycle
    
    // MARK: - Actions
    
    // TODO: ? - add ibactions
    
    // MARK: - Methods
    
    private func updateViews() {
//        guard let task = task else { return } // FIXME: - <-- uncomment this whole line when the TODO below is done
        // TODO: implement updateViews based on model
    }
    
}
