//
//  PermissionManager.swift
//  PermissionManager
//
//  Created by 온석태 on 12/18/24.
//

import Foundation
import AVFoundation
import Photos
import UserNotifications

///
/// 권한 관리 클래스
///
/// - Parameters:
///    - permission ( PermissionType ) : 미디어타입
/// - Returns:
///
public class PermissionManagerClass {
    private var callback: PermissionCallbackProtocol?
    
    public init() {
    }
    
    deinit {
        print("PermissionManager deinit")
    }
    
    public func unreference () {
        self.callback = nil
    }
    
    public func setCallback(callback: PermissionCallbackProtocol) {
        self.callback = callback
    }
    
    ///
    /// 미디어 디바이스 퍼미션 상태확인 함수
    ///
    /// - Parameters:
    ///    - permission ( PermissionType ) : 미디어타입
    /// - Returns: PermissionStatusType
    ///
    public func getDevicePermissionStatus (permission: PermissionType) -> PermissionStatusType {
        switch permission {
        case .camera :
            return PermissionStatusType(rawValue: AVCaptureDevice.authorizationStatus(for: .video).rawValue) ?? .unknown
        case .microphone :
            return PermissionStatusType(rawValue: AVCaptureDevice.authorizationStatus(for: .audio).rawValue) ?? .unknown
        case .photo :
            return PermissionStatusType(rawValue: PHPhotoLibrary.authorizationStatus(for: .readWrite).rawValue) ?? .unknown
        case .notification:
            return notificationSettingsType()
        }
    }
    
    ///
    /// 알림 설정 체크 - 상태 리턴
    ///
    /// - Parameters:Void
    /// - Returns: PermissionStatusType
    ///
    public func notificationSettingsType() -> PermissionStatusType {
        let status = checkNotificationSettings()
        switch status {
        case UNAuthorizationStatus.authorized: // 2
            return PermissionStatusType(rawValue: 3) ?? .unknown
        case UNAuthorizationStatus.denied: // 1
            return PermissionStatusType(rawValue: 2) ?? .unknown
        case UNAuthorizationStatus.notDetermined: // 0
            return PermissionStatusType(rawValue: 0) ?? .unknown
        case UNAuthorizationStatus.provisional: // 3
            return PermissionStatusType(rawValue: 5) ?? .unknown
        case UNAuthorizationStatus.ephemeral: // 4
            return PermissionStatusType(rawValue: 6) ?? .unknown
        default:
            return PermissionStatusType(rawValue: -1) ?? .unknown
        }
    }
    
    ///
    /// 알림 설정 상태 체크 (동기로 체크)
    ///
    /// - Parameters:Void
    /// - Returns: UNAuthorizationStatus
    ///
    public func checkNotificationSettings() -> UNAuthorizationStatus {
        var authorizationStatus: UNAuthorizationStatus!
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            authorizationStatus = settings.authorizationStatus
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        return authorizationStatus
    }
    
    ///
    /// 권한 요청
    ///
    /// - Parameters:
    ///    - permission ( PermissionType ) : 미디어타입
    ///    - completion ( func ) : 완료 콜백함수
    /// - Returns:
    ///
    public func requestPermission(permission: PermissionType) {
        print("[PermissionManager] requestPermission request \(permission)")
        
        switch permission {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.callback?.onAuthorized(.camera)
                } else {
                    self.callback?.onDenined(.camera)
                }
            }
        case .microphone:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    self.callback?.onAuthorized(.microphone)
                } else {
                    self.callback?.onDenined(.microphone)
                }
            }
        case .photo:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.callback?.onAuthorized(.photo)
                } else {
                    self.callback?.onDenined(.photo)
                }
            }
        case .notification:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    self.callback?.onAuthorized(.notification)
                } else {
                    self.callback?.onDenined(.notification)
                }
            }
        }
    }
    
    
    public func requestPermissionWithCallback(permission: PermissionType, completion: @escaping (_ succeed: Bool) -> Void) {
        print("[PermissionManager] requestPermission request \(permission)")
        
        switch permission {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .microphone:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .photo:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .notification:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
