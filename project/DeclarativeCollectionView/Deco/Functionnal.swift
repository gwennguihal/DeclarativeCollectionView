//
//  Functionnal.swift
//  
//
//  Created by Guihal Gwenn on 13/08/2019.
//

import Foundation

public struct Declarative<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DeclarativeCompatible {
    associatedtype CompatibleType
    static var ui: Declarative<CompatibleType>.Type { get set }
    var ui: Declarative<CompatibleType> { get set }
}

public extension DeclarativeCompatible {
    static var ui: Declarative<Self>.Type {
        get {
            return Declarative<Self>.self
        }
        set {}
    }
    var ui: Declarative<Self> {
        get {
            return Declarative(self)
        }
        set {}
    }
}

extension Array: DeclarativeCompatible { }
public extension Declarative where Base: Collection {
    func map<T: Content>(_ builder: @escaping (Base.Element) -> T) -> Map<Base, T> {
        return Map(self.base, builder)
    }
    
    func compactMap<T: Content>(_ builder: @escaping (Base.Element) -> T?) -> CompactMap<Base, T> {
        return CompactMap(self.base, builder)
    }
    
    func forEach(_ builder: @escaping (Base.Element) -> Void) -> ForEach<Base> {
        return ForEach(self.base, builder)
    }
}

public struct Map<Data: Collection, T: Content>: Content {
    var data: Data
    var builder: (Data.Element) -> T
    public init(_ data: Data, _ builder: @escaping (Data.Element) -> T) {
        self.data = data
        self.builder = builder
    }
    
    public var contents: [Content]? {
        return data
            .map { builder($0) }
    }
}

public struct CompactMap<Data: Collection, T: Content>: Content {
    var data: Data
    var builder: (Data.Element) -> T?
    public init(_ data: Data, _ builder: @escaping (Data.Element) -> T?) {
        self.data = data
        self.builder = builder
    }
    public var contents: [Content]? {
        return data.compactMap {
            builder($0)
        }
    }
}

public struct ForEach<Data: Collection>: Content {
    var data: Data
    var builder: (Data.Element) -> Void
    public init(_ data: Data, _ builder: @escaping (Data.Element) -> Void) {
        self.data = data
        self.builder = builder
    }
    public var contents: [Content]? {
        data.forEach {
            builder($0)
        }
        return nil
    }
}
