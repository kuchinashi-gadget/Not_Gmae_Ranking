//
//  Make_URL.swift
//  Not_Game_Ranking
//


import UIKit

class Make_URL: NSObject {
    
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
    
    
    func make_randam_ranking_URL(wf:Int) ->(String){
        
        read_setting()
        
        app_shyubetu_no =  Int(arc4random() % 2)
        
        var ranking_shubetu = Int(arc4random() % 3)
        var category_no = Int(arc4random() % 24 + 1)
        
        if (category_no == 5){
            
            category_no = 8
        }
        
        //var country_no = 0
        
        //世界中のアプリをランダムで表示する場合
        if(wf == 0){
            country_no = Int(arc4random() % 152)
        }
        
        
        
        var tmp_url = ""
        var tmp_ranking_url = ""
        
        //有料アプリランキング
        if(ranking_shubetu == 0){
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                
                tmp_ranking_url = "toppaidapplications"
                
                //iPadランキング
            }else{
                tmp_ranking_url = "toppaidipadapplications"
                
            }
            
            //無料アプリランキング
        }else if(ranking_shubetu == 1){
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                tmp_ranking_url = "topfreeapplications"
                
                //iPadランキング
            }else{
                tmp_ranking_url = "topfreeipadapplications"
                
            }
            
            //トップセールスランキング
        }else{
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                tmp_ranking_url = "topgrossingapplications"
                
                //iPadランキング
            }else{
                tmp_ranking_url = "topgrossingipadapplications"
                
                
            }
            
        }
        
        var tmp_country_url = country_code_label[country_no]
        var tmp_category_url = category_code_label[category_no]
        
        
        
        
        tmp_url = "https://itunes.apple.com/"+tmp_country_url+"/rss/" + tmp_ranking_url + "/limit=200/"
        
        if(category_no > 2){
            
            tmp_url = tmp_url  + category_code_label[category_no] + "/"
        }
    
        tmp_url = tmp_url + "json"
        
        
        return tmp_url
    }
    
    func make_randam_new_URL(wf:Int) -> (String){
        
        read_setting()
        
        //var tmp_no1 = 0
        //世界中のアプリをランダムで表示する場合
        if(wf == 0){
            country_no = Int(arc4random() % 152)
        }
        
        var tmp_no2 = Int(arc4random() % 2)
        

        
        var tmp_url = ""
        var tmp_shyubetu_url = ""
        var tmp_country_url = country_code_label[country_no]
        
        if(tmp_no2 == 0){
            
            tmp_shyubetu_url = "newapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }else if(tmp_no2 == 1){
            
            tmp_shyubetu_url = "newpaidapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }else if(tmp_no2 == 2){
            
            tmp_shyubetu_url = "newfreeapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }
        
        tmp_url = "https://itunes.apple.com/" + tmp_country_url + "/rss/" + tmp_shyubetu_url + "/limit=200/json"
        
        
        return tmp_url
    }
    
    
//    func make_review_url(app_id:String) ->(String){
//        
//        read_setting()
//        
//        var tmp_country_url = country_code_label[country_no]
//        
//        let tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software&country=" + tmp_country_url
//        
//        return tmp_url
//        
//    }
    
//    func make_review_url3(app_id:String) ->(String){
//        
//        read_setting()
//        
//        var tmp_country_url = country_code_label[country_no]
//        
//        let tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software"
//        
//        return tmp_url
//        
//    }
    
//    func make_review_url2(app_id:String,app_syubetu:Int) ->(String){
//        
//        read_setting()
//        
//        var tmp_url = ""
//        
//        var tmp_country_url = country_code_label[country_no]
//        
//        if(app_syubetu == 0){
//            
//            tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software&country=" + tmp_country_url
//            
//        }else{
//            
//            tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=iPadsoftware&country=" + tmp_country_url
//            
//            
//        }
//        
//        
//        
//        return tmp_url
//    
//    
//    }
    
    
    func make_Ranking_URL(ranking_shubetu:Int) ->(String){
        
        read_setting()
        
        var tmp_url = ""
        
        
        var tmp_ranking_url = ""
        
        //有料アプリランキング
        if(ranking_shubetu == 0){
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                
                tmp_ranking_url = "toppaidapplications"
            
            //iPadランキング
            }else{
                tmp_ranking_url = "toppaidipadapplications"
                
            }
            
        //無料アプリランキング
        }else if(ranking_shubetu == 1){
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                tmp_ranking_url = "topfreeapplications"
            
            //iPadランキング
            }else{
                tmp_ranking_url = "topfreeipadapplications"
                
            }
            
        //トップセールスランキング
        }else{
            
            //iPhoneランキング
            if(app_shyubetu_no == 0){
                tmp_ranking_url = "topgrossingapplications"
            
            //iPadランキング
            }else{
                tmp_ranking_url = "topgrossingipadapplications"
                
                
            }
            
        }
        
        var tmp_country_url = country_code_label[country_no]
        var tmp_category_url = category_code_label[category_no]
        
        
        
        
        tmp_url = "https://itunes.apple.com/"+tmp_country_url+"/rss/" + tmp_ranking_url + "/limit=200/"
        
        if(category_no >= 2){
            
            tmp_url = tmp_url  + category_code_label[category_no] + "/"
        }
        
        tmp_url = tmp_url + "json"
        
        
        return tmp_url
    }
    
    
    func make_review_url(app_id:String) ->(String){
        
        read_setting()
        
        var tmp_country_url = country_code_label[country_no]
        
        let tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software&country=" + tmp_country_url
        
        return tmp_url
        
    }
    
    func make_review_url3(app_id:String) ->(String){
        
        read_setting()
        
        var tmp_country_url = country_code_label[country_no]
        
        let tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software"
        
        return tmp_url
        
    }
    
    func make_review_url2(app_id:String,app_syubetu:Int) ->(String){
        
        read_setting()
        
        var tmp_url = ""
        
        var tmp_country_url = country_code_label[country_no]
        
        if(app_syubetu == 0){
            
            tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=software&country=" + tmp_country_url
            
        }else{
            
            tmp_url = "https://itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=" + app_id + "&entity=iPadsoftware&country=" + tmp_country_url
            
            
        }
        

        
        return tmp_url
        
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
        

        
        
    }
    
    func make_new_ranking(tmp_no:Int) -> (String){
        
        read_setting()
        
        var tmp_url = ""
        var tmp_shyubetu_url = ""
        var tmp_country_url = country_code_label[country_no]
        
        if(tmp_no == 0){
            
            tmp_shyubetu_url = "newapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }else if(tmp_no == 1){
            
            tmp_shyubetu_url = "newpaidapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }else if(tmp_no == 2){
            
            tmp_shyubetu_url = "newfreeapplications"
            //requestUrl = "https://itunes.apple.com/jp/rss/" + tmp_url + "/limit=200/json"
            
            
        }
        
        tmp_url = "https://itunes.apple.com/" + tmp_country_url + "/rss/" + tmp_shyubetu_url + "/limit=200/json"
        
        
        return tmp_url
    }

}
