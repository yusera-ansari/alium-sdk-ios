//
//  ResponseHandler.swift
//  Pods
//
//  Created by Abcom on 23/12/25.
//
@MainActor
protocol ALiumInputDelegate:AnyObject{
    func onResponse(resp:String)
    func enableNext(flag:Bool)
}
