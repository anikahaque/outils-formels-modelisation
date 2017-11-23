
import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {


        let Noeud = MarkingGraph(marking: marking)
        var Avoir = [MarkingGraph]()
        var Vu = [MarkingGraph]()

        Avoir.append(Noeud)

        while Avoir.count != 0 {
            let current = Avoir.removeFirst()
            Vu.append(current)
            transitions.forEach { tr in
              if let mark = tr.fire(from: current.marking) {
                        if let dejavu = Vu.first(where: { $0.marking == mark }) {
                            current.successors[tr] = dejavu
                        } else {
                            let successor = MarkingGraph(marking: mark)
                            current.successors[tr] = successor
                            if (!Avoir.contains(where: { $0.marking == successor.marking})) {
                                Avoir.append(successor)
                            }
                    }
                }
            }
        }


        return Noeud
    }

    public func count (mark: MarkingGraph) -> Int{
      var vu = [MarkingGraph]()
      var Avoir = [MarkingGraph]()

      Avoir.append(mark)
      while let current = Avoir.popLast() {
        vu.append(current)
        for(_, successor) in current.successors{
          if !vu.contains(where: {$0 === successor}) && !Avoir.contains(where: {$0 === successor}){
              Avoir.append(successor)
            }
          }
      }

      return vu.count
    }

    public func Smokers (mark: MarkingGraph) -> Bool {
      var vu = [MarkingGraph]()
      var Avoir = [MarkingGraph]()

      Avoir.append(mark)
      while let current = Avoir.popLast() {
        vu.append(current)
        var fumeur = 0;
        for (key, value) in current.marking {
            if (key.name == "s1" || key.name == "s2" || key.name == "s3"){
               fumeur += Int(value)
            }
        }
        if (fumeur > 1) {
          print (current.marking)
          return true
        }
        for(_, successor) in current.successors{
          if !vu.contains(where: {$0 === successor}) && !Avoir.contains(where: {$0 === successor}){
              Avoir.append(successor)
            }
          }
      }
      return false
    }

    public func Multiple (mark: MarkingGraph) -> Bool {
      var vu = [MarkingGraph]()
      var Avoir = [MarkingGraph]()

      Avoir.append(mark)
      while let current = Avoir.popLast() {
        vu.append(current)
        for (key, value) in current.marking {
            if (key.name == "p" || key.name == "t" || key.name == "m"){
               if(value > 1){
               print(current.marking)
                 return true
               }
            }
        }
        for(_, successor) in current.successors{
          if !vu.contains(where: {$0 === successor}) && !Avoir.contains(where: {$0 === successor}){
              Avoir.append(successor)
            }
          }
      }
      return false
    }

}
