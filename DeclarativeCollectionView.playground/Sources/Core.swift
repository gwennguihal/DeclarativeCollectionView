import Foundation

@_functionBuilder
public struct ContentBuilder {
    public static func buildBlock(_ contents: Content...) -> [Content] {
        return contents
    }
    public static func buildBlock(_ content: Content) -> Content {
        return content
    }
    public static func buildBlock(_ contents: [Content]) -> [Content] {
        return contents
    }
    public static func buildIf(_ contents: Content?...) -> [Content] {
        let t = contents.flatMap { $0 }
        return t
    }
}

public protocol Cell: Content {
}

public struct Space: Content {
    public init() {
        
    }
}

public struct Container: Content {
    public var contents: [Content]?
    init(contents: [Content]) {
        self.contents = contents
    }
    public init(@ContentBuilder _ builder: () -> [Content]) {
        self.init(contents: builder())
    }
}









