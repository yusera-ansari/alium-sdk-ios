//
//  AliumSurveyLoader.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//
import UIKit
import SwiftUI

 

@MainActor func isUIKitApp() -> Bool {
    if #available(iOS 13.0, *) {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return false
        }
        return !(String(describing: type(of: rootVC)).contains("UIHostingController"))
    } else {
        // Fallback on earlier versions
        return false
    }
    
   
}

@MainActor
class AliumSurveyLoader{
    let surveyConfig = Alium.shared.surveyConfig;
    
    let parameters:SurveyParameters
    init(parameters: SurveyParameters) {
        self.parameters = parameters
    }
    @MainActor func showSurvey(){
        
        findAndLoadSurvey()
   
    }
    
    private func findAndLoadSurvey(){
        guard let surveyConfig else{return }
        let svs = surveyConfig.svs;
        for surveyInfo in svs {
            print("survey matching...\(surveyInfo.tps?.app?.um?.u) \(parameters.screenName.lowercased())")
            guard let screenName =  surveyInfo.tps?.app?.um?.u, screenName.lowercased() == parameters.screenName.lowercased() else{
                continue;
            }
            print("will load survey matching...")
            loadSurveyIfShouldBeLoaded(surveyInfo);
            return;
            
        
        }
        
    }
    
    func loadSurveyIfShouldBeLoaded(_ info:SurInfo){
        guard let path = info.tps?.app?.spath, let surPath = URL(string:path ) else{
            return ;
        }
//        should survey load / implementation pending
        
        if true {
            loadSurvey(surPath);
        }
    }
    
    func loadSurvey(_ url:URL){
        print("loading survey...")
        makeNetworkRequest(url: url) {[self] survey in
            print("found the survey: \(survey)")
            showSurveyOnScreen(survey)
        }
    }
    func showSurveyOnScreen(_ survey:Survey){
        NSLog("Show Survey is running....")
//        if(isUIKitApp()){
            if let topVC = ViewControllerFinder.topViewController() {
                let overlay = OverlayViewController(survey: survey)
                topVC.present(overlay, animated: true, completion: nil)
            }
//        }else{
            
//        }
        return;
       
    }
    func makeNetworkRequest(url:URL, _ completion : @escaping (_ survey:Survey)->Void){
        URLSession.shared.dataTask(with: url){
                       data, response, error in
                       if let error = error {
                           print("Network error: \(String(describing: error))")
                           return;
                       }
                       
                       guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else{
                           return
                       }
                          
            guard let data  else{
                           return
                       }
         
            do{
                let survey =  try JSONDecoder().decode(Survey.self, from:data)
                           DispatchQueue.main.async {
                               completion(survey)
                           }
            }   catch{
                print(error.localizedDescription)
            }                }.resume()
    }
}
//func test(){
//    guard let window = UIApplication.shared.aliumKeyWindow else {
//        print("MyLibrary: No key window found yet")
//        return
//    }
//    let badge = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 70))
//    
//    badge.text = "screen: \(parameters.screenName)"
//    badge.font = .boldSystemFont(ofSize: 20)
//    badge.textColor = .white
//    badge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.92)
//    badge.textAlignment = .center
//    badge.layer.cornerRadius = 16
//    badge.clipsToBounds = true
//    badge.alpha = 0
//    badge.tag = 999_999 // so we can remove old ones
//    
//    // Remove any previous badge
//    window.viewWithTag(999_999)?.removeFromSuperview()
//    
//    window.addSubview(badge)
//    
//    UIView.animate(withDuration: 0.4, animations: {
//        badge.alpha = 1
//    }) { _ in
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            UIView.animate(withDuration: 0.6) {
//                badge.alpha = 0
//            } completion: { _ in
//                badge.removeFromSuperview()
//            }
//        }
//    }
//}
