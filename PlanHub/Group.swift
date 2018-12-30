
import Foundation

struct Group {
  
  let key: String
  let admin: String
  let users: String
  let ref: DatabaseReference?
  
  init(admin: String, users: String, key: String = "") {
    self.key = key
    self.admin = admin
    self.users = users
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    admin = snapshotValue["Admin"] as! String
    users = snapshotValue["Users"] as! String
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
      "Admin": admin,
      "Users": users,
    ]
  }
  
}

