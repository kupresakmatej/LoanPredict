//
//  AppDelegate.swift
//  LoanPredict
//
//  Created by Matej Kuprešak on 19.01.2024..
//

import Foundation
import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
