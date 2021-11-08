
import UIKit
import Backendless

class TableViewController: UITableViewController {
    
    private var people: BackendlessDataCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().async {
            self.setupBackendlessCollection()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        if let person = people?[indexPath.row] as? Person {
            cell.textLabel?.text = "\(person.name ?? "NoName")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let person = people?[indexPath.row] {
                // sync data with Backendless
                Backendless.shared.data.of(Person.self).remove(entity: person, responseHandler: { removed in
                    let _ = self.people?.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }, errorHandler: { fault in
                    let errorAlert = UIAlertController(title: "Error", message: fault.message, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                })
            }
        }
    }
    
    private func setupBackendlessCollection() {
        let queryBuilder = DataQueryBuilder()
        queryBuilder.pageSize = 100
        queryBuilder.sortBy = ["name"]
        people = BackendlessDataCollection(entityType: Person.self, queryBuilder: queryBuilder)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func pressedAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add new Person", message: "Enter the new person's name:", preferredStyle: .alert)
        alert.addTextField {
            textField in textField.placeholder = "name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let nameField = alert?.textFields?[0] else {
                return
            }
            let person = Person()
            person.name = nameField.text
            
            // sync data with Backendless
            Backendless.shared.data.of(Person.self).save(entity: person, responseHandler: { savedPerson in
                self.people?.add(newObject: savedPerson)
                self.tableView.reloadData()
            }, errorHandler: { fault in
                let errorAlert = UIAlertController(title: "Error", message: fault.message, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let person = people?[indexPath.row] as? Person else {
            return
        }
        let alert = UIAlertController(title: "Update Person \n(current name: \(person.name ?? "NoName"))", message: "Enter new name:", preferredStyle: .alert)
        alert.addTextField {
            textField in textField.placeholder = "name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let nameField = alert?.textFields?[0] else { return }
            person.name = nameField.text
            
            // sync data with Backendless
            Backendless.shared.data.of(Person.self).save(entity: person, responseHandler: { savedPerson in
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }, errorHandler: { fault in
                let errorAlert = UIAlertController(title: "Error", message: fault.message, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
