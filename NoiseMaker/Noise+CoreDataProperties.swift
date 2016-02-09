//
//  Noise+CoreDataProperties.swift
//  NoiseMaker
//
//  Created by Gerry Laplante on 10/21/15.
//  Copyright © 2015 Gerry Laplante. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Noise {

    @NSManaged var name: String
    @NSManaged var url: String

}
