//

//


import UIKit

class CSV_file: NSObject {
    
    var csv_array = [String]()
    
    


    func csv_file_read(file_name :String)->[String]{
    
        //CSVファイルを格納するための配列を作成
        var csvArray_line = [String]()
    
        let csvBundle = NSBundle.mainBundle().pathForResource(file_name,ofType: "csv")
    
        do {
        
            //csvBundleのパスを読み込み、UTF8に変換して、NSStringに格納
            let csvData = try String(contentsOfFile: csvBundle!,encoding: NSUTF8StringEncoding)
        
            //改行コードが"\r"で行なわれている場合は"\n"に変更する
            let lineChange = csvData.stringByReplacingOccurrencesOfString("\r", withString: "\n")
        
            //"\n"の改行コードで区切って、配列csvArrayに格納する
            csvArray_line = lineChange.componentsSeparatedByString("\n")
        
        }
        
        catch {
        
            print("エラー")
        
        }
        
        return csvArray_line
    }
    
    
    func csv_line_read(line :String)->[String]{
        
        var csv_array = [String]()
        
        //"\n"の改行コードで区切って、配列csvArrayに格納する
        csv_array = line.componentsSeparatedByString(",")
    

        return csv_array
        
    }
    
    func read_country_csv() -> ([String],[String],[String]){
        
        //配列の初期化
        var country_label_jp = [String()]
        var country_label_en = [String()]
        var country_code_label = [String()]
        
        country_label_jp.removeAll()
        country_label_en.removeAll()
        country_code_label.removeAll()
        
        let csv_filename = Const.country_csv_filename
        var csvArray_line = csv_file_read(csv_filename)
        
        
        for tmp in csvArray_line{
            
            
            var tmp_array = csv_line_read(tmp)
            
            country_label_jp.append(tmp_array[0])
            country_label_en.append(tmp_array[1])
            country_code_label.append(tmp_array[2])
            
        }
        
        return (country_label_jp,country_label_en,country_code_label)
        
    }
    
    func read_category_csv() -> ([String],[String],[String]){
        
        //配列の初期化
        var category_label_jp = [String()]
        var category_label_en = [String()]
        var category_code_label = [String()]
        
        category_label_jp.removeAll()
        category_label_en.removeAll()
        category_code_label.removeAll()
        
        let csv_filename = Const.category_csv_filename
        var csvArray_line = csv_file_read(csv_filename)
        
        for tmp in csvArray_line{
            
            
            var tmp_array = csv_line_read(tmp)
            
            category_label_jp.append(tmp_array[0])
            category_label_en.append(tmp_array[1])
            category_code_label.append(tmp_array[2])
            
        }
        
        return (category_label_jp,category_label_en,category_code_label)
        
    }
    


    

    
    
    
}
