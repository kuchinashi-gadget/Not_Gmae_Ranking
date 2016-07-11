//
//  RandamViewController.swift
//  Not_Game_Ranking
//


import UIKit
import Alamofire
import AVFoundation

class RandamViewController: UIViewController{
    
    //ランキングのリクエストと完了数
    var request_ranking_count = 0
    var complete_ranking_count = 0
    
    let mu = Make_URL()
    //var app_id_array = [String]()
    var app_info_instance_array = [app_info]()
    
    var world_flag = true
    var roop_flag = true
    
    var category_no = 0
    
    var select_app_no = ""
    var select_app_instance = app_info()
    
    
    //BGM
    var audioPlayer: AVAudioPlayer?
    var soundArray = [AVAudioPlayer]()
    
    //UI
    var title_label = UILabel()
    var setumei_label = UILabel()
    var omikuji_label = UIImageView()
    var sw_label = UILabel()
    var sw = UISwitch()
    
    //インジケーター
    var myActivityIndicator: UIActivityIndicatorView!
    
    //言語設定
    var language_str = ""
    var omikuji_title_str = ""
    var omikuji_setumei_str = ""
    var omikuji_sekai_str = ""
    
    
    var first_flag = true
    //var world_flag = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()

        
        read_language_setting()

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.LightContent;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("1stViewController's viewDidAppear() is called")
        
        //start_request()
        
        make_UI()
        //start_request()
        
        //フラグリセット
        first_flag = true
        
        sw.on = world_flag
        
    }
    
    func read_language_setting(){
        
        language_str = NSLocalizedString("language",comment:"言語")
        
        omikuji_title_str = NSLocalizedString("omikuji_title",comment:"おみくじのタイトル")
        omikuji_setumei_str = NSLocalizedString("omikuji_setumei",comment:"おみくじの説明")
        omikuji_sekai_str = NSLocalizedString("omikuji_sekai",comment:"世界のフラグ")
 
        
    }
    
    
    //端末のシェイク判定の設定
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if event?.type == UIEventType.Motion && event?.subtype == UIEventSubtype.MotionShake {
            print("端末が振られた")
            //最初の1回だけ実行する
            if(first_flag){
                first_flag = false
                move_UI()
                start_request()
                
            }

        }
    }
    
    func make_UI(){
        
        let screenWidth:Double = Double(UIScreen.mainScreen().bounds.size.width)
        let screenHight:Double = Double(UIScreen.mainScreen().bounds.size.height) - 50
        let moji_color:UIColor = UIColor.whiteColor()
        

        
        //画面タイトル
        var tmp_x = 0
        var tmp_y = Int(screenHight/100*5)
        var tmp_wight = Int(screenWidth)
        var tmp_hight = Int((screenHight)/100*5)
        title_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        title_label.font = UIFont(name: "Arial", size: 20)
        title_label.textColor = moji_color
        title_label.numberOfLines = 0
        title_label.textAlignment = NSTextAlignment.Center
        title_label.text = omikuji_title_str
        self.view.addSubview(title_label)
        
        
        tmp_x = 0
        tmp_y = Int(screenHight/100*15)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*10)
        setumei_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        setumei_label.font = UIFont(name: "Arial", size: 12)
        setumei_label.textColor = moji_color
        setumei_label.numberOfLines = 0
        setumei_label.textAlignment = NSTextAlignment.Center
        setumei_label.text = omikuji_setumei_str
        self.view.addSubview(setumei_label)
        
        tmp_x = Int(screenWidth/100*10)
        tmp_y = Int(screenHight/100*90)
        tmp_wight = Int(screenWidth/100*40)
        tmp_hight = Int((screenHight)/100*5)
        sw_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        sw_label.font = UIFont(name: "Arial", size: 10)
        sw_label.textColor = moji_color
        sw_label.numberOfLines = 0
        sw_label.textAlignment = NSTextAlignment.Right
        sw_label.text = omikuji_sekai_str
        self.view.addSubview(sw_label)
        
        tmp_x = Int(screenWidth/100*60)
        tmp_y = Int(screenHight/100*90)
        tmp_wight = Int(screenWidth/100*15)
        tmp_hight = Int((screenHight)/100*5)
        sw.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        // SwitchをOnに設定する.
        sw.on = true
        self.view.addSubview(sw)
        
        
        tmp_x = Int(screenWidth/100*10)
        tmp_y = Int(screenHight/100*30)
        tmp_wight = Int(screenWidth/100*80)
        tmp_hight = Int((screenHight)/100*50)
        
        if(tmp_wight>tmp_hight){
            
            tmp_wight = tmp_hight
        }else{
            tmp_hight = tmp_wight
            
        }
        
        tmp_x = Int((Int(screenWidth) - tmp_wight)/2)
        tmp_y = Int(screenHight/100*30) + (Int((screenHight)/100*50) - tmp_hight)/2
        
        omikuji_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        // 表示する画像を設定する.
        let myImage = UIImage(named: "omikuji.png")
        // 画像をUIImageViewに設定する.
        omikuji_label.image = myImage
        
        //タッチイベントを検知する
        omikuji_label.userInteractionEnabled = true
        omikuji_label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTapped:"))
        
        // UIImageViewをViewに追加する.
        self.view.addSubview(omikuji_label)
        
        
    }
    
    func move_UI(){
        
        
        var transform1:CGAffineTransform = CGAffineTransformIdentity
        var transform2:CGAffineTransform = CGAffineTransformIdentity
        //アニメーションの所要時間を持つ変数
        let duration:Double = 0.6
        
        transform1 = CGAffineTransformMakeRotation(CGFloat(0.2*M_PI))
        transform2 = CGAffineTransformMakeRotation(CGFloat(-0.2*M_PI))
        
        se_play()
        
        //アニメーション
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.omikuji_label.transform = transform1
            })
        { (Bool) -> Void in
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.omikuji_label.transform = CGAffineTransformIdentity
                //self.omikuji_label.transform = transform2
                })
            { (Bool) -> Void in
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    //self.omikuji_label.transform = CGAffineTransformIdentity
                    self.omikuji_label.transform = transform2
                })
                
                { (Bool) -> Void in
                    
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.omikuji_label.transform = CGAffineTransformIdentity
                        //self.omikuji_label.transform = transform2
                        
                        self.audioPlayer!.stop()
                        
                        self.start_Indicator()
                    })
                
                }
                
            }
            
        }
        
        
    }
    
    func se_play(){
        
        //String型の引数からサウンドファイルを読み込む
        print(NSBundle.mainBundle())
        let url = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("BGM.mp3")
        print(url)
        
        //NSBundle：ファイルパスを管理すするクラス
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
            //正しくないファイルを指定した場合nilが入る可能性がある
            
        }catch{
            print("Error!")
        }
        
        //audioPlayer?.numberOfLoops = -1     //BGMを無限にループさせる
        audioPlayer?.prepareToPlay()              //音声を即時再生させる
        audioPlayer?.play()                       //音を再生する
        
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {

        
        //最初の1回だけ実行する
        if(first_flag){
            first_flag = false
            move_UI()
            start_request()
            
        }
        
    }

    
    //画面遷移時に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if(segue.identifier == "segue5"){
            
            let SVC = segue.destinationViewController as! App_Info_ViewController
            
            SVC.app_no = select_app_no
            SVC.app_instance = select_app_instance
            SVC.iPhone_flag = select_app_instance.app_iPhone_screenshot_flag
            SVC.iPad_flag = select_app_instance.app_iPad_screenshot_flag
            
            
            
        }
        
        
        
    }
    
    func start_request(){
        
        //app_id_array.removeAll()
        app_info_instance_array.removeAll()
        
        world_flag = sw.on
        
        get_app_id_array(0)
        get_app_id_array(0)
        get_app_id_array(1)
        
        start_timer()
    }
    
    func make_id(){
        
        var tmp_no =  Int(arc4random() % UInt32(app_info_instance_array.count))
        
        //print(app_id_array.count)
        //print(app_id_array[tmp_no])
        
        select_app_no = app_info_instance_array[tmp_no].app_id
        select_app_instance = app_info_instance_array[tmp_no]
        
        self.performSegueWithIdentifier("segue5",sender:nil)
        
        
        
        
    }
    
    
    func start_timer(){
        
        //タイマーを作る.
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        
    }
    
    func onUpdate(timer : NSTimer){
        print("HTTPSランキングリクエストの数" + String(request_ranking_count))
        print("HTTPSランキングリクエストの完了数" + String(complete_ranking_count))
        
        print("配列数:" + String(app_info_instance_array.count))

        
        if(request_ranking_count != 0 && request_ranking_count == complete_ranking_count){
            
            timer.invalidate()
            
            stop_Indicator()
            
            make_id()
            
            
        }else{
            

        }

        
    }
    
    //ランキングを取得する関数
    func get_app_id_array(syubetu:Int){

        var tmp_url = ""
        var requestUrl = ""
        
        var read_falg = true
        
        
        //ランキングを取得
        if(syubetu == 0){
            
            if(world_flag){
                //世界中のアプリをランダムで表示
                requestUrl = mu.make_randam_ranking_URL(0)
                
                
            }else{
                //設定した国のランキングをランダムで表示
                requestUrl = mu.make_randam_ranking_URL(1)
                
            }
            
         //新着アプリ
        }else{
            if(world_flag){
                //世界中のアプリをランダムで表示
                requestUrl = mu.make_randam_new_URL(0)
                
                
            }else{
                //設定した国のランキングをランダムで表示
                requestUrl = mu.make_randam_new_URL(1)
                
            }
            
        }
        

        request_ranking_count = request_ranking_count + 1
        //Webサーバに対してHTTP通信のリクエストを出してデータを取得
        Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
            
            if let json = response.result.value {
                
            
                //まずJSONデータをNSDictionary型に
                var jsonDic = json as! NSDictionary
                
                //辞書化したjsonDicからキー値"responseData"を取り出す
                let responseData1 = jsonDic["feed"] as! NSDictionary
                
                let array1 = responseData1["entry"] as! NSArray
                
                self.complete_ranking_count = self.complete_ranking_count + 1

                
                for tmp in array1 {
                    var responseData2 = tmp["category"] as! NSDictionary
                    var responseData3 = responseData2["attributes"] as! NSDictionary
                    let tmp_jp_category = responseData3["label"] as! String
                    let tmp_en_category = responseData3["term"] as! String
                    
                    //ゲーム以外のカテゴリーを表示する
                    if(self.category_no == 0){
                        
                        if(tmp_en_category == "Games"){
                            
                            read_falg = false
                        }else{
                            read_falg = true
                        }
                    }else{
                        read_falg = true
                    }
                    
                    if(read_falg){
                        
                        
                        //app_infoクラスのインスタンスを作成
                        var app_instance = app_info()
                        
                        //順位を保存
//                        self.ranking_no = self.ranking_no + 1
//                        app_instance.app_ranking_no = self.ranking_no
                        
                        app_instance.app_jp_category = tmp_jp_category
                        app_instance.app_en_category = tmp_en_category
                        
                        responseData2 = tmp["id"] as! NSDictionary
                        responseData3 = responseData2["attributes"] as! NSDictionary
                        //print(responseData3)
                        let tmp_app_id = responseData3["im:id"] as! String
                        app_instance.app_id = tmp_app_id
                        
                        var tmp_app_url = responseData2["label"] as! String
                        //print(tmp_app_url)
                        app_instance.app_url = tmp_app_url
                        
                        let array2 = tmp["im:image"] as! NSArray
                        var tmp_app_icon_url = array2[2]["label"] as! String
                        //print(tmp_app_icon_url)
                        app_instance.app_icon_url = tmp_app_icon_url
                        
                        
                        responseData2 = tmp["im:price"] as! NSDictionary
                        responseData3 = responseData2["attributes"] as! NSDictionary
                        var tmp_price = responseData3["amount"]as! String
                        var tmp_price_double = Double(tmp_price)
                        app_instance.app_price = tmp_price_double!
                        //print(tmp_price)
                        
                        //print("#########")
                        //print(responseData2)
                        
                        tmp_price = responseData2["label"]as! String
                        
                        //print(tmp_price)
                        app_instance.app_price_label = tmp_price
                        
                        responseData2 = tmp["im:name"] as! NSDictionary
                        var tmp_app_name = responseData2["label"] as! String
                        //print(tmp_app_name)
                        app_instance.app_name = tmp_app_name
                        
                        //print(tmp_app_name)
                        
                        //self.get_review(app_instance,tmpno:tmp_no)
                        
                        
                        self.app_info_instance_array.append(app_instance)
                        

                        
                    }

                    
                    
                }
                
                
            }
            
        }
        
        
    }
    
    
    func start_Indicator(){
        
        
        
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0,100, 100)
        myActivityIndicator.center = self.view.center
        
        // アニメーションが停止している時もインジケータを表示させる.
        myActivityIndicator.hidesWhenStopped = true
        //myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        //myActivityIndicator.color = UIColor.redColor()
        
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        myActivityIndicator.backgroundColor = UIColor.grayColor()
        myActivityIndicator.layer.masksToBounds = true
        myActivityIndicator.alpha = 0.6
        myActivityIndicator.layer.cornerRadius = 5.0
        myActivityIndicator.layer.opacity = 0.8
        
        // アニメーションを開始する.
        myActivityIndicator.startAnimating()
        
        // インジケータを表示する
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
        
        
    }
    
    func stop_Indicator(){
        
        
        
        // インジケータを表示する
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        
        myActivityIndicator.stopAnimating()
        
        
        
    }

    

    


   

}
