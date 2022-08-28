//
//  ViewController.swift
//  TechPod
//
//  Created by Yui Ogawa on 2022/08/28.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // StoryBoardで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    // 曲名を入れる配列
    var songNameArray = [String]()
    // 曲のファイル名を入れるための配列
    var fileNameArray = [String]()
    // 音楽家の画像を入れるための配列
    var imageNameArray = [String]()
    
    // 音楽を再生するための変数
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 「デーブルビューのデータソースメソッドはViewControllerクラスに書く」ことを設定
        table.dataSource = self
        // 「テーブルビューのデリゲートメソッドはViewControllerメソッドに書く」ことを設定
        table.delegate = self
        // songArrayに曲名を入れる
        songNameArray = ["カノン", "エリーゼのために", "G線上のアリア"]
        // fileNameArrayにファイル名を入れる
        fileNameArray = ["cannon", "elise", "aria"]
        // imageNameArrayに曲の画像を入れる
        imageNameArray = ["Pachelbel.jpg", "Beethoven.jpg", "Bach.jpg"]
    }
    
    // ■ テービルビューのデータソースメソッド
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数をsongNameArrayの数にする
        return songNameArray.count
    }
    // セルの高さを指定
    func tableView(_ table: UITableView,
                      heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
   }
    // ID付きのセルを取得して、セル付属のtextLabelに曲名を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        // セルにsongNameArrayの曲名を表示する
        cell?.textLabel?.text = songNameArray[indexPath.row]
        
        // セルに音楽家の画像を表示する
        cell?.imageView?.image = UIImage(named: imageNameArray[indexPath.row])
        return cell!
    }
    
    // ■ テービルビューのデリゲートメソッド
    // セルが押されたときに呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(songNameArray[indexPath.row])が選ばれました！")
        
        // 音楽ファイルの設定
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[indexPath.row], ofType: "mp3")!)
        // 再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        
        // 音楽を再生
        audioPlayer.play()
    }
}

