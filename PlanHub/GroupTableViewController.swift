
import UIKit

class GroupTableViewController: UITableViewController {

  // MARK: Constants
  let listToMessages = "ListToMessages"
  let listToManage = "ListToManage"
  
  // MARK: Properties
//  let ref = FIRDatabase.database().reference(withPath: "grocery-items")
  let ref = Database.database().reference()
  var items: [Group] = []
  var user: aUser!
  var userCountBarButtonItem: UIBarButtonItem!
  var group: Group!
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
//    userCountBarButtonItem = UIBarButtonItem(title: "1",
//                                             style: .plain,
//                                             target: self,
//                                             action: #selector(userCountButtonDidTouch))
//    userCountBarButtonItem.tintColor = UIColor.white
//    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    ref.observe(.value, with: { snapshot in
      var newItems: [Group] = []
      
      for item in snapshot.children {
        let group = Group(snapshot: item as! DataSnapshot)
        let email = self.user.email
        if (group.admin.range(of: email) != nil || group.users.range(of: email) != nil) {
          newItems.append(group)
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
    let group = items[indexPath.row]
    
    cell.textLabel?.text = group.key
    cell.detailTextLabel?.text = group.admin
    
//    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let group = items[indexPath.row]
      group.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    group = items[indexPath.row]
    
    performSegue(withIdentifier: listToMessages, sender: group)

//    let toggledCompletion = !groceryItem.completed
    
//    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//    groceryItem.completed = toggledCompletion
    tableView.reloadData()
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
    }
  }
  
  // MARK: Add Group
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Add Group",
                                  message: "Please enter a group name and a list of users separated by spaces",
                                  preferredStyle: .alert)
    
    alert.addTextField{ (textField: UITextField) -> Void in
      textField.placeholder = "Group Name"
    }
    
    alert.addTextField{ (textField: UITextField) -> Void in
      textField.placeholder = "Users"
    }
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    guard let nameField = alert.textFields?.first,
                                      let name = nameField.text else { return }
                                    
                                    guard let usersField = alert.textFields?.last,
                                      let users = usersField.text else { return }
                                    
                                    let group = Group(admin: self.user.email,
                                                      users: users)
                                    let groupRef = self.ref.child(name)
                                    
                                    groupRef.setValue(group.toAnyObject())
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
