mod Test.Exp.Effect {

    // no test annotations for now
    // just making it public for redundancy purposes
    // @test
    pub def handleEff01(): Bool = {
        run true with handler Fail {
            def fail(_, _cont) = false
        }
    }

    // @test
    pub def handleEff02(): Unit = {
        run () with handler Fail {
            def fail(_, cont) = cont()
        }
    }

    // @test
    pub def perform01(): Unit \ Fail = {
        Test.Exp.Effect.Fail.fail(":(")
    }

    // @test
    pub def perform02(): Bool = {
        run {
            Test.Exp.Effect.Console.println("hi");
            Test.Exp.Effect.Console.println("bye");
            true
        } with handler Console {
            def println(_, cont) = cont()
        }
    }

    // @test
    pub def handlePerform01(): Unit = {
        run Test.Exp.Effect.Fail.fail("rats") with handler Fail {
            def fail(_, _cont) = ()
        }
    }

    // @test
    pub def handlePerform02(): Bool = {
        run {
            let _ = Test.Exp.Effect.Console.println("It was the best of times");
            true
        } with handler Console {
            def println(_, cont) = cont()
        }
    }

    pub def without01(): Bool = true without Fail

    pub def without02(): Bool = true without {Fail, Console}

    pub def singleEffect(): Bool \ Fail = ???

    pub def complementEffect(): Bool \ ~Fail = ???

    pub def unionEffect(): Bool \ Fail + Fail = ???

    pub def intersectionEffect(): Bool \ Fail & Fail = ???

    pub def differenceEffect(): Bool \ Fail - Fail = ???

    pub def singlePolyEffect(): Bool \ ef1 = ???

    pub def complementPolyEffect(): Bool \ ~ef1 = ???

    pub def unionPolyEffect(): Bool \ ef1 + ef2 = ???

    pub def intersectionPolyEffect(): Bool \ ef1 & ef2 = ???

    pub def differencePolyEffect(): Bool \ ef1 - ef2 = ???

    pub def effectSet01(): Bool \ { Fail } = ???

    pub def effectSet02(): Bool \ { Fail, Fail } = ???

    pub def effectSet03(): Bool \ { Fail, Fail, Console } = ???

    pub def effectSet04(): Bool \ {} = ???

    pub def polyEffectSet01[ef: Eff](): Bool \ ef = ???

    pub def polyEffectSet02[ef: Eff](): Bool \ { ef, Fail } = ???

    pub def arrowWithEffect01(f: a -> b \ {}): Bool = ???

    pub def arrowWithEffect02(f: a -> b \ ef - Fail): Bool = ???

    pub def arrowWithEffect03(f: a -> b \ Console + (ef - Fail)): Bool = ???

    pub def enumWithEffect01(f: Do[{}]): Bool = ???

    pub def enumWithEffect02(f: Do[{ef}]): Bool = ???

    pub def enumWithEffect03(f: Do[{ef, Fail}]): Bool = ???

    pub def enumWithEffect04(f: Do[ef - Fail]): Bool = ???

    pub def enumWithEffect05(f: Do[Console + (ef - Fail)]): Bool = ???

    eff Fail {
        def fail(x: String): Unit
    }

    eff Console {
        def println(x: String): Unit
    }

    pub enum Do[ef: Eff](Unit -> Unit \ ef)

    // Testing effect parsing and set semantics
    pub eff A
    pub eff B
    pub eff C
    def f(): Unit \ {A, B, C} - {B} + {C} = ???
    pub def g(): Unit \ ({A, B, C} - {B}) + {C} = f()
    pub def h(): Unit \ {A, C} = f()
}
