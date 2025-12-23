//
//  OverlayViewController+Delegate.swift
//  Pods
//
//  Created by Abcom on 23/12/25.
//

extension OverlayViewController : ALiumInputDelegate{
    func onResponse(resp: String) {
        print("response: ", resp)
        response = resp
    }
}
