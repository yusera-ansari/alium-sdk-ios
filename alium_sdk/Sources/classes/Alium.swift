// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@MainActor
public final class Alium{
    static let shared = Alium()
    private var configUrl:String?
    var surveyConfig:SurveyConfig?=nil;
    private var requestQueue:[AliumRequest] = [];
    private var isConfigFetching = false
    public static func testAlium(){
        print("ALium is running!");
    }
    
    public static func config(key:String){
        guard shared.configUrl == nil else {
            NSLog("config url is already set to: \(shared.configUrl)")
            return;
        }
        shared.configUrl = key;
        shared.fetchConfigJson()
    }
    
    public static func trigger( parameters:SurveyParameters){
        guard shared.configUrl != nil else{return}
        NSLog("appending trigger request...")
        shared.requestQueue.append(AliumRequest(type: .trigger( parameters: parameters)))
        NSLog("Queue after appending request: \(shared.requestQueue.first)")
        if(shared.surveyConfig != nil && !shared.isConfigFetching){
            NSLog("Queue request: \(shared.requestQueue.first)")
           
            AliumRequestManager.execNextRequest(&shared.requestQueue);
        }
    }
    func fetchConfigJson() {
        guard let urlStr = configUrl, let url = URL(string: urlStr) else { return }
        
        self.isConfigFetching = true
        print("Fetching config…")
        
        
        var session = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, response, err in
            
            if err != nil{
                print("\(err?.localizedDescription)")
                DispatchQueue.main.async {
                    self.isConfigFetching = false
                }
                return;
            }
            guard let data,  let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{
                print("Invalid response")
                DispatchQueue.main.async {
                    self.isConfigFetching = false
                }
                return;
            }
            print("survey config:  \(data)")
            do{
                let surveyData = try JSONDecoder().decode(SurveyConfig.self, from: data);
                print(surveyData);
                DispatchQueue.main.async {
                    self.surveyConfig = surveyData
                    self.isConfigFetching = false
                    NSLog("Queue after request: \(Alium.shared.requestQueue.first)")
                   
                    AliumRequestManager.execNextRequest(&Alium.shared.requestQueue);
                    
                }
            }catch{
                print(error)
                DispatchQueue.main.async {
                    self.isConfigFetching = false
                }
            }
            
        }
        session.resume()
        
        
    }
    
    public static func stop(on screen:String){
        guard let configUrl = shared.configUrl else{return}
        shared.requestQueue.append(.init(type: .stop(screen: screen)))
        if(shared.surveyConfig != nil && !shared.isConfigFetching){
            AliumRequestManager.execNextRequest(&shared.requestQueue)
        }
    }
    
}
