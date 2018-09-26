//
//  Constants.swift
//  SigTuple
//
//  Created by Coffeebeans on 25/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import Foundation
import UIKit

let urlForOpenIssues = "https://api.github.com/repos/"

let cellIdentifier = "IssueIdentifier"

struct AppColors {
    static let greenColor = UIColor(displayP3Red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    static let greyColor = UIColor(displayP3Red: 182.0, green: 181.0, blue: 182.0, alpha: 1.0)
    static let redColor = UIColor.red
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

//Example: https://api.github.com/repos/prestodb/presto/issues?state=open"//
