//
//  Section.swift
//  SplitDemo
//
//  Created by joey on 8/22/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit
import RxSwift

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

struct SideMenuOption {
    let title: String
    let image: UIImage?
    var isFolding: Bool = true
}

class SectionViewModel {

    var sideMenuOptions: Observable<[SideMenuOption]> = Observable<[SideMenuOption]>.just([
        SideMenuOption(title: "Title1", image: UIImage(named: "book")),
        SideMenuOption(title: "Title2", image: UIImage(named: "headphones")),
        SideMenuOption(title: "Title3", image: UIImage(named: "monitor")),
        SideMenuOption(title: "Title4", image: UIImage(named: "photo-camera"))
    ])

    var sections: [Section] = {
        var data: [Section] = []
        for i in 0...5 {
            let section = Section(id: i, title: "ID \(i)", data: ["Chinese", "English", "Japanese", "Germany", "Thailand", "Australia"], isFolding: true)
            data.append(section)
        }
        return data
    }()

    var sectionObservable: Observable<[Section]> {
        return Observable.of(sections)
    }

}
