import Foundation

protocol Content {}

protocol Cell: Content {
}

protocol Space: Content {
}

struct Decoration: Content {
    let type: DecorationType
    let contents: [Content]
}

protocol DecorationType {}

protocol Section {
    var cells: [Cell] { get }
    var spaces: [Space] { get }
    var decorations: [Decoration] { get }
    init(cells: [Cell], spaces: [Space], decorations: [Decoration])
}

@_functionBuilder
class ContentBuilder {
    static func buildBlock(_ contents: Content...) -> [Content] {
        return contents
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
        var cells = [Cell]()
        var spaces = [Space]()
        var decorations = [Decoration]()
        contents.forEach {
            switch $0 {
            case let cell as Cell:
                cells.append(cell)
            case let space as Space:
                spaces.append(space)
            case let decoration as Decoration:
                decorations.append(decoration)
            default:
                break
            }
        }
        self.init(cells: cells, spaces: spaces, decorations: decorations)
    }
}

enum AnyDecorationType: DecorationType {
    case ticket
}

struct AnySection: Section {
    var cells: [Cell]
    var spaces: [Space]
    var decorations: [Decoration]
}

struct AnyCell: Cell {}
struct AnySpace: Space {}

let section = AnySection {
    AnyCell()
    AnyCell()
    AnySpace()
    AnyCell()
    Decoration(type: AnyDecorationType.ticket) {
        AnySpace()
        AnyCell()
    }
}
print(section.cells) // 3 cells
print(section.spaces) // 1 space
print(section.decorations) // 1 decorations with n spaces and n cells







