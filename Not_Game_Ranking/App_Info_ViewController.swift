//
//  App_Info_ViewController.swift
//  Not_Game_Ranking


import UIKit
import Alamofire

class App_Info_ViewController: UIViewController {
    
    
    var app_no = ""
    var app_instance = app_info()
    var app_kakaku = ""
    
    var iPad_flag = false
    var iPhone_flag = false
    
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
    
    //CSV_fileクラスのインスタンス
    let csv_read = CSV_file()
    let rws = read_or_write_setting()
    let mu = Make_URL()
    
    //UI
    //button
    @IBOutlet weak var return_button: UIButton!
    var app_store_button = UIButton()
    var app_author_button = UIButton()
    var app_store_button2 = UIButton()
    
    
    
    
    //ラベル
    var app_title_label = UILabel()
    var app_author_label = UILabel()
    var app_review_count_label = UILabel()
    var app_setumei_label = UILabel()
    var app_category_label = UILabel()
    var app_category_label_2 = UILabel()
    var app_support_device_label = UILabel()
    var app_price_label = UILabel()
    
    
    //image
    var app_image = UIImageView()
    var app_review_image = UIImageView()
    var app_screenshot_image_1 = UIImageView()
    var app_screenshot_image_2 = UIImageView()
    var app_screenshot_image_3 = UIImageView()
    var app_screenshot_image_4 = UIImageView()
    var app_screenshot_image_5 = UIImageView()
    var app_screenshot_imageview_array: [UIImageView] = []

    
    //UITextView
    var setumei_text_field = UITextView()
    var support_device_label_field = UITextView()
    
    
    //セグメントコントローラー
    var segment = UISegmentedControl()
    let segment_array_ja = ["詳細","レビュー","関連"]
    let segment_array_en = ["Detail","Review","Relation"]
    
    //スクロールビュー
    var screenshot_scrollview = UIScrollView()
    
    
    //スクリーンショットのサイズ
    var screenshot_image_width = 0
    var screenshot_image_hight = 0
    var screenshot_image_top_sukima = 0
    
    //スクリーンショットを扱う配列
    var screenshot_image_count = 0
    var screenshot_image_array = NSArray()
    
    
    //インジケーター
    var myActivityIndicator: UIActivityIndicatorView!
    
    //言語設定
    var language_str = ""
    var category_str = ""
    var setumei_str = ""
    var support_device_str = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()

        read_language_setting()
        
        read_setting()
        
        //make_UI()
        
        print(app_no)
        // Do any additional setup after loading the view.
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
        
        make_UI()
        
        get_review(app_instance)
        
        //write_UI()
        
        
    }

    
    func read_language_setting(){
        
        language_str = NSLocalizedString("language",comment:"言語")
        category_str = NSLocalizedString("category",comment:"カテゴリ")
        setumei_str = NSLocalizedString("app_setumei_label",comment:"説明")
        support_device_str = NSLocalizedString("app_support_device_label",comment:"サポートデバイス")
        
    }

    
    
    @IBAction func return_button_pushed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func get_review(app_info_instance:app_info){
        
        let tmp_app_id = app_info_instance.app_id
        
        let requestUrl = mu.make_review_url(tmp_app_id)
        
        print(requestUrl)
        
    
        //let requestUrl = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + tmp_app_id + "&entity=software&country=jp"
        
        
        //if(app_info_instance.app_artistViewUrl == ""){
        if(true){
            
            // インジケータを表示にする
            start_Indicator()
            
            //取得されていないので再取得する
            Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
                
                if let json = response.result.value {
                    
                    
                    var jsonDic = json as! NSDictionary
                    let responseData1 = jsonDic["results"] as! NSArray
                    
                    
                    
                    for tmp in responseData1 {
                    
                        var tmp_str = String(tmp)
                        var responseData2 = 0.0
                        //評価レート
                        if(tmp_str.containsString("averageUserRatingForCurrentVersion")){
                            responseData2 = tmp["averageUserRatingForCurrentVersion"] as! Double
                        }else{
                            responseData2 = 0.0
                        }
                        app_info_instance.app_averageUserRatingForCurrentVersion = responseData2
                        
                        
                        //評価数
                        var responseData3 = 0
                        if(tmp_str.containsString("userRatingCountForCurrentVersion")){
                            responseData3 = tmp["userRatingCountForCurrentVersion"] as! Int
                        }else{
                            responseData3 = 0
                        }
                        app_info_instance.userRatingCountForCurrentVersion = responseData3
                        
                        
                        //アプリのアイコンの大きいURL
                        var responseData4 = ""
                        if(tmp_str.containsString("artworkUrl512")){
                            responseData4 = tmp["artworkUrl512"] as! String
                        }else{
                            responseData4 = ""
                        }
                        app_info_instance.app_icon_url_big = responseData4
                        
                        //スクリーンショットのURL(iPhone)
                        var responseData5 = NSArray()
                        if(tmp_str.containsString("screenshotUrls")){
                            responseData5 = tmp["screenshotUrls"] as! NSArray
                            app_info_instance.app_screenshot_image_url_iPhone = responseData5 as! [String]
                            
                        }else{
                            responseData5 = NSArray()
                        }
                        
                        //スクリーンショットのURL(iPad)
                        responseData5 = NSArray()
                        if(tmp_str.containsString("ipadScreenshotUrls")){
                            responseData5 = tmp["ipadScreenshotUrls"] as! NSArray
                            app_info_instance.app_screenshot_image_url_iPad = responseData5 as! [String]
                        }else{
                            responseData5 = NSArray()
                        }
                        
                        
                        //アプリの説明
                        responseData4 = ""
                        if(tmp_str.containsString("description")){
                            responseData4 = tmp["description"] as! String
                        }else{
                            responseData4 = ""
                        }
                        app_info_instance.app_description = responseData4
                        
                        
                        //appstoreのURL
                        responseData4 = ""
                        if(tmp_str.containsString("trackViewUrl")){
                            responseData4 = tmp["trackViewUrl"] as! String
                        }else{
                            responseData4 = ""
                        }
                        app_info_instance.app_appstore_url = responseData4
                        
                        //開発者の名前
                        responseData4 = ""
                        if(tmp_str.containsString("artistName")){
                            responseData4 = tmp["artistName"] as! String
                        }else{
                            responseData4 = ""
                        }
                        app_info_instance.app_artistName = responseData4
                        
                        //開発者のアプリのURL
                        responseData4 = ""
                        if(tmp_str.containsString("artistViewUrl")){
                            responseData4 = tmp["artistViewUrl"] as! String
                        }else{
                            responseData4 = ""
                        }
                        app_info_instance.app_artistViewUrl = responseData4
                        
                        
                        //アプリのサポートデバイス
                        responseData5 = NSArray()
                        if(tmp_str.containsString("supportedDevices")){
                            responseData5 = tmp["supportedDevices"] as! NSArray
                        }else{
                            responseData5 = NSArray()
                        }
                        app_info_instance.app_support_device = responseData5 as! [String]
                        
                        
                    }
                    
                    
                }
                
                // インジケータを非表示にする
                //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.stop_Indicator()
                
                //UIの再表示
                self.write_UI()
                //self.write_UI()

            }

            
        }else{
            //すでにデータ取得済みなので、
            //UIの再表示
            write_UI()
            
        }

        

        
    }
    
    func make_UI(){
        
        let screenWidth:Double = Double(UIScreen.mainScreen().bounds.size.width)
        let screenHight:Double = Double(UIScreen.mainScreen().bounds.size.height) - 50
        let moji_color:UIColor = UIColor.whiteColor()
        
        //アプリ名
        var tmp_x = Int(screenWidth/100*40)
        var tmp_y = Int(screenHight/100*12)
        var tmp_wight = Int(screenWidth/100*60)
        var tmp_hight = Int((screenHight)/100*15)
        app_title_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_title_label.font = UIFont(name: "Arial", size: 17)
        app_title_label.textColor = moji_color
        app_title_label.numberOfLines = 3
        app_title_label.textAlignment = NSTextAlignment.Left
        //app_title_label.text = "アプリの名前\nアプリの名前"
        self.view.addSubview(app_title_label)
        
        //アプリアイコン
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*12)
        tmp_wight = Int(screenWidth/100*60)
        tmp_hight = Int((screenHight)/100*20)
        if(tmp_wight>tmp_hight){
            
            tmp_wight = tmp_hight
            
        }else{
            tmp_hight = tmp_wight
        }
        app_image.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        //マスク処理
        app_image.layer.masksToBounds = true
        app_image.layer.cornerRadius = 10.0

        self.view.addSubview(app_image)
        
        //アプリ作者
        tmp_x = Int(screenWidth/100*40)
        tmp_y = Int(screenHight/100*27)
        tmp_wight = Int(screenWidth/100*60)
        tmp_hight = Int((screenHight)/100*5)
        app_author_button.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        //app_author_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        app_author_button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        //app_author_button.setTitle("アプリの作者", forState: UIControlState.Highlighted)
        app_author_button.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        app_author_button.titleLabel?.font = UIFont.systemFontOfSize(12)
        app_author_button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        // イベントを追加する.
        app_author_button.addTarget(self, action: "app_button_pushed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(app_author_button)
        
        
        //アプリの評価レート
        tmp_x = Int(screenWidth/100*40)
        tmp_y = Int(screenHight/100*32)
        //tmp_wight = Int(screenWidth/100*60)
        tmp_hight = Int((screenHight)/100*2)
        tmp_wight = Int(tmp_hight*130/25)

        app_review_image.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        self.view.addSubview(app_review_image)
        
        
        //アプリの評価数
        tmp_x = Int(tmp_x + tmp_wight)
        tmp_y = Int(screenHight/100*32)
        tmp_wight = Int(screenWidth) - tmp_x
        tmp_hight = Int((screenHight)/100*2)
        app_review_count_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_review_count_label.font = UIFont(name: "Arial", size: 8)
        app_review_count_label.textColor = moji_color
        app_review_count_label.numberOfLines = 0
        app_review_count_label.textAlignment = NSTextAlignment.Left
        //app_review_count_label.text = "(1000)"
        self.view.addSubview(app_review_count_label)
        
        
        //Appstoreボタン
        tmp_x = Int(screenWidth/100*75)
        tmp_y = Int(screenHight/100*23)
        tmp_wight = Int(screenWidth/100*20)
        tmp_hight = Int((screenHight)/100*5)
        app_store_button.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        
        // 枠を丸くする.
        app_store_button.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        app_store_button.setTitle("App Store", forState: UIControlState.Normal)
        app_store_button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        app_store_button.setTitle("App Store", forState: UIControlState.Highlighted)
        app_store_button.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        
        app_store_button.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(12))
        
        // コーナーの半径を設定する.
        app_store_button.layer.cornerRadius = 8.0
        
        //枠線の色の設定
        app_store_button.layer.borderColor = UIColor.blueColor().CGColor
        
        //枠線の太さの設定
        app_store_button.layer.borderWidth = 2
        
        
        // タグを設定する.
        app_store_button.tag = 1
        
        // イベントを追加する.
        app_store_button.addTarget(self, action: "app_store_button_pushed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(app_store_button)
        
        
        //価格
        tmp_x = Int(screenWidth/100*75)
        tmp_y = Int(screenHight/100*30)
        tmp_wight = Int(screenWidth/100*20)
        tmp_hight = Int((screenHight)/100*10)
        app_price_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_price_label.font = UIFont(name: "Arial", size: 20)
        app_price_label.textColor = moji_color
        app_price_label.numberOfLines = 0
        app_price_label.textAlignment = NSTextAlignment.Center
        //app_price_label.text = "¥120"
        self.view.addSubview(app_price_label)
        
        
//        //選択肢
//        tmp_x = Int(screenWidth/100*10)
//        tmp_y = Int(screenHight/100*35)
//        tmp_wight = Int(screenWidth/100*80)
//        tmp_hight = Int((screenHight)/100*5)
//        
//
//        
//        // SegmentedControlを作成する.
//        segment = UISegmentedControl(items: segment_array_ja as [AnyObject])
//        segment.setTitleTextAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(10), forKey: NSFontAttributeName) as [NSObject : AnyObject], forState: UIControlState.Normal)
//        segment.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        segment.selectedSegmentIndex = 0
////        syubetu_flag = segment.selectedSegmentIndex
//        
//        
//        // イベントを追加する.
//        segment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
//        
//        self.view.addSubview(segment)
        
        //スクリーンショットを貼るスクロールview
        tmp_x = Int(screenWidth/100*0)
        tmp_y = Int(screenHight/100*42)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int(1136/3 + 20)

        screenshot_scrollview.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        
        // スクロール内の領域を設定
        //screenshot_scrollview.contentSize = CGSizeMake(630/3*5 + 10*4,400)
        //screenshot_scrollview.backgroundColor = UIColor.redColor()
        
        // 初期表示に表示する位置を設定
        screenshot_scrollview.contentOffset = CGPointMake(0, 0);
        
        screenshot_scrollview.pagingEnabled = true
        screenshot_scrollview.scrollEnabled = true
        screenshot_scrollview.bounces = true
        screenshot_scrollview.showsHorizontalScrollIndicator = true
        
        // スクロールバーのスタイルを設定
        screenshot_scrollview.indicatorStyle = UIScrollViewIndicatorStyle.Black
        screenshot_scrollview.layer.borderColor = UIColor.grayColor().CGColor
        screenshot_scrollview.layer.borderWidth = 0.5
        
        self.view.addSubview(screenshot_scrollview)
        
//        tmp_x = Int(screenWidth/100*0)
//        tmp_y = Int(10)
//        tmp_wight = Int(630/3)
//        tmp_hight = Int(1136/3)
//        app_screenshot_image_1.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        
//        
//        screenshot_scrollview.addSubview(app_screenshot_image_1)
        
        
//        tmp_x = Int(630/3 + 10)
//        tmp_y = Int(10)
//        tmp_wight = Int(630/3)
//        tmp_hight = Int(1136/3)
//        app_screenshot_image_2.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        
//        
//        screenshot_scrollview.addSubview(app_screenshot_image_2)
//        
//        tmp_x = Int(630/3*2 + 10*2)
//        tmp_y = Int(10)
//        tmp_wight = Int(630/3)
//        tmp_hight = Int(1136/3)
//        app_screenshot_image_3.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        screenshot_scrollview.addSubview(app_screenshot_image_3)
//        
//        tmp_x = Int(630/3*3 + 10*3)
//        tmp_y = Int(10)
//        tmp_wight = Int(630/3)
//        tmp_hight = Int(1136/3)
//        app_screenshot_image_4.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        screenshot_scrollview.addSubview(app_screenshot_image_4)
//        
//        
//        
//        tmp_x = Int(630/3*4 + 10*4)
//        tmp_y = Int(10)
//        tmp_wight = Int(630/3)
//        tmp_hight = Int(1136/3)
//        app_screenshot_image_5.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        screenshot_scrollview.addSubview(app_screenshot_image_5)
        
    
        
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*42 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*95)
        tmp_hight = Int(screenHight/100*5)
        app_setumei_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        
        app_setumei_label.font = UIFont(name: "Arial", size: 20)
        app_setumei_label.textColor = moji_color
        app_setumei_label.numberOfLines = 0
        app_setumei_label.textAlignment = NSTextAlignment.Left
        app_setumei_label.text = setumei_str
        self.view.addSubview(app_setumei_label)
        
        
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*50 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int(screenHight/100*50)
        setumei_text_field.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        setumei_text_field.editable = false
        setumei_text_field.textColor = UIColor.whiteColor()
        setumei_text_field.backgroundColor = UIColor.blackColor()
//        setumei_text_field.text = "～ 讃岐の大衆セルフの「美味しさ」と「ぬくもり」と「楽しさ」を。 ～\n\n本アプリケーションは、株式会社トリドールが提供する「丸亀製麺公式アプリ」です。\n\nお得なクーポンやフェア情報を無料でお届けします。今だけの初回ダウンロードの特別クーポンもプレゼント中！\n\nまた、いつでも「今いる場所」から最寄りの店舗を見つけることができます。\n\n「打ちたて」「茹でたて」「締めたて」の「できたて」にこだわった本場讃岐うどんを、是非お近くの丸亀製麺でお楽しみください。\n\n【主な機能】\n・クーポン利用\n　丸亀製麺で使える、お得なクーポンをお届けします。クーポンには”うどん”や”てんぷら”など多くの種類があります。\n\n･ クーポン獲得\n　丸亀製麺のレシートに印字されたQRコードを読み込んで、お得なクーポンを獲得することができます（QRコードは丸亀製麺公式アプリで読み込む必要があります。）\n\n･ 近くのお店を探す\n　端末の現在地から最寄りの店舗を検索し、いつでも丸亀製麺を探すことができます。\n\n･ フェア情報\n　丸亀製麺で開催中のフェア情報を表示します。また、店舗限定のフェア情報を表示します。\n\n【対応端末】\n･ iOS 7以上のiPhone, iPod touchを対象としています(端末によっては、一部機能が正常に動作しない場合があります)\n･ iPadシリーズはサポート対象外とさせていただきます(コンテンツによってはレイアウトが崩れる場合があります)\n\n【注意事項】\n･ 本アプリケーションは、モバイルネットワーク、またはWi-Fiを利用して最新のフェア情報や店舗情報、現在地を表示します。\n　アプリケーション起動時にネットワーク接続できない場合は、最新の情報が表示されない場合や、正しい現在地が表示されない場合があります。\n･ 実際の店舗で取り扱っているメニュー内容、価格と、本アプリケーション内コンテンツのメニュー内容、価格とは異なる場合があります\n\n【アクセス権限】\n･ 近くの店舗を検索するために端末の位置情報を使用します。\n･ 最新の店舗情報やフェア情報をダウンロードするためにネットワーク通信をします。"
        
        self.view.addSubview(setumei_text_field)
        
        
        //カテゴリーのラベル
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*110 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*95)
        tmp_hight = Int(screenHight/100*5)
        app_category_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_category_label.font = UIFont(name: "Arial", size: 20)
        app_category_label.textColor = moji_color
        app_category_label.numberOfLines = 0
        app_category_label.textAlignment = NSTextAlignment.Left
        app_category_label.text = category_str
        self.view.addSubview(app_category_label)
        
        //カテゴリー
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*115 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*95)
        tmp_hight = Int(screenHight/100*5)
        app_category_label_2.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_category_label_2.font = UIFont(name: "Arial", size: 15)
        app_category_label_2.textColor = moji_color
        app_category_label_2.numberOfLines = 0
        app_category_label_2.textAlignment = NSTextAlignment.Left
        //app_category_label_2.text = "カテゴリー"
        self.view.addSubview(app_category_label_2)
        
        //サポートデバイスのラベル
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*125 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*95)
        tmp_hight = Int(screenHight/100*5)
        app_support_device_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_support_device_label.font = UIFont(name: "Arial", size: 20)
        app_support_device_label.textColor = moji_color
        app_support_device_label.numberOfLines = 0
        app_support_device_label.textAlignment = NSTextAlignment.Left
        app_support_device_label.text = support_device_str
        self.view.addSubview(app_support_device_label)
        
        //サポートデバイスのテキスト
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*130 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int(screenHight/100*30)
        support_device_label_field.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        support_device_label_field.editable = false
        support_device_label_field.textColor = UIColor.whiteColor()
        support_device_label_field.backgroundColor = UIColor.blackColor()
        self.view.addSubview(support_device_label_field)
        
        
        //appstorebutton2
        tmp_x = Int(screenWidth/100*10)
        tmp_y = Int(screenHight/100*170 + 1136/3 + 20 + 10)
        tmp_wight = Int(screenWidth/100*80)
        tmp_hight = Int((screenHight)/100*10)
        app_store_button2.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        
        // 枠を丸くする.
        app_store_button2.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        app_store_button2.setTitle("Go App Store!!", forState: UIControlState.Normal)
        app_store_button2.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        app_store_button2.setTitle("GO App Store!!", forState: UIControlState.Highlighted)
        app_store_button2.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        
        app_store_button2.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(12))
        
        // コーナーの半径を設定する.
        app_store_button2.layer.cornerRadius = 8.0
        
        //枠線の色の設定
        app_store_button2.layer.borderColor = UIColor.blueColor().CGColor
        
        //枠線の太さの設定
        app_store_button2.layer.borderWidth = 2
        
        
        // タグを設定する.
        app_store_button2.tag = 2
        
        // イベントを追加する.
        app_store_button2.addTarget(self, action: "app_store_button_pushed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(app_store_button2)
        

        

    }
    
    func write_UI(){
        
        
        var tmp_str = app_instance.app_description
        
        
        if(tmp_str != ""){
        
            let screenWidth:Double = Double(UIScreen.mainScreen().bounds.size.width)
            let screenHight:Double = Double(UIScreen.mainScreen().bounds.size.height) - 50
            

            
            //アプリ名
            app_title_label.text = app_instance.app_name
            
            //評価レート
            if(app_instance.app_averageUserRatingForCurrentVersion == 0.0){
                
                
                app_review_image.hidden = true
                
            }else{
                
                var tmp = Int(app_instance.app_averageUserRatingForCurrentVersion * 10)
                var tmp_name = "hyouka_" + String(tmp)
                app_review_image.image = UIImage(named:tmp_name)
                app_review_image.hidden = false
            
            }
            
            //評価数
            if(app_instance.userRatingCountForCurrentVersion == 0){
                
                app_review_count_label.text = ""
                //cell!.hyoukasu_label.text = "(100)"
                
            }else{
                var tmp_hyoukasu = "【" + String(app_instance.userRatingCountForCurrentVersion)
                tmp_hyoukasu = tmp_hyoukasu + "】"
                app_review_count_label.text = tmp_hyoukasu
                //cell!.hyoukasu_label.text = "(100)"
            }
            
            //価格
            var tmp_app_price = app_instance.app_price
            
            if(tmp_app_price == 0){
                
                app_price_label.hidden = true
                
            }else{
                
                app_price_label.hidden = false
                app_price_label.text = app_instance.app_price_label
                
            }
            
            
            //アプリURL
            
            var tmp_app_icon_url = app_instance.app_icon_url_big
            print(tmp_app_icon_url)
            
            if(tmp_app_icon_url != ""){
            
                var url = NSURL(string:tmp_app_icon_url)
                var req = NSURLRequest(URL:url!)
                
                NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                    let image = UIImage(data:data!)
                    self.app_image.image  = image
                    
                }
            }
            
            //iPhoneの場合
            if(app_shyubetu_no == 0){
                
                screenshot_image_count = app_instance.app_screenshot_image_url_iPhone.count
                screenshot_image_array = app_instance.app_screenshot_image_url_iPhone
                
            }else{
                
                screenshot_image_count = app_instance.app_screenshot_image_url_iPad.count
                screenshot_image_array = app_instance.app_screenshot_image_url_iPad
                
            }
            
            
            print("スクリーンショットのURLの数")
            print(screenshot_image_count)
            
            //スクリーンショットを表示する箱を作る
            if (screenshot_image_count >= 1){
                
                //スクリーンショット
                var tmp_app_screenshot_image_1_url = screenshot_image_array[0]
                var url = NSURL(string:tmp_app_screenshot_image_1_url as! String)
                var req = NSURLRequest(URL:url!)
                
                NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                    let image = UIImage(data:data!)
                    let width = image?.size.width
                    let height = image?.size.height
                    
                    print("画像の大きさの表示")
                    print("width:"+String(width))
                    print("height:"+String(height))
                    
                    if(width<height){
                        
                        self.screenshot_image_width = Int(width!/3)
                        self.screenshot_image_hight = Int(height!/3)
                    }else{
                        self.screenshot_image_width = Int(width!)
                        self.screenshot_image_hight = Int(height!)
                        
                    }
                    
                    self.screenshot_image_top_sukima = (Int(1136/3 + 20) - self.screenshot_image_hight) / 2
                    
                    
                    //スクロールviewの大きさを再定義
                    var screenshot_scrollview_width = CGFloat(self.screenshot_image_width * self.screenshot_image_count + 10 * (self.screenshot_image_count - 1))
                    var screenshot_scrollview_hight = CGFloat(self.screenshot_image_hight + 20)
                    self.screenshot_scrollview.contentSize = CGSizeMake(screenshot_scrollview_width,screenshot_scrollview_hight)
                    
                    
                    //imageviewの再定義
                    for var i=0;i<self.screenshot_image_count;i++ {
                        
                        var tmp_x = Int(self.screenshot_image_width*i + 10*i)
                        var tmp_y = Int(self.screenshot_image_top_sukima)
                        var tmp_wight = self.screenshot_image_width
                        var tmp_hight = self.screenshot_image_hight
                        self.app_screenshot_imageview_array[i].frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
                        //self.app_screenshot_imageview_array[i].backgroundColor = UIColor.redColor()
                        self.screenshot_scrollview.addSubview(self.app_screenshot_imageview_array[i])
                    
                        
                    }
                    
                    print("画像の設定終了")
                    
                    self.write_screenshot()

                }
            }

            
            //カテゴリー
            //日本語の場合
            if(language_str == "日本語"){
                app_category_label_2.text = app_instance.app_jp_category
                
            }else{
                app_category_label_2.text = app_instance.app_en_category
            }
            
            
            //説明
            setumei_text_field.text = app_instance.app_description
            
            //アプリの作者名
            //app_author_label.text = app_instance.app_artistName
            
            //アプリの
            app_author_button.setTitle(app_instance.app_artistName, forState: UIControlState.Normal)
            app_author_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            // タイトルを設定する(ボタンがハイライトされた時).
            app_author_button.setTitle(app_instance.app_artistName, forState: UIControlState.Highlighted)
            app_author_button.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
            
            app_author_button.titleLabel?.textAlignment = NSTextAlignment.Left
            
            
            //アプリのサポートデバイス
            var tmp_array = app_instance.app_support_device
            
            
            var tmp_str = ""
            
            for tmp in tmp_array{
                
                tmp_str = tmp_str + "  " + (tmp as! String)
                
                
            }
            
            support_device_label_field.text = tmp_str
            
            
        }else{
            
            
            var alert_title_str = ""
            var alert_message_str = ""
            var alert_OK_str = ""
            
            if(language_str == ""){
                
                alert_title_str = "このアプリは無効です"
                alert_message_str = "このアプリは現在利用できません。"
                alert_OK_str = "OK"
                
                
            }else{
                
                alert_title_str = "Item Not Available"
                alert_message_str = "The item you've requested is not currently available."
                alert_OK_str = "OK"
                
                
            }
            
            
            //UIAlertView
            let alert:UIAlertController = UIAlertController(title:alert_title_str,
                                                            message: alert_message_str,
                                                            preferredStyle: UIAlertControllerStyle.Alert)
            
            
            //
            let OK:UIAlertAction = UIAlertAction(title: alert_OK_str,
                                                     style: UIAlertActionStyle.Default,
                                                     handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        
                                                        self.dismissViewControllerAnimated(true, completion: nil)
                                                        
                                                        
                                         

                                                        
            })
            
            
            
            
            //キャンセルボタン
            //alert.addAction(cancelAction)
            alert.addAction(OK)
            
            
            //表示。UIAlertControllerはUIViewControllerを継承している。
            presentViewController(alert, animated: true, completion: nil)
            
            
            
        }
        
        
    }
    
    func write_screenshot(){
        
        //print("スクリーンショットの画像表示")
        
        if(screenshot_image_array.count>=1){
        
            let tmp_app_screenshot_image_url = screenshot_image_array[0]
            print(tmp_app_screenshot_image_url)
            let url = NSURL(string:tmp_app_screenshot_image_url as! String)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.app_screenshot_image_1.image = image
                
            }
        }
        
        if(screenshot_image_array.count>=2){
            let tmp_app_screenshot_image_url = screenshot_image_array[1]
            //print(tmp_app_screenshot_image_url)
            let url = NSURL(string:tmp_app_screenshot_image_url as! String)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.app_screenshot_image_2.image = image
                
            }
        }
        
        if(screenshot_image_array.count>=3){
            let tmp_app_screenshot_image_url = screenshot_image_array[2]
            //print(tmp_app_screenshot_image_url)
            let url = NSURL(string:tmp_app_screenshot_image_url as! String)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.app_screenshot_image_3.image = image
                
            }
        }
        
        if(screenshot_image_array.count>=4){
            let tmp_app_screenshot_image_url = screenshot_image_array[3]
            //print(tmp_app_screenshot_image_url)
            let url = NSURL(string:tmp_app_screenshot_image_url as! String)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.app_screenshot_image_4.image = image
                
            }
        }
        
        if(screenshot_image_array.count>=5){
            let tmp_app_screenshot_image_url = screenshot_image_array[4]
            //print(tmp_app_screenshot_image_url)
            let url = NSURL(string:tmp_app_screenshot_image_url as! String)
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.app_screenshot_image_5.image = image
                
            }
        }

        
        
        
    }
    
    func app_store_button_pushed(sender: UIButton){
        
        print("app_store_button_pushed")
        
        //let itunesURL:String = "itms-apps://itunes.apple.com/app/XXXXX"
        
        let itunesURL:String = app_instance.app_appstore_url
        let url = NSURL(string:itunesURL)
        let app:UIApplication = UIApplication.sharedApplication()
        app.openURL(url!)
        
    }
    
    
    //作者を押された時のアクション
    func app_button_pushed(sender: UIButton){
        
        ////itms-apps:itunes.apple.com/jp/developer/oh-nam-kwon/id490468388?uo=4
        
        print(app_instance.app_artistViewUrl)
        
        var tmp = app_instance.app_artistViewUrl
        
        print(tmp)
        
        let itunesURL:String = tmp
        let url = NSURL(string:itunesURL)
        let app:UIApplication = UIApplication.sharedApplication()
        app.openURL(url!)
    
    
    }
    
//    func segconChanged(segcon: UISegmentedControl){
//        
//        
//        print("segconChanged")
//        
//        
//    }
    
    
    func read_setting(){
        
        app_screenshot_imageview_array = [app_screenshot_image_1,app_screenshot_image_2,app_screenshot_image_3,app_screenshot_image_4,app_screenshot_image_5]
        
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
        
        //iPhoneかiPad表示の選択
        
        //設定ではiPhoneのとき
        if(app_shyubetu_no == 0){
            
            
            //iPhoneのスクリーンショットがない場合iPadで表示
            if(!iPhone_flag){
                
                app_shyubetu_no = 1
                
            }
    
        }
        
        //設定ではiPadのとき
        if(app_shyubetu_no == 1){
            
            
            //iPadのスクリーンショットがない場合iPhoneで表示
            if(!iPad_flag){
                
                app_shyubetu_no = 0
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
