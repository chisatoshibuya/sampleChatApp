//タイムライン表示の画面
import Foundation
import UIKit
import RealmSwift

class timelineController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var timeline: Results<Timeline>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //タイムラインデータ取得
        let realm = try! Realm()
        //sorted( )を使って日付順で取得（新しい投稿が上に来るよう）
        timeline = realm.objects(Timeline.self).sorted(byKeyPath: "createdAt", ascending: false)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        
        //timelineに代入されたデータをobject:NSArrayに代入
        let data = timeline[indexPath.row]
        
        //cellのtextLabelのtextにdataのプロパティを代入
        cell.textLabel?.text = data.text
        cell.detailTextLabel?.text = data.user?.myName
        
        return cell
    }
    
    //タイムラインをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.timeline[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
        }
    }
    
}
