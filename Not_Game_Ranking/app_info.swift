//
//  app_info.swift
//  Not_Game_Ranking
//

import UIKit

class app_info: NSObject {
    
//    var app_iPhone_screenshot_flag = false
//    var app_iPad_screenshot_flag = false
    
    //広告フラグ
    var koukoku_flag = false
    var koukoku_no = 0
    
    
    var app_ranking_no = 0
    var app_name:String = ""
    var app_id:String = ""
    var app_jp_category = ""
    var app_en_category = ""
    var app_url = ""
    var app_icon_url = ""
    var app_price = 0.0
    var app_price_label = ""
    
    //アプリの大きなURL
    var app_icon_url_big = ""
    
    //アプリのスクリーンショットのURL
    var app_screenshot_image_url_iPhone = ["","","","",""]
    
    //アプリのスクリーンショットのURL
    var app_screenshot_image_url_iPad = NSArray()

    
    //評価レート
    var app_averageUserRatingForCurrentVersion = 0.0
    
    //評価数
    var userRatingCountForCurrentVersion = 0
    
    //アプリの説明
    var app_description = ""
    
    //アプリのituneURL
    var app_appstore_url = ""
    
    //アプリの作者
    var app_artistName = ""
    
    //アプリの作者のアプリ一覧
    var app_artistViewUrl = ""
    
    //アプリのサポートデバイス
    var app_support_device = NSArray()
    
    //iPhoneのスクリーンショットがあるフラグ
    var app_iPhone_screenshot_flag = false
    
    //iPadのスクリーンショットがあるフラグ
    var app_iPad_screenshot_flag = false
    
    


}
