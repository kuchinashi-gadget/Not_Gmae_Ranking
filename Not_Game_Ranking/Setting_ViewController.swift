//
//  Setting_ViewController.swift
//  Not_Game_Ranking
//


import UIKit

class Setting_ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    //UI
    var title_label = UILabel()
    var app_syubetu = UILabel()
    var game_syubetu = UILabel()
    var kuni_syubetu = UILabel()
    var view_label = UILabel()
    var syubetu_segment = UISegmentedControl()
    var view_segment = UISegmentedControl()
    //var game_segment = UISegmentedControl()
    var country_picker = UIPickerView()
    
    let segment_1:NSArray = ["iPhone","iPad"]
    let segment_2_jp:NSArray = ["テーブル表示","コレクション表示"]
    let segment_2_en:NSArray = ["Table_View","CollectionView"]
    
    
    //CSVファイルのデータを入れる配列
    var country_label_jp = [String()]
    var country_label_en = [String()]
    var country_code_label = [String()]
    
    //設定内容
    var country_no = 0
    var app_shyubetu_no = 0
    var category_no = 0
    var country_code = ""
    var view_no = 0
    
    //CSV_fileクラスのインスタンス
    let csv_read = CSV_file()
    let rws = read_or_write_setting()
    
    //NSUserDefaultsのインスタンスを生成
    //let defaults = NSUserDefaults.standardUserDefaults()
    
    //言語設定
    var language_str = ""
    var app_syubetu_str = ""
    var app_country_label_str = ""
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()
        
        read_language_setting()
        
        make_UI()
        
        read_setting()
        
        //ピッカーの再読み込み
        country_picker.reloadAllComponents()
        
        
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
        app_syubetu_str = NSLocalizedString("app_syubetu",comment:"アプリ種別")
        app_country_label_str = NSLocalizedString("app_country_label",comment:"appstoreの国")
        
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
        title_label.font = UIFont(name: "Arial", size: 15)
        title_label.textColor = moji_color
        title_label.textAlignment = NSTextAlignment.Center
        //title_label.backgroundColor = UIColor.whiteColor()
        if(language_str == "日本語"){
            title_label.text = "設定"
        }else{
            title_label.text = "Setting"
        }
        
        self.view.addSubview(title_label)
        
        //app種別
        tmp_x = Int(screenHight/100*5)
        tmp_y = Int(screenHight/100*15)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*5)
        app_syubetu.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        app_syubetu.font = UIFont(name: "Arial", size: 15)
        app_syubetu.textColor = moji_color
        app_syubetu.textAlignment = NSTextAlignment.Left
        app_syubetu.text = app_syubetu_str
        
        
        self.view.addSubview(app_syubetu)
        
        //選択肢
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*22)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int((screenHight)/100*5)
        
        // SegmentedControlを作成する.
        syubetu_segment = UISegmentedControl(items: segment_1 as [AnyObject])
        syubetu_segment.setTitleTextAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(10), forKey: NSFontAttributeName) as [NSObject : AnyObject], forState: UIControlState.Normal)
        syubetu_segment.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        syubetu_segment.selectedSegmentIndex = 0
        //syubetu_segment = syubetu_segment.selectedSegmentIndex
        
        
        // イベントを追加する.
        //syubetu_segment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(syubetu_segment)
        
        
        
        //viewの表示種別
        tmp_x = Int(screenHight/100*5)
        tmp_y = Int(screenHight/100*32)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*5)
        view_label.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        view_label.font = UIFont(name: "Arial", size: 15)
        view_label.textColor = moji_color
        view_label.textAlignment = NSTextAlignment.Left
        
        if(language_str == "日本語"){
            view_label.text = "表示形式"
        }else{
            view_label.text = "Display format"
        }
        
        
        self.view.addSubview(view_label)
        
        //選択肢
        tmp_x = Int(screenWidth/100*5)
        tmp_y = Int(screenHight/100*40)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int((screenHight)/100*5)
        
        // SegmentedControlを作成する.
        
        if(language_str == "日本語"){
            view_segment = UISegmentedControl(items: segment_2_jp as [AnyObject])
        }else{
            view_segment = UISegmentedControl(items: segment_2_en as [AnyObject])
        }
        
        view_segment.setTitleTextAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(10), forKey: NSFontAttributeName) as [NSObject : AnyObject], forState: UIControlState.Normal)
        view_segment.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        view_segment.selectedSegmentIndex = 0

        
        self.view.addSubview(view_segment)
        
        
//        //gameを表示するか
//        tmp_x = Int(screenHight/100*5)
//        tmp_y = Int(screenHight/100*32)
//        tmp_wight = Int(screenWidth)
//        tmp_hight = Int((screenHight)/100*5)
//        game_syubetu.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        game_syubetu.font = UIFont(name: "Arial", size: 15)
//        game_syubetu.textColor = moji_color
//        game_syubetu.textAlignment = NSTextAlignment.Left
//        game_syubetu.text = "Game app の表示"
//        self.view.addSubview(game_syubetu)
//        
//        //選択肢
//        tmp_x = Int(screenWidth/100*5)
//        tmp_y = Int(screenHight/100*40)
//        tmp_wight = Int(screenWidth/100*90)
//        tmp_hight = Int((screenHight)/100*5)
//        
//        // SegmentedControlを作成する.
//        game_segment = UISegmentedControl(items: segment_2_jp as [AnyObject])
//        game_segment.setTitleTextAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(10), forKey: NSFontAttributeName) as [NSObject : AnyObject], forState: UIControlState.Normal)
//        game_segment.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
//        game_segment.selectedSegmentIndex = 0
//        //syubetu_segment = syubetu_segment.selectedSegmentIndex
//        
//        //segment.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        // イベントを追加する.
//        //game_segment.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
//        
//        self.view.addSubview(game_segment)
        
        
        //g表示する国
        tmp_x = Int(screenHight/100*5)
        tmp_y = Int(screenHight/100*50)
        tmp_wight = Int(screenWidth)
        tmp_hight = Int((screenHight)/100*5)
        kuni_syubetu.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)
        kuni_syubetu.font = UIFont(name: "Arial", size: 15)
        kuni_syubetu.textColor = moji_color
        kuni_syubetu.textAlignment = NSTextAlignment.Left
        kuni_syubetu.text = app_country_label_str
        self.view.addSubview(kuni_syubetu)
        
        
        //国のpickerview
        tmp_x = Int(screenHight/100*5)
        tmp_y = Int(screenHight/100*60)
        tmp_wight = Int(screenWidth/100*90)
        tmp_hight = Int((screenHight)/100*40)
        country_picker.frame = CGRect(x:tmp_x, y:tmp_y, width:tmp_wight,height:tmp_hight)

        self.view.addSubview(country_picker)
        
        
        //pickervieのデリゲート
        country_picker.delegate = self
        country_picker.dataSource = self
        
    }
    
    /*
     pickerに表示する列数を返すデータソースメソッド.
     (実装必須)
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    /*
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return country_label_jp.count

    }
    
    // pickerに表示するUIViewを返す
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        let pickerLabel = UILabel()
        
        
        //日本語を表示する場合
        if(language_str == "日本語"){
            pickerLabel.text = country_label_jp[row] as! String
            pickerLabel.textColor = UIColor.whiteColor()
        }else{
            pickerLabel.text = country_label_en[row] as! String
            pickerLabel.textColor = UIColor.whiteColor()
        }
        
        pickerLabel.textAlignment = NSTextAlignment.Center

        
        return pickerLabel
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        print(row)
        print(country_label_jp[row])
        
        print(country_label_en[row])
        country_no = row

        
    }
    
    
    
    @IBAction func back_button_pushed(sender: AnyObject) {
        

        //設定の保存
        rws.write_setting(syubetu_segment.selectedSegmentIndex,category_no:category_no,country_no:country_no,view_no: view_segment.selectedSegmentIndex)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    func read_setting(){
        
        var tmp_array = csv_read.read_country_csv()
        country_label_jp = tmp_array.0
        country_label_en = tmp_array.1
        country_code_label = tmp_array.2
        

        var tmp = rws.read_setting()
        app_shyubetu_no = tmp.0
        category_no = tmp.1
        country_no = tmp.2
        view_no = tmp.3
        
        
        syubetu_segment.selectedSegmentIndex = app_shyubetu_no
        view_segment.selectedSegmentIndex = view_no
        country_picker.selectRow(country_no, inComponent: 0, animated:true)
        
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
