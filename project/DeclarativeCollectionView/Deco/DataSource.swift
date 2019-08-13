import Foundation

public class DataSource {
    public var sections = [Section]()
}

public struct SectionContainer {
    public var sections: [Section]
    public init(sections: [Section]) {
        self.sections = sections
    }
}

@_functionBuilder
public class DataSourceBuilder {
    
    public static func buildBlock() -> SectionContainer {
      return SectionContainer(sections: [])
    }
    
    public static func buildBlock(_ sections: Section?...) -> SectionContainer {
        return SectionContainer(sections: sections.compactMap { $0 } )
    }
    
    public static func buildIf(_ section: Section?) -> Section? {
        return section
    }
    
//    public static func buildEither(first: Section) -> SectionContainer {
//        return SectionContainer(sections: [first])
//    }
//
//    public static func buildEither(second: Section) -> SectionContainer {
//        return SectionContainer(sections: [second])
//    }
}

public extension DataSource {
    convenience init(@DataSourceBuilder _ builder: () -> SectionContainer) {
        self.init()
        self.sections = builder().sections
    }
}

