//データベースの構成

import Foundation
import RealmSwift

class Profile: Object {
    
    @objc dynamic var myName: String = ""
    
}

class Friend: Object {
    
    @objc dynamic var friendName: String = ""
    
}

class Talk: Object {
    
    @objc dynamic var text: String = ""
    @objc dynamic var sender: String = ""
    @objc dynamic var friend: Friend?
    @objc dynamic var createdAt = Date().description(with:Locale(identifier: "ja_JP"))
    
}

class TalkList: Object {
    
    @objc dynamic var friend: Friend?
    
}

class Timeline: Object {
    
    @objc dynamic var text: String = ""
    @objc dynamic var user: Profile?
    @objc dynamic var createdAt = Date().description(with:Locale(identifier: "ja_JP"))
    
}
