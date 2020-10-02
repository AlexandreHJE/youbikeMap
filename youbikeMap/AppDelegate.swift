//
//  AppDelegate.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let bag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.set([String](), forKey: "favoriteIDs")
        
        Observable.timer(.seconds(0), period: .seconds(30), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_: Int) in self?.getData() })
            .disposed(by: bag)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @objc
    private func getData() {
        DataManager.shared.getYoubikeData()
            .subscribe(onNext: { (stations) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetData"), object: self, userInfo: ["stations": stations])
                print("getData \(self.date2String(Date(), dateFormat: "yyyyMMdd HH:mm:ss"))")
                
            })
            .disposed(by: bag)
    }
}

extension AppDelegate {
    private func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_TW")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
}

