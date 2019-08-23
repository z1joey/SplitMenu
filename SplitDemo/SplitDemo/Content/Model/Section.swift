//
//  Section.swift
//  SplitDemo
//
//  Created by joey on 8/22/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

/*
 The model should not be a struct because struct is value type, which lead to tableview return an incorrect number of rows
 */
class Section {
    var id: Int
    var title: String
    var data: [String]
    var isFolding: Bool

    init(id: Int, title: String, data: [String], isFolding: Bool) {
        self.id = id
        self.title = title
        self.data = data
        self.isFolding = isFolding
    }
}
