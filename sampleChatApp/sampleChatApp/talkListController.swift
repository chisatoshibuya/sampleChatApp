//トークリスト画面のコード
import Foundation
import UIKit
import RealmSwift

class talkListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var talklist: Results<TalkList>!
    //トーク画面に値を渡す時に使用
    var f: TalkList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //トークリストデータ取得
        let realm = try! Realm()
        talklist = realm.objects(TalkList.self)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        //talklistに代入されたデータをobject:NSArrayに代入
        let data = talklist[indexPath.row]
        
        //cellのtextLabelのtextにdataのプロパティを代入
        cell.textLabel?.text = data.friend?.friendName
        
        return cell
    }
    
    //トークリストをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.talklist[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
        }
    }
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fにデータを代入
        f = talklist[indexPath.row]
        //トーク画面に遷移
        performSegue(withIdentifier: "toTalk", sender: nil)
    }
    
    //トーク画面に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTalk" {
            let nextVC = segue.destination as! talkScreenController
            nextVC.friend = f?.friend
        }
    }
}
