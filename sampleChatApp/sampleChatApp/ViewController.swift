//友達画面のコード
import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends: Results<Friend>!
    
    //トーク画面に値を渡す時に使用
    var f: Friend?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //友達データ取得
        let realm = try! Realm()
        friends = realm.objects(Friend.self)
        tableView.reloadData()
        
        //realmに保存したmyNameを取得・表示
        let name = realm.objects(Profile.self)
        for n in name {
            userName.text = n.myName
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        //friendsに代入されたデータをobject:NSArrayに代入
        let data = friends[indexPath.row]
        
        //cellのtextLabelのtextにdataのfriendNameプロパティを代入
        cell.textLabel?.text = data.friendName
        
        return cell
    }
    
    //友達をスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.friends[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
        }
    }
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //トークリストにfriendを追加
        do{
            let talkList = TalkList()
            f = friends[indexPath.row]
            talkList.friend = f
            let realm = try Realm()
            //トークリストになかった場合のみ
            let result: Results<TalkList> = realm.objects(TalkList.self).filter("friend == %@", f!)
            if result.count == 0 {
                try realm.write({ () -> Void in
                    realm.add(talkList)
                    self.tableView.reloadData()
                })
            }
        }catch{
            print("Save is Faild")
        }
        //トーク画面に遷移
        performSegue(withIdentifier: "toTalkScreen", sender: nil)
    }
    
    //トーク画面に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTalkScreen" {
            let nextVC = segue.destination as! talkScreenController
            nextVC.friend = f
        }
    }
    
    
    // 画面が表示される際にtableViewのデータを再読み込みする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    
    //友達追加（＋を押された時）
    @IBAction func addFriend(_ sender: Any) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "友達を追加する",
            message: "名前を入力してください。",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
        })
        //キャンセルを押された時
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        //追加を押された時
        alert.addAction(
            UIAlertAction(
                title: "追加",
                style: UIAlertAction.Style.default) { _ in
                    if let newFriend = alertTextField?.text {
                        //データベースに友達を新規追加
                        do{
                            let friend = Friend()
                            friend.friendName = newFriend
                            let realm = try Realm()
                            try realm.write({ () -> Void in
                                realm.add(friend)
                                print("ToDo Saved \(newFriend)")
                                self.tableView.reloadData()
                            })
                        }catch{
                            print("Save is Faild")
                        }
                    }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //プロフィール変更
    @IBAction func editProfile(_ sender: Any) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "名前を変更する",
            message: "名前を入力してください。",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
        })
        //キャンセルを押された時
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        //追加を押された時
        alert.addAction(
            UIAlertAction(
                title: "更新",
                style: UIAlertAction.Style.default) { _ in
                    if let newName = alertTextField?.text {
                        //データベースにmyNameを更新
                        do{
                            let realm = try! Realm()
                            // データを更新
                            try! realm.write() {
                                let result = realm.objects(Profile.self)
                                if result.count == 0 {
                                    let p = Profile()
                                    p.myName = newName
                                    realm.add(p)
                                }
                                result[0].myName = newName
                            }
                            self.viewDidLoad()
                        }
                        catch{
                            
                        }
                    }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }

}

