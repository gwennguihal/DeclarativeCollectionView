import Foundation

public protocol DecorationType {}

public struct Decoration: Content {
    public let type: DecorationType
    public let contents: [Content]
    
    public var startIndex: Int?
    public var endIndex: Int? {
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

public extension Decoration {
    init(type: DecorationType, @ContentBuilder _ builder: () -> [Content]) {
        self.init(type: type, contents: builder())
    }
    init(type: DecorationType, @ContentBuilder _ builder: () -> Content) {
        self.init(type: type, contents: [builder()])
    }
}

