//
//  Get_Json.swift
//  Not_Game_Ranking
//


import UIKit
import Alamofire

class Get_Json: NSObject {
    
    
    func get_ranking(requestUrl:String) -> [app_info]{
        
        var app_info_instance_array = [app_info]()
        
        
        
        //Webサーバに対してHTTP通信のリクエストを出してデータを取得
        Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
            
            if let json = response.result.value {
                
                
                //まずJSONデータをNSDictionary型に
                var jsonDic = json as! NSDictionary
                
                //辞書化したjsonDicからキー値"responseData"を取り出す
                let responseData1 = jsonDic["feed"] as! NSDictionary
                
                let array1 = responseData1["entry"] as! NSArray
                
                for tmp in array1 {
                    //print("ランキングを取得")
                    
                    //app_infoクラスのインスタンスを作成
                    let app_instance = app_info()
                    
                
                    var responseData2 = tmp["category"] as! NSDictionary
                    var responseData3 = responseData2["attributes"] as! NSDictionary
                    let tmp_jp_category = responseData3["label"] as! String
                    let tmp_en_category = responseData3["term"] as! String
                    
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
                    
                    
//                    responseData2 = tmp["im:price"] as! NSDictionary
//                    responseData3 = responseData2["attributes"] as! NSDictionary
//                    var tmp_price = responseData3["amount"]as! String
//                    app_instance.app_price = tmp_price
                    //print(tmp_price)
                    
                    responseData2 = tmp["im:name"] as! NSDictionary
                    var tmp_app_name = responseData2["label"] as! String
                    //print(tmp_app_name)
                    app_instance.app_name = tmp_app_name
                    
                    print(tmp_app_name)
                    //app_incetanceを配列に追加
                    app_info_instance_array.append(app_instance)
                    

                }
                //終わる処理
                
                print("リクエスと完了1")
            }
            
            print("リクエスと完了2")
        }
        
        //print("リクエスと完了3")
        
        return app_info_instance_array
    }
    
    
    
    func get_user_rating(app_info_instance:app_info){
        
        var tmp_app_id = app_info_instance.app_id
        
        let requestUrl = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + tmp_app_id + "&entity=software&country=jp"
        
        Alamofire.request(.GET, requestUrl, parameters: nil,encoding: .JSON).responseJSON { response in
            
            if let json = response.result.value {
                
                var jsonDic = json as! NSDictionary
                let responseData1 = jsonDic["results"] as! NSArray
                
                
                for tmp in responseData1 {
                    
//                    
//                    let responseData2 = tmp["averageUserRatingForCurrentVersion"] as! Int
//                    app_info_instance.app_averageUserRatingForCurrentVersion = responseData2
//                    
//                    let responseData3 = tmp["userRatingCountForCurrentVersion"] as! Int
//                    app_info_instance.userRatingCountForCurrentVersion = responseData3
//                    print(responseData3)
                
                    
                }
                
                
            }
        
        
        }
    }
    

}