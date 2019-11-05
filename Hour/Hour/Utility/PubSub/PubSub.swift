//
//  PubSub.swift
//  Hour
//
//  Created by Jing Wang on 8/23/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

public enum Event : String {
    case UpdateTimer = "UpdateValue"// Used for stretch, gyro, acc or battery updates
//    case UpdateRSSI = "UpdateRSSI"  // Used for RSSI Updates
//    case AppWillEnterBackground = "AppWillEnterBackground"
//    case AppWillEnterForeground = "AppWillEnterForeground"
}

public protocol Listner  {
    func onEvent(_ event:Event, userInfo:Any) -> Void
    func isEqualTo(_ otherListner:Listner) -> Bool
}


public extension Listner where Self: Equatable {
    func isEqualTo(_ other: Listner) -> Bool {
        guard let otherX = other as? Self else { return false }
        return self == otherX
    }
}


typealias Listners = [Listner]

public class PubSub {
    
    var listners:[Event:Listners] = [Event:Listners]()
    var eventQueue:DispatchQueue = DispatchQueue(label: "com.F8.EventBus", qos: .background)
    
    private init() {
    }
    
    public static var shared : PubSub {
        get {
            struct Singleton {
                static let instance = PubSub()
            }
            return Singleton.instance
        }
    }
    
    public func register(_ event:Event, listner:Listner) -> Void {
        
        eventQueue.sync {
            
            // Create an empty listner list if list is nil
            var list = listners[event]
            if list == nil {
                list = Listners()
            }
            
            // Create new listner to list if it is not added yet
            if var l = list {
                if !l.contains{ $0.isEqualTo(listner) } {
                    print("PubSub >> New subscriber >> \(type(of: listner))")
                    l.append(listner)
                    listners[event] = l
                } else {
                    print("PubSub >> No dups!")
                }
                
                print("Pubsub >> Added for Event \(event) listner  \(listner) of type \(type(of: listner)), total listners \(l.count)")
            }
        }
    }
    
    
    public func unregister(_ event:Event, listner:Listner) -> Void {
        
        eventQueue.sync {
            
            guard var list = listners[event] else {
                return
            }
            
            list.removeAll(where: { $0.isEqualTo(listner) })
            listners[event] = list
            print("PubSub >> Removed for Event \(event) listner  \(listner) total listners \(list.count)")
        }
    }
    
    public func post(_ event:Event, userInfo:Any) -> Void  {
        
        eventQueue.async  {
            guard let list = self.listners[event] else {
                return
            }
            
            for listner in list {
                DispatchQueue.main.async {
                    listner.onEvent(event, userInfo: userInfo)
                }
            }
        }
    }
    
    // List all the listners under each event
    public func ls() {
        for (idx, listnerListKey) in listners.keys.enumerated() {
            if let listnerListValueList = listners[listnerListKey] {
                for listnerListValue in listnerListValueList {
                    print("PubSub >>\(idx)-\(listnerListKey) >> \(type(of: listnerListValue))")
                }
            }
        }
    }
}

