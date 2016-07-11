//
//  mytabbar_ViewController.swift
//  Pods
//
//  Created by 岡野光祐 on 2016/07/01.
//
//

import UIKit

class mytabbar_ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate()
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.LightContent;
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
