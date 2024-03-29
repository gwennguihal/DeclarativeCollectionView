import Foundation

@_functionBuilder
public struct ContentBuilder {
    
    public static func buildBlock() -> Content {
      return Container(contents: [])
    }
    
    public static func buildBlock(_ contents: Content?...) -> Content {
        return Container(contents: contents.compactMap { $0 } )
    }
    
    public static func buildIf(_ content: Content?) -> Content? {
        return content
    }
    
    public static func buildEither(first: Content) -> Content {
        return first
    }
    
    public static func buildEither(second: Content) -> Content {
        return second
    }
}

public protocol Cell: Content {
}

public struct Space: Content {
    public init() {}
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









