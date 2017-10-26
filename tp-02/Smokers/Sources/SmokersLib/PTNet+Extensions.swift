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

        let m0:MarkingGraph = MarkingGraph(marking: marking)
        var seen :[MarkingGraph]=[m0]
        var toVisit:[MarkingGraph]=[m0]
        while let current = toVisit.popLast(){
          seen.append(current)
          for tr in transitions{
              if let firedtr = tr.fire(from: current.marking){
                if let visited = seen.first(where: {$0.marking == firedtr}){
                     current.successors[tr] = visited
}else{
let successor:MarkingGraph = MarkingGraph(marking: firedtr)
        if !seen.contains{$0 === successor}{
             current.successors[tr] = successor
            toVisit.append(successor)

          }
          }
          }
        }
      }
          print("\(seen)")
          return m0
        }

}
