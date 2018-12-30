
import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  // MARK: Constants
  let messageCell = "MessageCell"
  let messagesToManage = "MessagesToManage"
  @IBOutlet weak var messagesTableView: UITableView!
  @IBOutlet weak var messageInputField: UITextField!
  
  // MARK: Properties
  var messages: [Message] = []
  var group: Group?
  var user: aUser?
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let ref = Database.database().reference(withPath: (group?.key)!)
    
    ref.observe(.value, with: { snapshot in
      self.messages = []
      for item in snapshot.children {
        let message = item as! DataSnapshot
        if (message.key != "Users" && message.key != "Admin") {
          self.messages.append(Message(snapshot: message))
        }
      }
      self.messagesTableView.reloadData()
    })
    messagesTableView.dataSource = self
    messagesTableView.delegate = self
    messageInputField.delegate = self
    messagesTableView.separatorStyle = .none
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    let now = Date()
    let calendar = Calendar.current
    let hour = String(calendar.component(.hour, from: now))
    let minutes = String(calendar.component(.minute, from: now))
    let day = String(calendar.component(.day, from: now))
    let month = String(calendar.component(.month, from: now))
    let year = String(calendar.component(.year, from: now))
    
    let text = messageInputField.text!
    let time = hour + ":" + minutes
    let date = day + "/" + month + "/" + year
    let email = user?.email
    
    let message = ["text": text, "time": time, "date": date, "email": email]
    let ref = Database.database().reference(withPath: (group?.key)!)
    ref.childByAutoId().setValue(message)
    
    return true;
  }
  
  // MARK: UITableView Delegate methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = messages[indexPath.row]
    var identifier = String()
    var decodedData = NSData()
    var decodedImage = UIImage()

    if (message.image != "") {
      identifier = "ImageCell"
      let encodedData: String = message.image
      decodedData = NSData(base64Encoded: encodedData, options:.ignoreUnknownCharacters)!
      decodedImage = UIImage(data: decodedData as Data)!
    } else {
      identifier = "MessageCell"
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

    if (message.image != "") {
      cell.imageView?.image = decodedImage
    }
    cell.textLabel?.text = message.name
    cell.detailTextLabel?.text = message.text
    return cell
  }
  
  // MARK: Actions
  
  @IBAction func settingsButtonPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: messagesToManage, sender: group)
  }
  
  @IBAction func sendButtonPressed(_ sender: Any) {
    self.view.endEditing(true)
    let now = Date()
    let calendar = Calendar.current
    let hour = String(calendar.component(.hour, from: now))
    let minutes = String(calendar.component(.minute, from: now))
    let day = String(calendar.component(.day, from: now))
    let month = String(calendar.component(.month, from: now))
    let year = String(calendar.component(.year, from: now))
    
    let text = messageInputField.text!
    let time = hour + ":" + minutes
    let date = day + "/" + month + "/" + year
    let email = user?.email
    
    let message = ["text": text, "time": time, "date": date, "email": email]
    let ref = Database.database().reference(withPath: (group?.key)!)
    ref.childByAutoId().setValue(message)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? ManageGroupViewController {
      destinationViewController.group = group
      destinationViewController.user = user
    }
  }
}
