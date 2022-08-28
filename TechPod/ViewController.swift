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
    @IBOutlet var toolBar: UIToolbar!
    
    // 曲名を入れる配列
    var songNameArray = [String]()
    // 曲のファイル名を入れるための配列
    var fileNameArray = [String]()
    // 音楽家の画像を入れるための配列
    var imageNameArray = [String]()
    
    // 音楽を再生するための変数
    var audioPlayer: AVAudioPlayer!
    // 現在の曲番号
    var songNum: Int = 0
    
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
        // ツールバーを非表示にしておく
        toolBar.isHidden = true
    }
    // ツールバーの再生 / 停止ボタン(BarButtonItem)の見た目を変更
    func setBarButtonItem() {
        var playPauseButton: UIBarButtonItem!
        // 曲が再生中であれば、一時停止のものに
        if audioPlayer.isPlaying {
            // BarButtonItemを一時停止のものに変える
            playPauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(self.playPause))
            toolBar.items![2] = playPauseButton
        } else {
            playPauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.playPause))
            toolBar.items![2] = playPauseButton
        }
    }
    // 曲を再生 / 一時停止する
    @IBAction func playPause(){
        // 曲が再生中であれば、
        if audioPlayer.isPlaying{
            // 曲を一時停止
            audioPlayer.pause()
            // ツールバーの再生 / 停止ボタンの見た目を変更
            setBarButtonItem()
        } else {
            // 曲を再生
            audioPlayer.play()
            // ツールバーの再生 / 停止ボタンの見た目を変更
            setBarButtonItem()
        }
    }
    
    // 引数の曲番号(num)のセルへのIndexPathを取得し、解除
    func deselectCell(num: Int){
        let nowIndexPath = IndexPath(row: num, section: 0)
        table.deselectRow(at: nowIndexPath, animated: true)
        table.cellForRow(at: nowIndexPath)?.accessoryType = .none
    }
    // 引数の曲番号(num)のセルへのIndexPathを取得し、選択
    func selectCell(num: Int){
        let nextIndexPath = IndexPath(row: songNum, section: 0)
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        table.cellForRow(at: nextIndexPath)?.accessoryType = .checkmark
    }
    // 引数の曲番号(num)の曲を再生する
    func playSong(num: Int){
        // 音楽ファイルの設定
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: fileNameArray[num], ofType: "mp3")!)
        // 再生の準備
        audioPlayer = try? AVAudioPlayer(contentsOf: audioPath)
        
        // 音楽を再生
        audioPlayer.play()
    }
    
    // 前の曲を再生する
    @IBAction func back(){
        // 今流れている曲のセルへのIndexPathを取得し、解除
        deselectCell(num: songNum)
        
        // もし現在流している曲がリストの最後の曲であるならば、
        if songNum == 0 {
            // 最初の曲を選ぶ
            songNum = songNameArray.count - 1
        } else {
            // それ以外は前の曲を選ぶ
            songNum = songNum - 1
        }
        // 次に流す曲のセルへのIndexPathを取得し、選択
        selectCell(num: songNum)
        playSong(num: songNum)
    }
    // 次の曲を再生する
    @IBAction func next(){
        // 今流れている曲のセルへのIndexPathを取得し、解除
        deselectCell(num: songNum)
        
        // もし現在流している曲がリストの最後の曲であるならば、
        if songNum == fileNameArray.count - 1 {
            // 最初の曲を選ぶ
            songNum = 0
        } else {
            // それ以外は次の曲を選ぶ
            songNum = songNum + 1
        }
        // 次に流す曲のセルへのIndexPathを取得し、選択
        selectCell(num: songNum)
        
        // 曲を流す
        playSong(num: songNum)
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
        songNum = indexPath.row
        print("\(songNameArray[songNum])が選ばれました！")
        
        // 引数への曲を再生する
        playSong(num: songNum)
        
        // セルにチェックマークを追加する
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        // ツールバーの再生 / 停止ボタンの見た目を変える
        setBarButtonItem()
        // ツールバーを表示する
        if toolBar.isHidden {
            toolBar.isHidden = false
        }
    }
    // セルの選択が外れたときに呼び出されるメソッド
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at:indexPath)?.accessoryType = .none
    }
}

