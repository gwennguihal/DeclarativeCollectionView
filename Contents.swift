import Foundation

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


let dataSource = DataSource {

    AnySection {
        AnyCell() // 0
        AnyCell() // 1
        Space() // 1
        AnyCell() // 2
        Space() // 2
        Decoration(type: AnyDecorationType.ticket) { //2 - 4
            Space() // 2
            AnyCell() // 3
            Decoration(type: AnyDecorationType.form) { //3 - 4
                Space() // 3
                AnyCell() // 4
            }
        }
    }
    AnySection {
        AnyCell()
        Space()
        [1,2,3].ui.map { _ in
            Container {
                AnyCell()
                AnySpace()
            }
        }
        [1,2,3].ui.compactMap { element -> AnyCell? in
            guard element % 2 != 0 else {
                return nil
            }
            return AnyCell()
        }
        [1,2,3].ui.forEach {
            print($0)
        }
    }
}

// Build
dataSource.sections.forEach { section in
    var decorations = [Decoration]()
    (-1..<section.cells.count).forEach { index in
        
        if let _ = section.cells[index] {
            print("\(index) : cell")
        }
        
        if let decoration = section.decorations[index] {
            print("\(index) : start Decoration \(decoration.type)")
            decorations.append(decoration)
        }
        
        if let _ = section.spaces[index] {
            print("\(index) : space")
        }
        
        decorations.filter { $0.endIndex == index }.forEach { decoration in
            print("\(index) : end Decoration \(decoration.type)")
        }
    }
}







