// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@MainActor
public final class Alium{
    public static let shared = Alium()
    private static var configUrl:String?
    private static var surveyConfig:SurveyConfig?=nil;
    public static func testAlium(){
        print("ALium is running!");
    }
    
    public static func config(key:String){
        guard configUrl == nil else {
            NSLog("config url is already set to: \(configUrl)")
            return;
        }
        configUrl = key;
        shared.fetchConfigJson()
        
    }
    
   
    func fetchConfigJson() {
        print("fetch config")
        guard let configUrl = Alium.configUrl,let url = URL( string:configUrl)  else{
            print ("failed....")
            return;
        }
        
         
        var session = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, response, err in
            
            if err != nil{
                print("\(err?.localizedDescription)")
                return;
            }
            guard let data,  let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{
                print(response, data)
                return;
            }
            
            do{
                let surveyData = try JSONDecoder().decode(SurveyConfig.self, from: data);
                print(surveyData);
            }catch{
                print(error)
            }
                        
        }
        session.resume()
        
            
     }
    
}
