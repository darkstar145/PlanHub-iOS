
import UIKit

class ManageGroupViewController: UITableViewController {

  // MARK: Constants
  let listToGroups = "ListToGroups"
  
  // MARK: Properties
  let ref = Database.database().reference()
  var items: [aUser] = []
  var user: aUser!
  var userCountBarButtonItem: UIBarButtonItem!
  var group: Group!
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    ref.child(group.key + "/Users").observe(.value, with: { snapshot in
      var newItems: [aUser] = []
      
        let str = snapshot.value as? String
        let arr = str?.components(separatedBy: " ")
        if arr != nil {
          for usr in arr! {
            newItems.append(aUser(uid: usr, email: usr))
          }
        }
      
      self.items = newItems
      self.tableView.reloadData()
    })
    
    Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = aUser(authData: user)
    }
    tableView.separatorStyle = .none
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let user = items[indexPath.row]
    
    cell.textLabel?.text = user.email
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let ban = items[indexPath.row]
      items = items.filter() {
        $0.email != ban.email
      }
      var newUsers = String()
      for usr in items {
        newUsers.append(usr.email + " ")
      }
      newUsers = newUsers.trimmingCharacters(in: .whitespacesAndNewlines)
      ref.child(group.key + "/Users").setValue(newUsers)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard let cell = tableView.cellForRow(at: indexPath) else { return }
//    group = items[indexPath.row]
//
//    performSegue(withIdentifier: listToMessages, sender: group)

//    let toggledCompletion = !groceryItem.completed
    
//    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//    groceryItem.completed = toggledCompletion
    tableView.reloadData()
  }
  
//  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
//    if !isCompleted {
//      cell.accessoryType = .none
//      cell.textLabel?.textColor = UIColor.black
//      cell.detailTextLabel?.textColor = UIColor.black
//    } else {
//      cell.accessoryType = .checkmark
//      cell.textLabel?.textColor = UIColor.gray
//      cell.detailTextLabel?.textColor = UIColor.gray
//    }
//  }
  
  // MARK: Add Group
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Add User",
                                  message: "Please a list of users separated by spaces",
                                  preferredStyle: .alert)
    
    alert.addTextField{ (textField: UITextField) -> Void in
      textField.placeholder = "Users"
    }
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    
                                    guard let usersField = alert.textFields?.first,
                                      let users = usersField.text else { return }
                                    var newUsers = String()
                                    for usr in self.items {
                                      newUsers.append(usr.email + " ")
                                    }
                                    newUsers.append(" " + users)
                                    newUsers = newUsers.trimmingCharacters(in: .whitespacesAndNewlines)
                                    self.ref.child(self.group.key + "/Users").setValue(newUsers)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
//  func userCountButtonDidTouch() {
//    performSegue(withIdentifier: listToUsers, sender: nil)
//  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? MessagesViewController {
      destinationViewController.group = group
      destinationViewController.user = user
    }
  }
  
}
