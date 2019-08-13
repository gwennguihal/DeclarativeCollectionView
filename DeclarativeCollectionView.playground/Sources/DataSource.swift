import Foundation

public class DataSource {
    public var sections = [Section]()
}

@_functionBuilder
public class DataSourceBuilder {
    public static func buildBlock(_ sections: Section...) -> [Section] {
        return sections
    }
}

public extension DataSource {
    public convenience init(@DataSourceBuilder _ builder: () -> [Section]) {
        self.init()
        self.sections = builder()
    }
}

