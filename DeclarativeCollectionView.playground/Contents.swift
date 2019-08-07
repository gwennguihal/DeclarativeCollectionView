import Foundation

/**protocol Adaptable {}

protocol Descriptable {
    associatedtype Adapter: Adaptable
    var adapter: Adapter { get }
}

protocol LabelAdapterProtocol : Adaptable {}
struct AnyLabelAdapter: LabelAdapterProtocol {}

struct FooDescriptor: Descriptable {
    var adapter = AnyLabelAdapter()
}

protocol ImageAdapterProtocol : Adaptable {
    var key: String { get }
}
struct AnyImageAdapter: ImageAdapterProtocol {
    let key = "hello"
}
struct BarDescriptor: Descriptable {
    let adapter = AnyImageAdapter()
}

let bar = BarDescriptor()
bar.adapter.key

/**
 struct AnyPokemon<P: Pokemon>: Pokemon {
     
     private let pokemon: P
     
     init(_ pokemon: P) {
         self.pokemon = pokemon
     }
     
     func attack() -> P.Power {
         return pokemon.attack()
     }
 }
 
 struct AnyPokemon<Power>: Pokemon {
     
     // we have to save the properties and functions
     // that we need to use for the Pokemon protocol
     private let _attack: () -> Power
     
     init<P: Pokemon where P.Power == Power>(_ pokemon: P) {
         _attack = pokemon.attack
     }
     
     func attack() -> Power {
         // using the original Pokemon's attack implementation
         return _attack()
     }
 }
 */

struct AnyDescriptor<Adapter: Adaptable>: Descriptable {
    private let _adapter: Adapter
    var adapter: Adapter {
        return _adapter
    }
    
    init<T: Descriptable>(_ descriptable: T) where T.Adapter == Adapter {
        _adapter = descriptable.adapter
    }
    
    
}

let descriptors: [AnyDescriptor] = [AnyDescriptor(BarDescriptor()),AnyDescriptor(FooDescriptor())]*/

protocol Content {}

protocol Cell: Content {
}

protocol Space: Content {
}

protocol Section {
    var cells: [Cell] { get }
    var spaces: [Space] { get }
    var decorations: [Decoration] { get }
    init(cells: [Cell], spaces: [Space], decorations: [Decoration])
}

protocol DecorationType {}

struct Decoration: Content {
    let type: DecorationType
    let contents: [Content]
}

enum AnyDecorationType: DecorationType {
    case ticket
}
    

@_functionBuilder
class DecorationBuilder {
    static func buildBlock(type: DecorationType,_ contents: Content...) -> Decoration {
        return Decoration(type: type, contents: contents)
    }
}

@_functionBuilder
class SectionBuilder {
    static func buildBlock(_ contents: Content...) -> [Content] {
        return contents
    }
}

extension Decoration {
    init(@DecorationBuilder _ builder: () -> Decoration) {
        
    }
}

extension Section {
    init(@SectionBuilder _ builder: () -> [Content]) {
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







