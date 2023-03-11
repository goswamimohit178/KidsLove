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
     var item: [ButtonType]
     var sectionTittle: String
}
struct ButtonType {
    var btnTittle: String
    var action: () -> Void
}
