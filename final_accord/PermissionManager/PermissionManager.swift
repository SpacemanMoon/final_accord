import UIKit
import UserNotifications
import AVFoundation
import Photos

// MARK: - PermissionManager

final class PermissionManager {
    
    // MARK: - Singleton
    
    static let shared = PermissionManager()
    
    private init() {}
    
    // MARK: - Public Methods
    
    func requestAllPermissions() {
        requestNotificationPermission()
        requestCameraPermission()
        requestPhotoLibraryPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { _ in }
        case .authorized, .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in }
        case .authorized, .denied, .restricted, .limited:
            break
        @unknown default:
            break
        }
    }
}
