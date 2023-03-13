//
//  MillsLaunchModel.swift
//  KidsLove
//
//  Created by Babblu Bhaiya on 11/03/23.
//

import Foundation
import UIKit
import SwiftUI
import CloudKit

struct SectionModel: Identifiable {
     var id = UUID()
     var items: [ButtonType]
     var sectionTittle: String
}
struct ButtonType: Identifiable {
    var id = UUID()
    var btnTittle: String
    var action: () -> Void
}
