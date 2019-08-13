import Foundation

public protocol Section {
    var cells: [Int: Cell] { get }
    var spaces: [Int: Space] { get }
    var decorations: [Int: Decoration] { get }
    init(cells: [Int: Cell], spaces: [Int: Space], decorations: [Int: Decoration])
}

public extension Section {
    
    init(@ContentBuilder _ builder: () -> Content) {
        self.init(contents: [builder()])
    }
    
    init() {
      self.init(contents: [])
    }
    
    init(contents: [Content]) {
        
        var cells = [Int: Cell]()
        var spaces = [Int: Space]()
        var decorations = [Int: Decoration]()
        var index = 0
        
        Self.invalidate(contents: contents, index: &index, cells: &cells, spaces: &spaces, decorations: &decorations)
        
        self.init(cells: cells, spaces: spaces, decorations: decorations)
    }
    
    private static func invalidate(contents: [Content], index: inout Int, cells: inout [Int: Cell], spaces: inout [Int: Space], decorations: inout [Int: Decoration]) {
        contents.forEach { content in
            switch (content, content.contents) {
            case (let space as Space, nil):
                spaces[index - 1] = space
            case (var decoration as Decoration, nil):
                decoration.startIndex = index - 1
                decorations[index - 1] = decoration
                invalidate(contents: decoration.contents, index: &index, cells: &cells, spaces: &spaces, decorations: &decorations)
            case (let cell as Cell, nil):
                cells[index] = cell
                index += 1
            case (_, .some(let contents)):
                invalidate(contents: contents, index: &index, cells: &cells, spaces: &spaces, decorations: &decorations)
            default:
                break
            }
        }
    }
}

