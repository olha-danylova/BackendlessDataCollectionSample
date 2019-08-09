
import UIKit
import Backendless

class TableViewController: UITableViewController {
    
    private var people: BackendlessDataCollection!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupBackendlessCollection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        if let person = people[indexPath.row] as? Person {
            cell.textLabel?.text = "\(person.name ?? "NoName"), age: \(person.age)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { let _ = people.remove(at: indexPath.row) }
    }
    
    private func setupBackendlessCollection() {
        people = BackendlessDataCollection(entityType: Person.self, whereClause: "age>20")
        people.requestStartedHandler = { self.activityIndicator.startAnimating() }
        people.requestCompletedHandler = { DispatchQueue.main.async { self.activityIndicator.stopAnimating() } }
        people.dataChangedHandler = { DispatchQueue.main.async { self.tableView.reloadData() } }
        people.errorHandler = { fault in print("Error: \(fault.message ?? "")") }
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        tableView.backgroundView = activityIndicator
    }
    
    @IBAction func pressedAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add new Person", message: "Enter the new person's name and age:", preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "name" }
        alert.addTextField { textField in textField.keyboardType = .numberPad; textField.placeholder = "age" }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let nameField = alert?.textFields?[0], let ageField = alert?.textFields?[1] else { return }
            let person = Person()
            person.name = nameField.text
            if !ageField.text!.isEmpty { person.age = Int(ageField.text!)!}
            self.people.add(newObject: person)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
