//
//  PermissionCallbackProtocol.swift
//  PermissionManager
//
//  Created by 온석태 on 12/18/24.
//

import Foundation

/**
  권한 관리 프로토콜
 */
public protocol PermissionCallbackProtocol {
    ///
    /// 최초 / 미결정 권한 상태
    ///
    /// - Parameters: 권한 유형
    /// - Returns: Void
    ///
    func onNotDetermined(_ type: PermissionType)
    
    ///
    /// 권한 허용 상태
    ///
    /// - Parameters: 권한 유형
    /// - Returns: void
    ///
    func onAuthorized(_ type: PermissionType)
    
    ///
    /// 권한 거부 상태
    ///
    /// - Parameters: 권한 유형
    /// - Returns: Void
    ///
    func onDenined(_ type: PermissionType)
}
