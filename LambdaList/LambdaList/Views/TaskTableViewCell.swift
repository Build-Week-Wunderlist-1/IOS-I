import UIKit


class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier = "usableCell"

    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var completeButton: UIButton!
    
    // MARK: - Actions
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        guard let tempTask = task else {
            return
        }
        
        tempTask.completed.toggle()
        
        tempTask.completed == false ?
            completeButton.setImage(UIImage(systemName: "square"), for: .normal) : completeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
    }
    
    // MARK: - Methods
    private func updateViews() {
        //Unwrapping
        guard let task = task else {
            return
        }
        
        //Setting Outlet Properties
        titleLabel.text = task.taskName
        descriptionLabel.text = task.taskDescription
        updateButton(result: task.completed)
    }
    
    //Updates Complete Button to the correct Button Image and Color
    func updateButton(result: Bool) {
        if result == true {
            let image = UIImage(systemName: "checkmark.square.fill")
            completeButton.setImage(image, for: .normal)
            completeButton.tintColor = .green
        } else {
            let image = UIImage(systemName: "square")
            completeButton.setImage(image, for: .normal)
            completeButton.tintColor = .gray
        }
        
        do {
           try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error Saving CoreData")
        }
    }
    
    
    //TODO - AnimateButton When it's pressed
    func animateButton() {
        
    }
    
}
