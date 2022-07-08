//
//  ViewController.swift
//  PushNotificationsSample
//
//  Created by Alexey Strakh on 6/14/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func requestPushNotificationsPermission() {
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] settings in
            print("Notification settings: \(settings)")
            
            if settings.authorizationStatus != .authorized {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, _ in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self?.registerForPushNotifications()
                })
            } else {
                self?.registerForPushNotifications()
            }
          }
    }
    
    func registerForPushNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @IBAction func signUp_Clicked(_ sender: UIButton) {
        self.requestPushNotificationsPermission()
        print("Button clicked")
    }
    
}

