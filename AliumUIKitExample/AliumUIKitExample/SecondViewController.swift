//
//  SecondViewController.swift
//  AliumUIKitExample
//
//  Created by yusera-ansari on 08/12/25.
//

import UIKit
import alium_sdk
class SecondViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        print("second view controller appeared")
        Alium.trigger(parameters: SurveyParameters(screenName: "screen2"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isBeingDismissed {}
        Alium.stop(on: "screen2")
    }

}

