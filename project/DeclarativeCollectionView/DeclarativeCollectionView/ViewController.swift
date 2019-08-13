//
//  ViewController.swift
//  DeclarativeCollectionView
//
//  Created by Guihal Gwenn on 13/08/2019.
//  Copyright © 2019 Guihal Gwenn. All rights reserved.
//

import UIKit
import Deco

enum AnyDecorationType: DecorationType {
    case ticket
    case form
}

struct AnySection: Section {
    var cells: [Int: Cell]
    var spaces: [Int: Space]
    var decorations: [Int: Decoration]
}

struct AnyCell: Cell {}
struct OptionalCell: Cell {
    init?(value: Bool) {
        guard value == true else {
            return nil
        }
        self.init()
    }
    init() {}
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SwiftUI.ForEach
        
        let state: Bool = true
        
        let s0 = AnySection {
            AnyCell()
        }
        print("s0", s0)
        
        let s1 = AnySection {
            AnyCell()
            AnyCell()
            Space()
            OptionalCell(value: true)
            OptionalCell(value: false)
            [1,2,3].ui.map { _ in
                AnyCell()
            }
        }
        print("s1", s1)
        
        let s2 = AnySection {
            AnyCell()
            Space()
        }
        print("s2", s2)
        
        let s3 = AnySection {
            if state {
                AnyCell()
            }
        }
        print("s3", s3)
        
        let s4 = AnySection {
            if state {
                AnyCell()
            } else {
                Space()
            }
        }
        print("s4", s4)
        
        let s5 = AnySection {
        }
        print("s5", s5)
//        
//        let s4 = AnySection {
//            state ? OptionalCell(value: true) : OptionalCell(value: false)
//        }
//        print("s4", s4)

        
        let dataSource = DataSource {
            AnySection {
                AnyCell()
                Space()
            }
            AnySection {
                AnyCell()
                Space()
            }
            AnySection {
                if state {
                    AnyCell()
                } else {
                    Space()
                }
            }
            AnySection {}
        }
    }


}

