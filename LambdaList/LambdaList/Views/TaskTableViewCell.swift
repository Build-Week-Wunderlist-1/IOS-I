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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - Actions
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        guard let tempTask = task else {
            return
        }
        
        tempTask.completed = !tempTask.completed
    }
    
    
    // TODO: ? - add ibactions
    
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
    
    //Updates Complete Button to the correct button and color
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
    }
    
    
    //TODO - AnimateButton When it's pressed
    func animateButton() {
        
    }
    
}
