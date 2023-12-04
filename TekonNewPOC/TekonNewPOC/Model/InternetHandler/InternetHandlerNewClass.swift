//
//  InternetHandlerNewClass.swift
//  TalkLine
//
//  Created by ayaz on 09/02/2020.
//  Copyright © 2020 ICTC. All rights reserved.
//

import Foundation
import Network


enum E_InternetConnectionStatus
{
    case NOT_CONNECTED
    case CONNECTED
}

enum E_InternetConnectionType
{
    case WIFI
    case CELLULAR
    case LOCALHOST
    case VPN
    case ETHERNET
    case NO_CONNECTION
}

class InternetHandlerNewClass
{
    //MARK: Shared Instance
    static let sharedInstance = InternetHandlerNewClass()

    var connectionType =  E_InternetConnectionType.NO_CONNECTION
    var internetStatus =  E_InternetConnectionStatus.NOT_CONNECTED
    
    func startNetworkMoniter()
    {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos:.background)
          
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            
            if path.usesInterfaceType(.wifi)
            {
                print("It's WiFi!")
                self.connectionType = E_InternetConnectionType.WIFI
            }
            else if path.usesInterfaceType(.cellular)
            {
                print("3G/4G FTW!!!")
                self.connectionType = E_InternetConnectionType.CELLULAR
            }
            else if path.usesInterfaceType(.loopback)
            {
                print("Local Host")
                self.connectionType = E_InternetConnectionType.LOCALHOST
            }
            else if path.usesInterfaceType(.other)
            {
                print("For VPN Network")
                self.connectionType = E_InternetConnectionType.VPN
            }
            else if path.usesInterfaceType(.wiredEthernet)
            {
                print("Ethernet Network")
                self.connectionType = E_InternetConnectionType.ETHERNET
            }
            else
            {
                 print("No Internet")
                self.connectionType = E_InternetConnectionType.NO_CONNECTION
            }
            
            
            
            
            if path.status == .satisfied
            {
                print("Yay! We have internet!")
                self.internetStatus = .CONNECTED
            }
            else if path.status == .unsatisfied
            {
                print("internet is available but with very low power.")
                self.internetStatus = .NOT_CONNECTED
            }
            else if path.status == .requiresConnection
            {
                print("The path does not currently have a usable route.")
                self.internetStatus = .NOT_CONNECTED
            }
        }
    }
}


