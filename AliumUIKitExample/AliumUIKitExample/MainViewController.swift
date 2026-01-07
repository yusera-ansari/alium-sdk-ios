//
//  MainViewController.swift
//  AliumUIKitExample
//
//  Created by Abcom on 11/12/25.
//

import UIKit
import alium_sdk
class MainViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        Alium.trigger( parameters: SurveyParameters(screenName: "screen3"))
        Alium.trigger( parameters: SurveyParameters(screenName: "screen3"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did loaddddd")
        view.backgroundColor = .green
      
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            let controller = SecondViewController()
            controller.view.backgroundColor = .systemPink
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("main will disappear")
        Alium.stop(on: "screen3")
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
