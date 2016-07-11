//
//  read_or_write_setting.swift
//  Not_Game_Ranking
//


import UIKit

class read_or_write_setting: NSObject {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    func read_setting() -> (Int, Int, Int,Int){
        
        var app_shyubetu_no = 0
        var game_shyubetu = 0
        var country_no = 0
        var view_no = 0
        
        var language_str = NSLocalizedString("language",comment:"言語")
    
        
        //app種別を取得
        if((defaults.objectForKey("app_syubetu")) != nil){
            app_shyubetu_no = (defaults.integerForKey("app_syubetu") as? Int)!
            
        }else{
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                //print("iPhone")
                app_shyubetu_no = 0
            }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
                //print("iPad")
                app_shyubetu_no = 1
            }else{
                //print("Unspecified")
                app_shyubetu_no = 0
            }
        }
        
        //カテゴリーno
        if((defaults.objectForKey("category_no")) != nil){
            game_shyubetu = (defaults.integerForKey("category_no") as? Int)!
            
        }else{
            //取得できないので0回にする
            game_shyubetu = 0
        }
        
        //国
        if((defaults.objectForKey("country_no")) != nil){
            country_no = (defaults.integerForKey("country_no") as? Int)!
            
        }else{
            
            if(language_str == "日本語"){
                //日本語の初期値
                country_no = 151
                
            }else{
                
                //英語の初期値
                country_no = 3
                
            }
            


        }
        
        //view
        if((defaults.objectForKey("view_no")) != nil){
            view_no = (defaults.integerForKey("view_no") as? Int)!
            
        }else{
            
            view_no = 0

        }
    
    
        return (app_shyubetu_no, game_shyubetu, country_no,view_no)
    }
    
    
    func write_setting(syubetu_no:Int, category_no:Int, country_no:Int, view_no:Int){
        
        defaults.setInteger(syubetu_no, forKey: "app_syubetu")
        defaults.setInteger(category_no, forKey: "category_no")
        defaults.setInteger(country_no, forKey: "country_no")
        defaults.setInteger(view_no, forKey: "view_no")
        
        defaults.synchronize()
        
        
    }

}
