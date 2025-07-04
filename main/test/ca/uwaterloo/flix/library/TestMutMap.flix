/*
 * Copyright 2020 Esben Bjerre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

mod TestMutMap {
    use MutMap.MutMap

    /////////////////////////////////////////////////////////////////////////////
    // toString                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toString01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        MutMap.toString(m) == "MutMap#{}"
    }

    @Test
    def toString02(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, 101, m);
        MutMap.toString(m) == "MutMap#{1 => 101}"
    }

    @Test
    def toString03(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, 101, m);
        MutMap.put(2, 102, m);
        MutMap.put(3, 103, m);
        MutMap.put(4, 104, m);
        MutMap.put(5, 105, m);
        MutMap.toString(m) == "MutMap#{1 => 101, 2 => 102, 3 => 103, 4 => 104, 5 => 105}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // sameElements                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def sameElements01(): Bool = region rc {
        let m1 = (MutMap.empty(rc): MutMap[Int32, Int32, _]);
        let m2 = (MutMap.empty(rc): MutMap[Int32, Int32, _]);
        MutMap.sameElements(m1, m2)
    }

    @Test
    def sameElements02(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, "a", m);

        let m2 = MutMap.empty(rc);
        MutMap.put(1, "a", m2);

        MutMap.sameElements(m, m2)
    }

    @Test
    def sameElements03(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, "a", m);
        MutMap.put(1, "b", m);

        let m2 = MutMap.empty(rc);
        MutMap.put(1, "a", m2);

        not MutMap.sameElements(m, m2)
    }

    @Test
    def sameElements04(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, "a", m);
        MutMap.put(2, "b", m);

        let m2 = MutMap.empty(rc);
        MutMap.put(1, "a", m2);

        not MutMap.sameElements(m, m2)
    }

    @Test
    def sameElements05(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(1, "a", m);

        let m2 = MutMap.empty(rc);
        MutMap.put(1, "a", m2);
        MutMap.put(2, "b", m2);

        not MutMap.sameElements(m, m2)
    }

    @Test
    def sameElements06(): Bool = region rc {
        let m = MutMap.empty(rc);
        MutMap.put(2, "b", m);
        MutMap.put(3, "c", m);
        MutMap.put(1, "a", m);

        let m2 = MutMap.empty(rc);
        MutMap.put(1, "a", m2);
        MutMap.put(2, "b", m2);
        MutMap.put(3, "c", m2);

        MutMap.sameElements(m, m2)
    }

    /////////////////////////////////////////////////////////////////////////////
    // mergeWithKey                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def merge01(): Bool = region rc {
        let m1 = (MutMap.empty(rc): MutMap[Int32, Int32, _]);
        let m2 = (MutMap.empty(rc): MutMap[Int32, Int32, _]);
        MutMap.mergeWithKey((_, v, _) -> v, m1, m2);
        MutMap.isEmpty(m2)
    }

    @Test
    def merge02(): Bool = region rc {
        let m1 = MutMap.empty(rc);
        let m2 = MutMap.empty(rc);
        MutMap.put(1, 0, m1);
        MutMap.put(2, 0, m2);
        MutMap.mergeWithKey((_, v, _) -> v, m1, m2);
        MutMap.memberOf(1, m2) and MutMap.memberOf(2, m2)
    }


    /////////////////////////////////////////////////////////////////////////////
    // sumValues                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def sumValues01(): Bool = region rc {
        MutMap.empty(rc) |> MutMap.sumValues == 0
    }

    @Test
    def sumValues02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |>
            MutMap.sumValues == 1
    }

    @Test
    def sumValues03(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3}) |>
            MutMap.sumValues == 6
    }

    @Test
    def sumValues04(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3, -3 => -3}) |>
            MutMap.sumValues == 3
    }

    @Test
    def sumValues05(): Bool = region rc {
        Map.toMutMap(rc, Map#{-1 => -1, -2 => -2, -3 => -3, -4 => -4}) |>
            MutMap.sumValues == -10
    }

    @Test
    def sumValues06(): Bool = region rc {
        Map.toMutMap(rc, Map#{10 => 10, -10 => -10}) |>
            MutMap.sumValues == 0
    }


    /////////////////////////////////////////////////////////////////////////////
    // sumKeys                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def sumKeys01(): Bool = region rc {
        MutMap.empty(rc) |> MutMap.sumKeys == 0
    }

    @Test
    def sumKeys02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |>
            MutMap.sumKeys == 1
    }

    @Test
    def sumKeys03(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3}) |>
            MutMap.sumKeys == 6
    }

    @Test
    def sumKeys04(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3, -3 => -3}) |>
            MutMap.sumKeys == 3
    }

    @Test
    def sumKeys05(): Bool = region rc {
        Map.toMutMap(rc, Map#{-1 => -1, -2 => -2, -5 => -3, -4 => -4}) |>
            MutMap.sumKeys == -12
    }

    @Test
    def sumKeys06(): Bool = region rc {
        Map.toMutMap(rc, Map#{10 => 10, -10 => -10}) |>
            MutMap.sumKeys == 0
    }


    /////////////////////////////////////////////////////////////////////////////
    // sumWith                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def sumWith01(): Bool = region rc {
        MutMap.empty(rc) |> MutMap.sumWith((k, v) -> k + v) == 0
    }

    @Test
    def sumWith02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |>
            MutMap.sumWith((k, v) -> k + v) == 2
    }

    @Test
    def sumWith03(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3}) |>
            MutMap.sumWith((k, v) -> k + v) == 12
    }

    @Test
    def sumWith04(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1, 2 => 2, 3 => 3, -3 => -3}) |>
            MutMap.sumWith((k, v) -> k + v) == 6
    }

    @Test
    def sumWith05(): Bool = region rc {
        Map.toMutMap(rc, Map#{-1 => -1, -2 => -2, -3 => -3, -4 => -4}) |>
            MutMap.sumWith((k, v) -> k + v) == -20
    }

    @Test
    def sumWith06(): Bool = region rc {
        Map.toMutMap(rc, Map#{10 => 10, -10 => -10}) |>
            MutMap.sumWith((k, v) -> k + v) == 0
    }


    /////////////////////////////////////////////////////////////////////////////
    // joinKeys                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def joinKeys01(): Bool = region rc {
        (MutMap.empty(rc): MutMap[Int32, Int32, _]) |> MutMap.joinKeys(",") == ""
    }

    @Test
    def joinKeys02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |> MutMap.joinKeys(",") == "1"
    }

    @Test
    def joinKeys03(): Bool = region rc {
        Map.toMutMap(rc, Map#{0 => 1, 1 => 2, 2 => 2}) |> MutMap.joinKeys(",") == "0,1,2"
    }

    @Test
    def joinKeys04(): Bool = region rc {
        Map.toMutMap(rc, Map#{"0" => 1, "1" => 2, "2" => 2}) |> MutMap.joinKeys(",") == "0,1,2"
    }


    /////////////////////////////////////////////////////////////////////////////
    // joinValues                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def joinValues01(): Bool = region rc {
        (MutMap.empty(rc): MutMap[Int32, Int32, _]) |> MutMap.joinValues(",") == ""
    }

    @Test
    def joinValues02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |> MutMap.joinValues(",") == "1"
    }

    @Test
    def joinValues03(): Bool = region rc {
        Map.toMutMap(rc, Map#{0 => 1, 1 => 2, 2 => 2}) |> MutMap.joinValues(",") == "1,2,2"
    }

    @Test
    def joinValues04(): Bool = region rc {
        Map.toMutMap(rc, Map#{0 => "1", 1 => "2", 2 => "2"}) |> MutMap.joinValues(",") == "1,2,2"
    }


    /////////////////////////////////////////////////////////////////////////////
    // joinWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def joinWith01(): Bool = region rc {
        (MutMap.empty(rc): MutMap[Int32, Int32, _]) |>
            MutMap.joinWith((k, v) -> "${k} => ${v}", ",") == ""
    }

    @Test
    def joinWith02(): Bool = region rc {
        Map.toMutMap(rc, Map#{1 => 1}) |>
            MutMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "1 => 1"
    }

    @Test
    def joinWith03(): Bool = region rc {
        Map.toMutMap(rc, Map#{0 => 1, 1 => 2, 2 => 2}) |>
            MutMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "0 => 1, 1 => 2, 2 => 2"
    }

    @Test
    def joinWith04(): Bool = region rc {
        Map.toMutMap(rc, Map#{0 => "1", 1 => "2", 2 => "2"}) |>
            MutMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "0 => 1, 1 => 2, 2 => 2"
    }

    /////////////////////////////////////////////////////////////////////////////
    // toMutDeque                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toMutDeque01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        let d1 = MutMap.toMutDeque(rc, m);

        let d2 = MutDeque.empty(rc);

        d1 `MutDeque.sameElements` d2
    }

    @Test
    def toMutDeque02(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2});
        let d1 = MutMap.toMutDeque(rc, m);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushBack((1, 2), d2);

        d1 `MutDeque.sameElements` d2
    }

    @Test
    def toMutDeque03(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2, 3 => 4, 5 => 6});
        let d1 = MutMap.toMutDeque(rc, m);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushBack((3, 4), d2);
        MutDeque.pushBack((5, 6), d2);
        MutDeque.pushFront((1, 2), d2);

        d1 `MutDeque.sameElements` d2
    }

    @Test
    def toMutDeque04(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 'a', 2 => 'b', 3 => 'c'});
        let d1 = MutMap.toMutDeque(rc, m);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushFront((3, 'c'), d2);
        MutDeque.pushFront((2, 'b'), d2);
        MutDeque.pushFront((1, 'a'), d2);

        d1 `MutDeque.sameElements` d2
    }


    /////////////////////////////////////////////////////////////////////////////
    // toList                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toList01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        MutMap.toList(m) == (List#{} : List[(Int32, Int32)])
    }

    @Test
    def toList02(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2});
        MutMap.toList(m) == List#{(1, 2)}
    }

    @Test
    def toList03(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2, 3 => 4, 5 => 6});
        MutMap.toList(m) == List#{(1, 2), (3, 4), (5, 6)}
    }

    @Test
    def toList04(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 'a', 2 => 'b', 3 => 'c'});
        MutMap.toList(m) == List#{(1, 'a'), (2, 'b'), (3, 'c')}
    }

    /////////////////////////////////////////////////////////////////////////////
    // toVector                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toVector01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        MutMap.toVector(m) == (Vector#{} : Vector[(Int32, Int32)])
    }

    @Test
    def toVector02(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2});
        MutMap.toVector(m) == Vector#{(1, 2)}
    }

    @Test
    def toVector03(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2, 3 => 4, 5 => 6});
        MutMap.toVector(m) == Vector#{(1, 2), (3, 4), (5, 6)}
    }

    @Test
    def toVector04(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 'a', 2 => 'b', 3 => 'c'});
        MutMap.toVector(m) == Vector#{(1, 'a'), (2, 'b'), (3, 'c')}
    }

    /////////////////////////////////////////////////////////////////////////////
    // toArray                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toArray01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        Array.sameElements(MutMap.toArray(rc, m), Array#{} @ rc)
    }

    @Test
    def toArray02(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2});
        Array.sameElements(MutMap.toArray(rc, m), Array#{(1, 2)} @ rc)
    }

    @Test
    def toArray03(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2, 3 => 4, 5 => 6});
        Array.sameElements(MutMap.toArray(rc, m), Array#{(1, 2), (3, 4), (5, 6)} @ rc)
    }

    @Test
    def toArray04(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 'a', 2 => 'b', 3 => 'c'});
        Array.sameElements(MutMap.toArray(rc, m), Array#{(1, 'a'), (2, 'b'), (3, 'c')} @ rc)
    }

    /////////////////////////////////////////////////////////////////////////////
    // toSet                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def toSet01(): Bool = region rc {
        let m: MutMap[Int32, Int32, _] = MutMap.empty(rc);
        MutMap.toSet(m) == (Set#{} : Set[(Int32, Int32)])
    }

    @Test
    def toSet02(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2});
        MutMap.toSet(m) == Set#{(1, 2)}
    }

    @Test
    def toSet03(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 2, 3 => 4, 5 => 6});
        MutMap.toSet(m) == Set#{(1, 2), (3, 4), (5, 6)}
    }

    @Test
    def toSet04(): Bool = region rc {
        let m = Map.toMutMap(rc, Map#{1 => 'a', 2 => 'b', 3 => 'c'});
        MutMap.toSet(m) == Set#{(1, 'a'), (2, 'b'), (3, 'c')}
    }

    /////////////////////////////////////////////////////////////////////////////
    // forEach                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def forEach01(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.forEach((k, v) -> Ref.put(k+v, ri), m);
        21 == Ref.get(ri)
    }

    @Test
    def forEach02(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.put(0, 100, m);
        MutMap.forEach((k, v) -> Ref.put(k+v, ri), m);
        100 == Ref.get(ri)
    }

    @Test
    def forEach03(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.put(0, 100, m);
        MutMap.put(1, 101, m);
        MutMap.put(2, 102, m);
        MutMap.forEach((k, v) -> Ref.put(k+v, ri), m);
        104 == Ref.get(ri)
    }

    /////////////////////////////////////////////////////////////////////////////
    // forEachWithIndex                                                        //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def forEachWithIndex01(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.forEachWithIndex((i, _, _) -> Ref.put(i, ri), m);
        21 == Ref.get(ri)
    }

    @Test
    def forEachWithIndex02(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.put(0, 100, m);
        MutMap.forEachWithIndex((i, _, _) -> Ref.put(i, ri), m);
        0 == Ref.get(ri)
    }

    @Test
    def forEachWithIndex03(): Bool = region rc {
        let m = MutMap.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutMap.put(0, 100, m);
        MutMap.put(1, 101, m);
        MutMap.put(2, 102, m);
        MutMap.forEachWithIndex((i, _, _) -> Ref.put(i, ri), m);
        2 == Ref.get(ri)
    }

}

