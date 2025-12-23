//
//  MainViewController.swift
//  AliumUIKitExample
//
//  Created by Abcom on 11/12/25.
//

import UIKit
import alium_sdk
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did loaddddd")
        
        Alium.trigger( parameters: SurveyParameters(screenName: "ratings"))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
