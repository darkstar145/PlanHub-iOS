
import Foundation

struct Message {
  
  let key: String
  let name: String
  let text: String
  let image: String
  let ref: DatabaseReference?
  
  init(name: String, text: String, key: String = "", image: String) {
    self.key = key
    self.name = name
    self.text = text
    self.image = image
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    name = snapshotValue["email"] as! String
    
    if (snapshotValue["text"]) != nil {
      text = snapshotValue["text"] as! String
    } else {
      text = ""
    }
    
    if (snapshotValue["Aimage"]) != nil {
      image = snapshotValue["Aimage"] as! String
    } else {
      image = ""
    }
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "text": text,
    ]
  }
  
}
