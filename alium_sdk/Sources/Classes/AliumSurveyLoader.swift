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
    nonisolated(unsafe) private var shouldStop:Bool = false
    let parameters:SurveyParameters
    let delegate : SurveyStateDelegate!
    private var overlay:OverlayViewController?
    private var dataTask: URLSessionDataTask?

    init(parameters: SurveyParameters, delegate:SurveyStateDelegate) {
        self.parameters = parameters
        self.delegate = delegate
       
        
    }
     func showSurvey(){
        if shouldStop {return}
        findAndLoadSurvey()
   
    }
    
    private func findAndLoadSurvey(){
        if shouldStop {return}
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
        if shouldStop {return}
        guard let path = info.tps?.app?.spath, let surPath = URL(string:path ) else{
            print("path not found")
            return ;
        }
        guard let  vf = info.tps?.app?.vf else {
            print("vf not found")
            return}
//        should survey load / implementation pending
        do{
            let freqManager = try FrequencyManagerFactory.getFrequencyManager(key: parameters.screenName, srvShowFreq: vf, customFreqSurveyData: nil)
            
            if try freqManager.shouldSurveyLoad() {
                loadSurvey(surPath, vf);
            }
        }catch{
            print(error)
        }
    }
    
    func loadSurvey(_ url:URL, _ vf:String){
        if shouldStop {return}
        print("loading survey...")
        makeNetworkRequest(url: url) {
            [weak self] survey in
            print("found the survey: \(survey)")
            self?.showSurveyOnScreen(survey, vf)
        }
    }
    func showSurveyOnScreen(_ survey:Survey,_ vf:String){
        NSLog("Show Survey is running....")
//        if(isUIKitApp()){
        if shouldStop {return}

            if let topVC = ViewControllerFinder.topViewController() {
                if let topVC = topVC as? OverlayViewController {
                    overlay = OverlayViewController(survey: survey, parameters: parameters, viewFrequency:vf, delegate: delegate)
  //                overlay?.modalPresentationStyle = .overCurrentContext
  //                topVC.definesPresentationContext = true
                    if shouldStop {return}
                    topVC.presentingViewController?.present(overlay!, animated: true, completion: nil)
                    return
                }
                  overlay = OverlayViewController(survey: survey, parameters: parameters, viewFrequency:vf, delegate: delegate)
//                overlay?.modalPresentationStyle = .overCurrentContext
//                topVC.definesPresentationContext = true
                if shouldStop {return}
                topVC.present(overlay!, animated: true, completion: nil)
               
            }
        
//        }else{
            
//        }
        return;
       
    }
    func stop(){
        print("loader will stop the survey...\(parameters.screenName)")
        shouldStop=true
        dataTask?.cancel()
        dataTask = nil
        overlay?.dismiss(animated: true)
        
    }
    func makeNetworkRequest(url:URL, _ completion : @escaping (_ survey:Survey)->Void){
        if shouldStop {return}
        var configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        let session = URLSession(configuration: configuration)
       dataTask = session.dataTask(with: url){
                       data, response, error in
                       if let error = error {
                           print("Network error: \(String(describing: error))")
                           return;
                       }
                    guard !self.shouldStop else { return }
                       
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
            }                }
        dataTask?.resume()
        
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
