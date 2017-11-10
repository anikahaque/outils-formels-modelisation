import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.

        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.


              let transitions = self.transitions
      				let NoeudInitial = CoverabilityGraph(marking: marking)
              var AVisité = [CoverabilityGraph]()
              var Visité = [CoverabilityGraph]()

              AVisité.append(NoeudInitial)

      				while AVisité.count != 0 {
                  let actuel = AVisité.removeFirst()
                  Visité.append(actuel)
                  transitions.forEach { tran in
                    if var NouveauMarq = tran.fire(from: actuel.marking) {
                      NouveauMarq = VerOmega(marquage : NouveauMarq, liste : Visité)
                      if let DéjàVisité = Visité.first(where: { $0.marking == NouveauMarq }) {
                          actuel.successors[tran] = DéjàVisité
                      }
      								else {
                          let découvert = CoverabilityGraph(marking: NouveauMarq)
                          actuel.successors[tran] = découvert
                          if (!AVisité.contains(where: { $0.marking == découvert.marking})) {
                              AVisité.append(découvert)
                          }
                      }
                    }
                  }
              }
              return NoeudInitial
          }


          private func VerOmega(marquage : CoverabilityMarking, liste : [CoverabilityGraph]) -> CoverabilityMarking {
            var ret = marquage
            for Noeud in liste {
                if ret > Noeud.marking{
                  for place in ret.keys {
                      if ret[place]! > Noeud.marking[place]! {
                        ret[place] = .omega
                      }
                  }
                  return ret
                }
            }
            return marquage
          }
      }

      public extension PTTransition {

      	public func isFireable(from marking: CoverabilityMarking) -> Bool {
      		for arc in self.preconditions {
            if case .some(let nb) = marking[arc.place]! {
              if nb < arc.tokens{
                return false
              }
      			}
      		}
          return true
      	}

      	public func fire(from marking: CoverabilityMarking) -> CoverabilityMarking? {
      		guard self.isFireable(from: marking) else {
              return nil
      		}
      		var result = marking

      		for arc in self.preconditions {
      			if case .some(let nb) = result[arc.place]! {
      				result[arc.place]! = .some(nb - arc.tokens)
      			}
      		}
      		for arc in self.postconditions {
      			if case .some(let nb) = result[arc.place]! {
      				result[arc.place]! = .some(nb + arc.tokens)
      			}
      		}
      		return result
      	}
      }
