//
//  InternetHandlerClass.swift
//  TalkLine
//
//  Created by MA on 11/17/16.
//  Copyright © 2016 ICTC. All rights reserved.
//

import UIKit
import SystemConfiguration



class InternetHandlerClass: NSObject {
    //MARK: Shared Instance
     static let sharedInstance = InternetHandlerClass()

    
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
      private var reachability:Reachability!;
    
    func startReachability () {
        reachability = Reachability.networkReachabilityForInternetConnection()
        let isStart = reachability.startNotifier()
        if isStart {
            print("Start")
        } else {
             print("Not Start")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
    }
    
    func stopReachability () {
//        NotificationCenter.default.removeObserver(self)
//        reachability?.stopNotifier()
    }
    
    
    func isConnectedTo () {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        
        
       // _ = reachability?.startNotifier()
        
    }
    
    
    @objc func reachabilityStatusChanged(_ sender: NSNotification) {
        guard ((sender.object as? Reachability)?.currentReachabilityStatus) != nil else { return }
        
    }
    
    
    
    
//    func updateInterfaceWithCurrent(networkStatus: NetworkStatus) {
//        switch networkStatus {
//        case NotReachable:
//            view.backgroundColor = .red
//            print("No Internet")
//        case ReachableViaWiFi:
//            view.backgroundColor = .green
//            print("Reachable Internet")
//        case ReachableViaWWAN:
//            view.backgroundColor = .yellow
//            print("Reachable Cellular")
//        default:
//            return
//        }        
//    }
    
}
