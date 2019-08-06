
import UIKit
import Backendless

class TableViewController: UITableViewController {
    
    private var people: BackendlessDataCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackendlessCollection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        if let person = people[indexPath.row] as? Person {
            cell.textLabel?.text = person.name ?? ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { let _ = people.remove(at: indexPath.row) }
    }
    
    private func setupBackendlessCollection() {
        people = BackendlessDataCollection(entityType: Person.self)
        people.requestStartedHandler = { print("Request started ...") }
        people.requestCompletedHandler = { print("... Request completed") }
        people.dataChangedHandler = { DispatchQueue.main.async { self.tableView.reloadData() } }
        people.errorHandler = { fault in print("Error: \(fault.message ?? "")") }
    }
    
    @IBAction func pressedAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add new Person", message: "Enter the new person's name:", preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "Name" }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let textField = alert?.textFields?[0] else { return }
            let person = Person()
            person.name = textField.text
            self.people.add(newObject: person)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
