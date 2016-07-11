//
//  CategoryViewController.swift
//  Not_Game_Ranking
//


import UIKit

class CategoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var return_button: UIButton!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var title_label: UILabel!
    
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
    
    //CSV_fileクラスのインスタンス
    let csv_read = CSV_file()
    let rws = read_or_write_setting()
    
    var language_str = ""
    var category_message_str = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()

        print("CategoryViewController")
        
        read_language_setting()

        //デリゲートの設定
        table_view.delegate = self
        table_view.dataSource = self
        table_view.backgroundColor = UIColor.blackColor()
        
        title_label.text = category_message_str
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("1stViewController's viewDidAppear() is called")
        
        
        read_setting()
        
        table_view.reloadData()
        
        
        
    }
    
    func read_language_setting(){
        
        language_str = NSLocalizedString("language",comment:"言語")
        category_message_str = NSLocalizedString("category_message",comment:"言語")
        
        
    }
    
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
        
        
        print("######")
        print(category_no)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func return_button_pushed(sender: AnyObject) {
        
        back_view()
    
    }
    
    func back_view(){
        
        //設定の保存
        rws.write_setting(app_shyubetu_no,category_no:category_no,country_no:country_no,view_no: view_no)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 表示セルを返却するデリゲート先
    func tableView(table_view: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCellWithIdentifier("Cell" ,forIndexPath: indexPath)
        //        var cell = table_view.dequeueReusableCellWithIdentifier("Cell") as? SetteingTableViewCell
        
        let category_label = cell.viewWithTag(1) as! UILabel
        var select_image = cell.viewWithTag(3) as! UIImageView
        
        if(language_str == "日本語"){
            
            category_label.text = category_label_jp[indexPath.row]
            
        }else{
            
            category_label.text = category_label_en[indexPath.row]
            
        }
        
        
        if(category_no == indexPath.row){
            
            select_image.hidden = false
            
            // 表示する画像を設定する.
            let myImage = UIImage(named: "check")
            
            // 画像をUIImageViewに設定する.
            select_image.image = myImage
            
        }else{
            
            select_image.hidden = true
            select_image.image = nil
            
        }
        
        
        return cell
    }
    
    //せるの高さ
    func tableView(table_view: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 60
    }
    

    
    // Table Viewのセルの数を指定
    func tableView(table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category_label_jp.count
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        print(indexPath.row)
        category_no = indexPath.row
        
        var tmp_message = category_label_jp[category_no]
        table_view.reloadData()
        
        back_view()
        
        
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
