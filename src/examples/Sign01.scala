package examples

import domains.Sign
import impl.Runner
import impl.logic._
import impl.runtime.{Hint, Representation}
import syntax.Symbols._

object Sign01 {

  def main(args: Array[String]): Unit = {

    val X = Symbol.PredicateSymbol("X")
    val Y = Symbol.PredicateSymbol("Y")
    val R = Symbol.PredicateSymbol("R")

    val facts = List(
      HornClause(Predicate(X, List(Term.Constructor0("Sign.Pos")))),
      HornClause(Predicate(Y, List(Term.Constructor0("Sign.Neg"))))
    )

    val clauses = List(
      HornClause(head = Predicate(R, List(Term.Variable("x"))), body = List(Predicate(X, List(Term.Variable("x"))))),
      HornClause(head = Predicate(R, List(Term.Variable("x"))), body = List(Predicate(Y, List(Term.Variable("x")))))
    )

    val interpretations = Map(
      X -> Interpretation.Relation,
      Y -> Interpretation.Relation,
      R -> Interpretation.Lattice
    )

    val hints = Map(
      X -> Hint(Representation.Data),
      Y -> Hint(Representation.Data),
      R -> Hint(Representation.Data)
    ) ++ Sign.Hints

    val lattices = Map(
      R -> Sign.lattice
    )

    val program = Program(facts ::: clauses ::: Sign.lattice.clauses, interpretations, lattices)

    Runner.run(program, hints)
  }

}
