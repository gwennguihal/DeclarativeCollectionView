import Foundation

public protocol Content {
    var contents: [Content]? { get }
}
public extension Content {
    var contents: [Content]? {
        nil
    }
}

// type erasure
public struct AnyContent: Content {

    var content: Content

    public init<C: Content>(_ content: C) {
        self.content = content
    }
    
    public var contents: [Content]? {
        return [content]
    }
}
