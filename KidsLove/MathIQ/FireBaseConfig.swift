//
//  FireBaseConfig.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 18/02/23.
//

import Foundation
import FirebaseRemoteConfig
import Firebase

class AppConfig  {
    var remoteConfig = RemoteConfig.remoteConfig()
    let settings1 = RemoteConfigSettings()
    
    var numberOfQuestions: Int {
        settings1.minimumFetchInterval = 0
        remoteConfig.configSettings = settings1
        let noOfQue = remoteConfig.configValue(forKey: "numberOfQuestions")
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activate { changed, error in
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        return (noOfQue.numberValue.intValue == 0) ? 10: noOfQue.numberValue.intValue
    }
}
