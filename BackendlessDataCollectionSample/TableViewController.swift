
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
            let _ = people?.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    private func setupBackendlessCollection() {
        let queryBuilder = DataQueryBuilder()
        queryBuilder.setPageSize(pageSize: 100)
        queryBuilder.setSortBy(sortBy: ["name"])
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
            self.people?.add(newObject: person)
            self.tableView.reloadData()
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
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
