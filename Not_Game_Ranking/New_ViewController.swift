//
//  ViewController.swift
//  Not_Game_Ranking
//


import UIKit
import Alamofire

class New_ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    //UIの定義
    var title_label = UILabel()
    var segment = UISegmentedControl()
    var table_view = UITableView()
    var refreshControl:UIRefreshControl!
    var refreshControl2:UIRefreshControl!
    var collection_view : UICollectionView!
    
    
    let segment_array_ja:NSArray = ["新着","新着有料","新着無料"]
    let segment_array_en:NSArray = ["New","New Paid","New Free"]
    
    //インジケーター
    var myActivityIndicator: UIActivityIndicatorView!
    
    //app_infoの配列
    var app_info_instance_array_new = [app_info]()
    var app_info_instance_array_newpaid = [app_info]()
    var app_info_instance_array_newfree = [app_info]()
    
    //    var app_info_instance_array_newfree = [app_info]()
    //    var app_info_instance_array_newpaid = [app_info]()
    var app_info_instance_array = [app_info]()
    
    var syubetu_flag = 0
    //var ipad_flag = 0
    
    
    //Get_Json
    //let gj = Get_Json()
    let mu = Make_URL()
    let csv_read = CSV_file()
    let rws = read_or_write_setting()
    
    
    //CSVファイルのデータを入れる配列
    var country_label_jp = [String()]
    var country_label_en = [String()]
    var country_code_label = [String()]
    var category_label_jp = [String()]
    var category_label_en = [String()]
    var category_code_label = [String()]
    
    //設定内容
    var country_no = 0
    var app_shyubetu_no = 0
    var category_no = 0
    var country_code = ""
    var view_no = 0
    
    //前回の設定内容
    var before_flag = false
    var country_no_before = 0
    var app_shyubetu_no_before = 0
    var category_no_befor = 0
    var view_no_before = 0
    
    //ランキングのリクエストと完了数
    var request_ranking_count = 0
    var complete_ranking_count = 0
    
    //ランキングのリクエストと完了数
    var request_review_count = 0
    var complete_review_count = 0
    
    
    //タップじに選択される値を入れる変数
    var select_app_no = ""
    var select_app_instance = app_info()
    
    //長押し時に選択するappstoreのURL
    var app_store_url = ""
    
    
    //言語設定
    var language_str = ""
    var alert_title_str=""
    var alert_message_str=""
    var alert_OK_str=""
    var alert_NG_str=""
    
    var ranking_no = 0
    
    var indicator_flag = false

    
    override func viewDidLoad() {
        
        
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()
        
        read_language_setting()
        
        make_UI()
        
        read_setting()
        
        //add_refresh()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("1stViewController's viewDidAppear() is called")
        
        read_setting()
        
        make_UI2()
        
        //初回は必ず読み込む
        if(!before_flag){
            //配列を読み込む
            reload_array()
            
        }else{
            //設定が同じ場合
            if(country_no_before == country_no && app_shyubetu_no_before == app_shyubetu_no && category_no_befor == category_no && view_no_before == view_no){
                print("再読み込みはしない")
                
                //設定が変わった場合
            }else{
                //配列を読み込む
                reload_array()
                
            }
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.LightContent;
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func read_language_setting(){
        
        language_str = NSLocalizedString("language",comment:"言語")
        alert_title_str = NSLocalizedString("alert_title_str",comment:"アラートタイトル")
        alert_message_str = NSLocalizedString("alert_message_str",comment:"メッセージ")
        alert_OK_str = NSLocalizedString("alert_OK_str",comment:"OK")
        alert_NG_str = NSLocalizedString("alart_NG_str",comment:"NG")
        
        
    }
    
    func start_timer(){
        
        //タイマーを作る.
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        
    }
    
    func onUpdate(timer : NSTimer){
        print("HTTPSランキングリクエストの数" + String(request_ranking_count))
        print("HTTPSランキングリクエストの完了数" + String(complete_ranking_count))
        print("HTTPSレビューリクエストの数" + String(request_review_count))
        print("HTTPSレビューリクエストの完了数" + String(complete_review_count))
        
        if(request_ranking_count != 0 && request_ranking_count == complete_ranking_count){
            
//            setting_button.hidden = false
//            category_button.hidden = false
//            //timer.invalidate()
            save_before_setting()
            
            
        }else{
            
//            setting_button.hidden = false
//            category_button.hidden = false
        }
        
        if(request_review_count != 0 && request_review_count == complete_review_count){
            
            stop_Indicator()
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                //print("iPhone")
            }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
                //print("iPad")
                reload_tableview_collection_view()
            }else{
                //print("Unspecified")
            }
            
            indicator_flag = false
            timer.invalidate()
            
        }else{
            
            
        }
        
    }
    
    func reload_array(){
        
//        request_count = 0
//        complete_count = 0
        
        
        
        
        app_info_instance_array.removeAll()
        
        
        syubetu_flag = segment.selectedSegmentIndex
        
        if(syubetu_flag == 0){
            app_info_instance_array_new.removeAll()
            get_ranking(0)
            
        }else if(syubetu_flag == 1){
            app_info_instance_array_newpaid.removeAll()
            get_ranking(1)
            
        }else if(self.syubetu_flag == 2){
            app_info_instance_array_newfree.removeAll()
            get_ranking(2)
            
        }
        
        
        
        //前回の検索結果を保存
        save_before_setting()
        
        
        
        
    }
    
    //画面遷移時に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if(segue.identifier == "segue4"){
            
            let SVC = segue.destinationViewController as! App_Info_ViewController
            
            SVC.app_no = select_app_no
            SVC.app_instance = select_app_instance
            SVC.iPhone_flag = select_app_instance.app_iPhone_screenshot_flag
            SVC.iPad_flag = select_app_instance.app_iPad_screenshot_flag
            
            
        }
        
        
        
    }
    
    
    func reload_tableview_collection_view(){
        
        if(view_no == 0){
            
            table_view.reloadData()
            
        }else{
            
            collection_view.reloadData()
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
        var tmp_hight = Int((screenHight)/100*10)
        title_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        title_label.font = UIFont(name: "Arial", size: 15)
        title_label.textColor = moji_color
        title_label.textAlignment = NSTextAlignment.Center
        //title_label.text = "新着app"
        self.view.addSubview(title_label)
        
        
        //選択肢
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*17)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int((screenHight)/100*5)
        
        // SegmentedControlを作成する.
        
        if(language_str == "日本語"){
            segment = UISegmentedControl(items: segment_array_ja as [AnyObject])
        }else{
            segment = UISegmentedControl(items: segment_array_en as [AnyObject])
        }
        segment.setTitleTextAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(10), forKey: NSFontAttributeName) as [NSObject : AnyObject], forState: UIControlState.Normal)
        segment.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        segment.selectedSegmentIndex = 0
        syubetu_flag = segment.selectedSegmentIndex
        
        //segment.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // イベントを追加する.
        segment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(segment)
        
        
        
        
        //テーブルビュー
        tmp_x = Int(0)
        tmp_y = Int(screenHight/100*25)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*75)
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        table_view = UITableView(frame: CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight))
        
        
        
        // Cell名の登録をおこなう.
        //table_view.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        //カスタムセルを指定
        var nib1  = UINib(nibName: "Custom_1_TableViewCell", bundle:nil)
        
        //nib.title = "aaaa"
        table_view.registerNib(nib1, forCellReuseIdentifier:"MyCell")
        //table_view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // DataSourceの設定をする.
        table_view.dataSource = self
        
        // Delegateを設定する.
        table_view.delegate = self
        
        table_view.backgroundColor = UIColor.blackColor()
        
        // UILongPressGestureRecognizer宣言
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        
        // tableViewにrecognizerを設定
        table_view.addGestureRecognizer(longPressRecognizer)
        
        add_refresh()
        self.view.addSubview(table_view)
        
        
        //CollectionView
        tmp_x = Int(0)
        tmp_y = Int(screenHight/100*25)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*75)
        
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        let width: CGFloat = view.frame.width / 5
        layout.itemSize = CGSizeMake(width, width)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(4, 8, 4, 8)
        
        
        // CollectionViewを生成.
        //collection_view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collection_view = UICollectionView(frame: CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight),collectionViewLayout: layout)
        
        
        //カスタムセルを指定
        var nib2  = UINib(nibName: "Custom_2_CollectionViewCell", bundle:nil)
        
        //nib.title = "aaaa"
        collection_view.registerNib(nib2, forCellWithReuseIdentifier:"Cell")
        
        collection_view.delegate = self
        collection_view.dataSource = self
        
        // UILongPressGestureRecognizer宣言
        var longPressRecognizer2 = UILongPressGestureRecognizer(target: self, action: "cellLongPressed2:")
        
        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        //longPressRecognizer.delegate = table_view
        
        // tableViewにrecognizerを設定
        collection_view.addGestureRecognizer(longPressRecognizer2)
        
        //引っ張って更新を追加
        add_refresh2()
        
        self.view.addSubview(collection_view)
        
        
        

        
        
    }
    
    func make_UI2(){
        
        
        if(view_no == 0){
            
            collection_view.hidden = true
            table_view.hidden = false
            
            
        }else{
            collection_view.hidden = false
            table_view.hidden = true
            
        }
        
        
    }
    

    
    func segconChanged(segcon: UISegmentedControl){
        
        var tmp_message = (segment_array_ja[segment.selectedSegmentIndex] as! String) + "にセグメントが変わる"
        
        
        syubetu_flag = segcon.selectedSegmentIndex
        //print(syubetu_flag)
        
        app_info_instance_array.removeAll()
        
        if(syubetu_flag == 0){
            
            
            if(app_info_instance_array_new.count == 0){
                
                get_ranking(0)
                //get_ranking(0,offset:11)
                //start_timer()
                
            }else{
                
                app_info_instance_array = app_info_instance_array_new
                
            }
            
            
        }else if(syubetu_flag == 1){
            
            if(app_info_instance_array_newpaid.count == 0){
                
                get_ranking(1)
                //start_timer()
                
            }else{
                
                app_info_instance_array = app_info_instance_array_newpaid
                
            }
            
        }else if(self.syubetu_flag == 2){
            
            if(app_info_instance_array_newfree.count == 0){
                
                get_ranking(2)
                //start_timer()
                
            }else{
                
                app_info_instance_array = app_info_instance_array_newfree
                
            }
            
        }
        
        
        
        //table_view.reloadData()
        
        //table_view.setContentOffset(CGPointMake(0, 0), animated: false)
        
        
    }
    
    
    ////////////////
    ///table_viewの設定
    ////////////////
    

    //table_viewのセルの高さの設定
    func tableView(table_view: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 100
    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app_info_instance_array.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = table_view.dequeueReusableCellWithIdentifier("MyCell") as? Custom_1_TableViewCell
        
        let koukoku_flag = app_info_instance_array[indexPath.row].koukoku_flag
        if(koukoku_flag){

            
        }else{
            
            //cell!.banner_view.hidden = true
            
            //cell!.ranking_label.text = String(indexPath.row + 1)
            cell!.ranking_label.text = String(app_info_instance_array[indexPath.row].app_ranking_no)
            cell!.app_title_label.text = app_info_instance_array[indexPath.row].app_name
            
            if(language_str == "日本語"){
                cell!.app_category_title.text = app_info_instance_array[indexPath.row].app_jp_category
            }else{
                cell!.app_category_title.text = app_info_instance_array[indexPath.row].app_en_category
            }
            
            
            //            var tmp_price = app_info_instance_array[indexPath.row].app_price
            //            var tmp_int = Int(tmp_price)
            //
            //            //cell!.app_kakaku_titile.text = "¥ " + String(tmp_int)
            
            var tmp_price = app_info_instance_array[indexPath.row].app_price
            var tmp_price_label = app_info_instance_array[indexPath.row].app_price_label
            var tmp_int = Int(tmp_price)
            
            if(tmp_price_label == "入手"){
                
                cell!.app_kakaku_titile.text = ""
                
            }else if(tmp_price_label == "Get"){
                
                cell!.app_kakaku_titile.text = ""
                
            }else{
                
                cell!.app_kakaku_titile.text = tmp_price_label
            }
            
            var tmp_app_icon_url = app_info_instance_array[indexPath.row].app_icon_url
            
            //print(tmp_app_icon_url)
            let url = NSURL(string:tmp_app_icon_url)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                cell!.app_icon_image.image = image
                
            }
            
            //マスク処理
            cell!.app_icon_image.layer.masksToBounds = true
            cell!.app_icon_image.layer.cornerRadius = 10.0
            
            
            
            if(app_info_instance_array[indexPath.row].userRatingCountForCurrentVersion == 0){
                
                cell!.hyoukasu_label.text = ""
                //cell!.hyoukasu_label.text = "(100)"
                
            }else{
                var tmp_hyoukasu = "(" + String(app_info_instance_array[indexPath.row].userRatingCountForCurrentVersion)
                tmp_hyoukasu = tmp_hyoukasu + ")"
                cell!.hyoukasu_label.text = tmp_hyoukasu
                //cell!.hyoukasu_label.text = "(100)"
            }
            
            
            if(app_info_instance_array[indexPath.row].app_averageUserRatingForCurrentVersion == 0.0){
                
                
                cell!.app_hyouka.hidden = true
                
            }else{
                
                var tmp = Int(app_info_instance_array[indexPath.row].app_averageUserRatingForCurrentVersion * 10)
                var tmp_name = "hyouka_" + String(tmp)
                cell!.app_hyouka.image = UIImage(named:tmp_name)
                cell!.app_hyouka.hidden = false
                
                //cell!.app_hyouka.image = UIImage(named:"hyouka_45")
                
                
            }
            
            
            //cell!.view.hidden = true
            
        }
        
        return cell!
        
        
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("セルが押された")
        print(indexPath.row)
        
        
        select_app_no = app_info_instance_array[indexPath.row].app_id
        select_app_instance = app_info_instance_array[indexPath.row]
        
//        if(!select_app_instance.koukoku_flag){
//            self.performSegueWithIdentifier("segue4",sender:nil)
//        }
        
        if(!select_app_instance.koukoku_flag){
            self.performSegueWithIdentifier("segue4",sender:nil)
            

        }

        
    }
    
    /* 長押しした際に呼ばれるメソッド */
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        print("セルが長押された")
        //print(indexPath.row)
        
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(table_view)
        let indexPath = table_view.indexPathForRowAtPoint(point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            // 長押しされた場合の処理
            print("長押しされたcellのindexPath:\(indexPath?.row)")
            
            if(!select_app_instance.koukoku_flag){
                
                app_store_url = app_info_instance_array[(indexPath?.row)!].app_appstore_url
                
                go_appstaore()
                
            }
            

        }
    }
    
    
    func add_refresh(){
        
        //リフレッシュ
        var refreshControl_String = "更新"
        if(language_str == "日本語"){
            refreshControl_String = "更新"
            
        }else{
            refreshControl_String = "Refresh"
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: refreshControl_String)
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table_view.addSubview(refreshControl)
    }
    
    func refresh(){
        
        //        var app_info_instance_array_new = [app_info]()
        //        var app_info_instance_array_newpaid = [app_info]()
        //        var app_info_instance_array_newfree = [app_info]()
        
        app_info_instance_array.removeAll()
        table_view.reloadData()
        
        if(syubetu_flag == 0){

            app_info_instance_array_new.removeAll()
            if(app_info_instance_array_new.count == 0){
                
                get_ranking(0)
                
                //get_ranking(0,offset:11)
                //start_timer()
                
            }else{
                
                //app_info_instance_array = app_info_instance_array_paid
                
            }
            
            
        }else if(syubetu_flag == 1){
            app_info_instance_array_newpaid.removeAll()
            if(app_info_instance_array_newpaid.count == 0){
                
                get_ranking(1)
                //start_timer()
                
            }else{
                
                app_info_instance_array = app_info_instance_array_newpaid
                
            }
            
        }else if(self.syubetu_flag == 2){
            app_info_instance_array_newfree.removeAll()
            if(app_info_instance_array_newfree.count == 0){
                
                get_ranking(2)
                //start_timer()
                
            }else{
                
                app_info_instance_array = app_info_instance_array_newfree
                
            }
            
        }
        
        
        table_view.reloadData()
        
        refreshControl.endRefreshing()
        
    }
    
    
    //////////////
    //table_viewの設定（ここまで）
    //////////////
    
    
    
    ///////////
    //collectionView関連の設定
    ////////////
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        
        //コレクションビューから識別子「TestCell」のセルを取得する。
        let testCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Custom_2_CollectionViewCell
        
        
        let koukoku_flag = app_info_instance_array[indexPath.row].koukoku_flag
        if(koukoku_flag){
            

            
            
        }else{
            
            //testCell.banner_view.hidden = true
            
            
            //順位の表示
            testCell.ranking_label.text = String(app_info_instance_array[indexPath.row].app_ranking_no)
            //testCell.ranking_label.text = String(indexPath.row)
            
            //アプリ名の表示
            testCell.app_name_label.text = app_info_instance_array[indexPath.row].app_name
            //testCell.app_name_label.text = "aaaaa"
            
            //アプリのアイコンの表示
            testCell.app_icon_image!.hidden = false
            var tmp_app_icon_url = ""
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                //print("iPhone")
                tmp_app_icon_url = app_info_instance_array[indexPath.row].app_icon_url
            }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
                //print("iPad")
                tmp_app_icon_url = app_info_instance_array[indexPath.row].app_icon_url
                if(app_info_instance_array[indexPath.row].app_icon_url_big != ""){
                    tmp_app_icon_url = app_info_instance_array[indexPath.row].app_icon_url_big
                }
            }else{
                //print("Unspecified")
                tmp_app_icon_url = app_info_instance_array[indexPath.row].app_icon_url
            }
            
            //print(tmp_app_icon_url)
            let url = NSURL(string:tmp_app_icon_url)
            let req = NSURLRequest(URL:url!)
            
            //print(tmp_app_icon_url)
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                
                if(data != nil){
                    
                    var image = UIImage(data:data!)
                    testCell.app_icon_image!.image = image
                }
                
                
            }
            
            //マスク処理
            testCell.app_icon_image!.layer.masksToBounds = true
            testCell.app_icon_image!.layer.cornerRadius = 10.0
            
        }
        
        
        return testCell
    }
    
    //section 数の設定、今回は１つにセット
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return app_info_instance_array.count
        
        //return 20
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        select_app_no = app_info_instance_array[indexPath.row].app_id
        select_app_instance = app_info_instance_array[indexPath.row]
        
        if(!select_app_instance.koukoku_flag){
            self.performSegueWithIdentifier("segue4",sender:nil)

        }
        
        
        
    }
    
    /* 長押しした際に呼ばれるメソッド */
    func cellLongPressed2(recognizer: UILongPressGestureRecognizer) {
        
        print("コレクションビューのセルが長押された")
        
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(collection_view)
        let indexPath = collection_view.indexPathForItemAtPoint(point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            // 長押しされた場合の処理
            print("長押しされたcellのindexPath:\(indexPath?.row)")
            
            if(!app_info_instance_array[(indexPath?.row)!].koukoku_flag){
                app_store_url = app_info_instance_array[(indexPath?.row)!].app_appstore_url
                
                go_appstaore()
                
            }
            
            
        }
    }
    
    func add_refresh2(){
        
        //リフレッシュ
        var refreshControl_String = "更新"
        if(language_str == "日本語"){
            refreshControl_String = "更新"
            
        }else{
            refreshControl_String = "Refresh"
        }
        
        
        //UIRefreshControllのインスタンスを生成する。
        self.refreshControl2 = UIRefreshControl()
        
        self.refreshControl2.attributedTitle = NSAttributedString(string: refreshControl_String)
        self.refreshControl2.backgroundColor = UIColor.whiteColor()
        //self.refreshControl2.tintColor = UIColor.whiteColor()
        //下に引っ張った時に、リフレッシュさせる関数を実行する。”：”を忘れがちなので注意。
        self.refreshControl2.addTarget(self, action: "refresh2", forControlEvents: UIControlEvents.ValueChanged)
        //UICollectionView上に、ロード中...を表示するための新しいビューを作る
        self.collection_view.addSubview(refreshControl2)
        
        
    }
    
    func refresh2(){
        
        if(!indicator_flag){
            
            app_info_instance_array.removeAll()
            collection_view.reloadData()
            
            reload_array()
            
        }
        
        refreshControl2.endRefreshing()
        
    }


    ////////////////
    ///httpの設定
    ////////////////

    
    //ランキングを取得する関数
    func get_ranking(tmp_no:Int){
        
        //print("リクエスを出す")
        request_ranking_count = 0
        complete_ranking_count = 0
        request_review_count = 0
        complete_review_count = 0
        
        start_timer()
        
        indicator_flag = true
        
        var tmp_message = country_label_jp[country_no] + "の" +
            (segment_array_ja[segment.selectedSegmentIndex] as! String) + "新着アプリを取得する"

        
        var tmp_url = ""
        var requestUrl = ""
        
        var read_falg = true
        
        
        
        requestUrl = mu.make_new_ranking(tmp_no)
        
        
        //print(requestUrl)
        
        //var app_info_instance_array = [app_info]()
        
        request_ranking_count = request_ranking_count + 1
        
        start_Indicator()
        
        //Webサーバに対してHTTP通信のリクエストを出してデータを取得
        Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
            
            if let json = response.result.value {
                
                
                //まずJSONデータをNSDictionary型に
                var jsonDic = json as! NSDictionary
                
                //辞書化したjsonDicからキー値"responseData"を取り出す
                let responseData1 = jsonDic["feed"] as! NSDictionary
                
                let array1 = responseData1["entry"] as! NSArray
                
                self.ranking_no = 0
                
                for tmp in array1 {
                    //print("ランキングを取得")
                    
                    
                    var responseData2 = tmp["category"] as! NSDictionary
                    var responseData3 = responseData2["attributes"] as! NSDictionary
                    let tmp_jp_category = responseData3["label"] as! String
                    let tmp_en_category = responseData3["term"] as! String
                    
                    
                    if(self.category_no == 0){
                        
                        if(tmp_jp_category == "ゲーム"){
                            
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
                        
                        self.ranking_no = self.ranking_no + 1
                        
                        app_instance.app_ranking_no = self.ranking_no
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
                        
//                        print("#########")
//                        print(responseData2)
                        
                        tmp_price = responseData2["label"]as! String
                        
                        //print(tmp_price)
                        app_instance.app_price_label = tmp_price
                        
                        responseData2 = tmp["im:name"] as! NSDictionary
                        var tmp_app_name = responseData2["label"] as! String
                        //print(tmp_app_name)
                        app_instance.app_name = tmp_app_name
                        
                        //print(tmp_app_name)
                        
                        //self.get_review(app_instance,tmpno:tmp_no)
                        
                        
                        self.get_review(app_instance)
                        
                        if(tmp_no == 0){
                            
                            self.app_info_instance_array_new.append(app_instance)
                            
                            
                            
                        }else if(tmp_no == 1){
                            
                            self.app_info_instance_array_newpaid.append(app_instance)
                            
                            
                            
                        }else if(tmp_no == 2){
                            
                            
                            self.app_info_instance_array_newfree.append(app_instance)
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                if(self.syubetu_flag == 0){
                    
                    self.app_info_instance_array = self.app_info_instance_array_new
                    
                }else if(self.syubetu_flag == 1){
                    
                    self.app_info_instance_array = self.app_info_instance_array_newpaid
                    
                }else if(self.syubetu_flag == 2){
                    
                    self.app_info_instance_array = self.app_info_instance_array_newfree
                    
                }
                
                if(self.syubetu_flag == tmp_no){
                    
                    //self.table_view.reloadData()
                    
                }
                
                
                
            }
            
            
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
            //print("HTTPリクエスと完了1")
            //self.table_view.reloadData()
            self.reload_tableview_collection_view()
            
            // インジケータを非表示にする
            self.stop_Indicator()
            
            self.complete_ranking_count = self.complete_ranking_count + 1
        }
        
        
    }
    
    
    
    func get_review(app_info_instance:app_info){
        
        var tmp_app_id = app_info_instance.app_id
        
        
        //let requestUrl = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + tmp_app_id + "&entity=software&country=jp"
        
        let requestUrl = mu.make_review_url(tmp_app_id)
        
        //print(requestUrl)
        
        request_review_count = request_review_count + 1
        
        // インジケータを表示にする
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
            
            if let json = response.result.value {
                

                //self.start_Indicator()
                
                var jsonDic = json as! NSDictionary
                let responseData1 = jsonDic["results"] as! NSArray
                
                
                
                for tmp in responseData1 {
                    
                    //                    print("AAAAAAAAAAAAAA")
                    //                    print("AAAAAAAAAAAAAA")
                    //                    print("AAAAAAAAAAAAAA")
                    //                    print(tmp)
                    
                    var tmp_str = String(tmp)
                    
                    
                    if(tmp_str.containsString("averageUserRatingForCurrentVersion")){
                        
                        let responseData2 = tmp["averageUserRatingForCurrentVersion"] as! Double
                        app_info_instance.app_averageUserRatingForCurrentVersion = responseData2
                        
                        
                    }else{
                        
                        app_info_instance.app_averageUserRatingForCurrentVersion = 0.0
                        
                        
                    }
                    
                    if(tmp_str.containsString("userRatingCountForCurrentVersion")){
                        
                        let responseData3 = tmp["userRatingCountForCurrentVersion"] as! Int
                        app_info_instance.userRatingCountForCurrentVersion = responseData3
                        //print(responseData2)
                        
                    }else{
                        
                        app_info_instance.app_averageUserRatingForCurrentVersion = 0
                        
                    }
                    
                    
                    //iPhoneのスクリーンショットのURL
                    var responseData5 = NSArray()
                    if(tmp_str.containsString("screenshotUrls")){
                        
                        responseData5 = tmp["screenshotUrls"] as! NSArray
                        
                        if(responseData5.count != 0){
                            
                            app_info_instance.app_iPhone_screenshot_flag = true

                            
                        }
                        
                        
                    }else{
                        
                        
                        
                    }
                    
                    //iPadのスクリーンショットのURL
                    responseData5 = NSArray()
                    if(tmp_str.containsString("ipadScreenshotUrls")){
                        
                        responseData5 = tmp["ipadScreenshotUrls"] as! NSArray
                        
                        if(responseData5.count != 0){
                            app_info_instance.app_iPad_screenshot_flag = true
                            
                            
                        }
                        
                        
                    }else{
                        
                        
                        
                    }
                    
                    //アプリのアイコンの大きいURL
                    var responseData6 = ""
                    if(tmp_str.containsString("artworkUrl512")){
                        
                        responseData6 = tmp["artworkUrl512"] as! String
                        
                        do{
                            
                            try app_info_instance.app_icon_url_big = responseData6
                            
                            
                        }catch{
                            
                            print("エラー")
                        }
                        
                    }else{
                        
                        responseData6 = ""
                        
                    }
                    
                    
                }
                
                
            }
            
            // インジケータを非表示にする
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            self.complete_review_count = self.complete_review_count + 1
            
            if(self.view_no == 0){
                
                self.table_view.reloadData()
            }

        }
        
    }
    
    
    
    ////////////////
    ///httpの設定（ここまで）
    ////////////////
    
    func read_setting(){
        
        var tmp_array = csv_read.read_country_csv()
        country_label_jp = tmp_array.0
        country_label_en = tmp_array.1
        country_code_label = tmp_array.2
        
        tmp_array = csv_read.read_category_csv()
        category_label_jp = tmp_array.0
        category_label_en = tmp_array.1
        category_code_label = tmp_array.2
        
        
        var tmp = rws.read_setting()
        
        app_shyubetu_no = tmp.0
        category_no = tmp.1
        country_no = tmp.2
        view_no = tmp.3
        
        
        if(language_str == "日本語"){
            
            title_label.text = (country_label_jp[country_no] as! String)+"の新着App"
            
        }else{
            
            title_label.text = "New app in " + (country_label_en[country_no] as! String)
        }
    
        
    }
    
    func save_before_setting(){
        
        //現在の設定をbeforeに保存
        country_no_before = country_no
        app_shyubetu_no_before = app_shyubetu_no
        category_no_befor = category_no
        view_no_before = view_no
        
        //フラグをtrueにする
        before_flag = true
        
    }
    
    
    ////////////////////
    //インジケーターの設定
    ////////////////////
    
    
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
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //self.stop_Indicator()
        
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
        
        
    }
    
    func stop_Indicator(){
        
        // インジケータを表示する
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        
        myActivityIndicator.stopAnimating()
        
        
        
    }
    
    
    ////////////////////
    //インジケーターの設定(ここまで）
    ////////////////////
    
    func go_appstaore(){
        
        
        
        //UIAlertView
        let alert:UIAlertController = UIAlertController(title:alert_title_str,
                                                        message: alert_message_str,
                                                        preferredStyle: UIAlertControllerStyle.Alert)
        
        
        //Cancel 一つだけしか指定できない
        let cancelAction:UIAlertAction = UIAlertAction(title: alert_NG_str,
                                                       style: UIAlertActionStyle.Cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in

        })
        
        //お気に入り追加
        let review:UIAlertAction = UIAlertAction(title: alert_OK_str,
                                                 style: UIAlertActionStyle.Default,
                                                 handler:{
                                                    (action:UIAlertAction!) -> Void in
                                                    //print("レビューする")
                                                    
                                                    if UIApplication.sharedApplication().canOpenURL(NSURL(string: self.app_store_url)!){
                                                        UIApplication.sharedApplication().openURL(NSURL(string: self.app_store_url)!)
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
        })
        
        
        
        
        
        
        //キャンセルボタン
        alert.addAction(cancelAction)
        alert.addAction(review)
        
        
        //表示。UIAlertControllerはUIViewControllerを継承している。
        presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
}

