//
//  PermissionStateTypes.swift
//  PermissionManager
//
//  Created by 온석태 on 12/18/24.
//

import Foundation


public enum PermissionStatusType: Int {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
    case limited = 4
    case provisional = 5
    case ephemeral = 6
    case unknown = 99
    
    public init?(rawValue: Int) {
           switch rawValue {
           case 0:
               self = .notDetermined
           case 1:
               self = .restricted
           case 2:
               self = .denied
           case 3:
               self = .authorized
           case 4:
               self = .limited
           case 5:
               self = .provisional
           case 6:
               self = .ephemeral
           default:
               self = .unknown
           }
       }
}
