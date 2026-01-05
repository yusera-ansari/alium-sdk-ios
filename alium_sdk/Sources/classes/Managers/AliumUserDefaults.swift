//
//  AliumUserDefaults.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//

class AliumUserDefaults{
    private init(){}
    static let shared = AliumUserDefaults()
    private let defaults = UserDefaults.standard
    func get(_ key:String)->String{
        defaults.string(forKey: key) ?? ""
    }
    func set( for key : String,_ value:String){
        defaults.set(value, forKey: key)
    }
    
    func remove(_ key :String){
        defaults.removeObject(forKey: key)
    }
    
    func getConfig()->String?{
        guard
            let lastFetched = defaults.string(forKey: "last-fetched-config"),
            let config = defaults.string(forKey: "config")
        else{
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard
            let lastFetchedDate = formatter.date(from: lastFetched)
        else{
            return nil
        }
        let today = formatter.date(from: formatter.string(from: Date()))
        guard let today else {return nil}
        if today > lastFetchedDate {
            return nil
        }
        
        return config
        
    }
    
    func storeConfig(_ config:String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today =  formatter.string(from: Date())
        
        defaults.set(today, forKey: "last-fetched-config")
        defaults.set(config, forKey: "config")
        
        
    }
    
    func setJSON(_ key:String, _ obj:[String:Any]){
        if let data = try? JSONSerialization.data(withJSONObject: obj),
           let string = String(data:data, encoding: .utf8){
            set(for: key, string)
        }
    }
    
    func json(_ key:String) -> [String:Any]?{
      guard   let str=defaults.string(forKey: key),
              let data = str.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
        else{
          return nil
      }
        return json
    }
}
