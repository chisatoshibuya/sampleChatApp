//トーク画面のコード
import Foundation
import UIKit
import RealmSwift

class talkScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var friend: Friend?
    var talk: Results<Talk>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //トークデータ取得
        let realm = try! Realm()
        //sorted( )を使って日付順で取得（新しいトークが上に来るよう）
        talk = realm.objects(Talk.self).filter("friend == %@", friend).sorted(byKeyPath: "createdAt", ascending: false)
        
        print(talk ?? "NO element")
        friendName.text = friend?.friendName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        
        //timelineに代入されたデータをobject:NSArrayに代入
        let data = talk[indexPath.row]
        
        //cellのtextLabelのtextにdataのプロパティを代入
        cell.textLabel?.text = data.text
        cell.detailTextLabel?.text = "送信者:\(data.sender)"
        
        return cell
    }
    
    //sendボタンが押された時
    @IBAction func sendPushed(_ sender: UIButton) {
        if let message = messageText?.text {
            //データベースにTalkを新規追加
            do{
                let realm = try! Realm()
                let t = Talk()
                t.text = message
                t.sender = "あなた"
                t.friend = friend

                try realm.write({ () -> Void in
                    realm.add(t)

                    print("Saved")
                    messageText?.text = ""
                    tableView.reloadData()
                })
            }catch{
                print("Save is Faild")
            }
        }
    }
    
}
