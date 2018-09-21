//
//  OptionallyTakesContactInfo.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import Foundation

protocol OptionallyTakesContactInfo: class {
    func setOptionalContact(_ contact: Contact?)
}
