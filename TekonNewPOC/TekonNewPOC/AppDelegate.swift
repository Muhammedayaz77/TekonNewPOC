//
//  AppDelegate.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 16/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    
    
//    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.refresh", using: nil) { task in
//         self.handleAppRefresh(task: task as! BGAppRefreshTask)
//    }
//
//    func scheduleAppRefresh() {
//       let request = BGAppRefreshTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.refresh")
//       // Fetch no earlier than 15 minutes from now.
//       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
//
//       do {
//          try BGTaskScheduler.shared.submit(request)
//       } catch {
//          print("Could not schedule app refresh: \(error)")
//       }
//    }
//
//    func handleAppRefresh(task: BGAppRefreshTask) {
//       // Schedule a new refresh task.
//       scheduleAppRefresh()
//
//
//       // Create an operation that performs the main part of the background task.
//       let operation = RefreshAppContentsOperation()
//
//       // Provide the background task with an expiration handler that cancels the operation.
//       task.expirationHandler = {
//          operation.cancel()
//       }
//
//
//       // Inform the system that the background task is complete
//       // when the operation completes.
//       operation.completionBlock = {
//          task.setTaskCompleted(success: !operation.isCancelled)
//       }
//
//
//       // Start the operation.
//       operationQueue.addOperation(operation)
//     }


}

