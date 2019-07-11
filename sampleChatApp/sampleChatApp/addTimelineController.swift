//タイムライン投稿画面のコード
import Foundation
import UIKit
import RealmSwift

class addTimelineController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //ADD ボタンを押された時
    @IBAction func addTimeline(_ sender: UIButton) {
        if let timelineText = textView?.text {
            //データベースにタイムラインを新規追加
            do{
                let realm = try! Realm()
                //user情報を取得
                let user = realm.objects(Profile.self)
                //realmに書き込み・保存
                let timeline  = Timeline()
                timeline.text = timelineText
                timeline.user = user[0]
                
                try realm.write({ () -> Void in
                    realm.add(timeline)
                    print("ToDo Saved\(timeline)")
                })
            }catch{
                print("Save is Faild")
            }
        }
    }
    
}
