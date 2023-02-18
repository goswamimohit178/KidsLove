//
//  FireBaseConfig.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 18/02/23.
//

import Foundation
import FirebaseRemoteConfig
import Firebase

class Configdefaults  {
    var remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    func fireBaseConfig() -> Int {
        
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
       let noOfQue = remoteConfig.configValue(forKey: "numberOfQuestions")
        print(noOfQue.numberValue)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
              self.remoteConfig.activate { changed, error in
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
         
        }
        return Int(noOfQue.numberValue)
    }
    
   
}
