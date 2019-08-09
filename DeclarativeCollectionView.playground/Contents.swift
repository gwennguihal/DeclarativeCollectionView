import Foundation
import SwiftUI

protocol Content {}

protocol Cell: Content {
}

struct Space: Content {
}

struct Decoration: Content {
    let type: DecorationType
    let contents: [Content]
    
    var startIndex: Int?
    var endIndex: Int? {
        guard let startIndex = startIndex else {
            return nil
        }
        var count = 0
        computeEndIndex(contents, &count)
        return startIndex + count
    }
    
    private func computeEndIndex(_ contents: [Content], _ count: inout Int) {
        contents.forEach {
            if $0 is Cell {
                count += 1
            } else if let decoration = $0 as? Decoration {
                computeEndIndex(decoration.contents, &count)
            }
        }
    }
}

protocol DecorationType {}

protocol Section {
    var cells: [Int: Cell] { get }
    var spaces: [Int: Space] { get }
    var decorations: [Int: Decoration] { get }
    init(cells: [Int: Cell], spaces: [Int: Space], decorations: [Int: Decoration])
}

@_functionBuilder
class ContentBuilder {
    static func buildBlock(_ contents: Content...) -> [Content] {
        return contents
    }
}

class DataSource {
    var sections = [Section]()
}

@_functionBuilder
class DataSourceBuilder {
    static func buildBlock(_ sections: Section...) -> [Section] {
        return sections
    }
}

extension DataSource {
    convenience init(@DataSourceBuilder _ builder: () -> [Section]) {
        self.init()
        self.sections = builder()
    }
}

extension Decoration {
    init(type: DecorationType, @ContentBuilder _ builder: () -> [Content]) {
        self.init(type: type, contents: builder())
    }
}

extension Section {
    
    init(@ContentBuilder _ builder: () -> [Content]) {
        
        let contents = builder()
        var cells = [Int: Cell]()
        var spaces = [Int: Space]()
        var decorations = [Int: Decoration]()
        var index = 0
        
        Self.invalidate(contents: contents, index: &index, cells: &cells, spaces: &spaces, decorations: &decorations)
        
        self.init(cells: cells, spaces: spaces, decorations: decorations)
    }
    
    private static func invalidate(contents: [Content], index: inout Int, cells: inout [Int: Cell], spaces: inout [Int: Space], decorations: inout [Int: Decoration]) {
        contents.forEach { content in
            switch content {
            case let space as Space:
                spaces[index - 1] = space
            case var decoration as Decoration:
                decoration.startIndex = index - 1
                decorations[index - 1] = decoration
                invalidate(contents: decoration.contents, index: &index, cells: &cells, spaces: &spaces, decorations: &decorations)
            case let cell as Cell:
                cells[index] = cell
                index += 1
            default:
                break
            }
        }
    }
}

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

struct ForEach {
    var collection: [Any]
}

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







