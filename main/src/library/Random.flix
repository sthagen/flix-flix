/*
 *  Copyright 2024 Magnus Madsen
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
///
/// An effect used to generate random numbers.
///
pub eff Random {

    ///
    /// Returns a pseudorandom boolean value with equal probability of being `true` or `false`.
    ///
    def randomBool(): Bool

    ///
    /// Returns a pseudorandom 32-bit floating-point number in the range [0.0, 1.0].
    ///
    def randomFloat32(): Float32

    ///
    /// Returns a pseudorandom 64-bit floating-point number in the range [0.0, 1.0].
    ///
    def randomFloat64(): Float64

    ///
    /// Returns a pseudorandom 32-bit integer.
    ///
    def randomInt32(): Int32

    ///
    /// Returns a pseudorandom 64-bit integer.
    ///
    def randomInt64(): Int64

    ///
    /// Returns a 64-bit floating point number following a standard normal (Gaussian) distribution.
    ///
    def randomGaussian(): Float64

}

mod Random {

    import java.util.{Random => JRandom}

    ///
    /// Handles the `Random` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Random` effect using the `NonDet` and `IO` effects.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Random) + {NonDet, IO} =
        x -> {
            let rnd = new JRandom(); // Reuse Random instance.
            run {
                f(x)
            } with handler Random {
                def randomBool(k)       = k(rnd.nextBoolean())
                def randomFloat32(k)    = k(rnd.nextFloat())
                def randomFloat64(k)    = k(rnd.nextDouble())
                def randomInt32(k)      = k(rnd.nextInt())
                def randomInt64(k)      = k(rnd.nextLong())
                def randomGaussian(k)   = k(rnd.nextGaussian())
            }
        }

    ///
    /// Runs the `Random` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Random` effect using the `NonDet` and `IO` effects.
    ///
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Random) + {NonDet, IO} = handle(f)()

    ///
    /// Runs the `Random` effect of the given function `f` from an initial seed.
    ///
    /// In other words, re-interprets the `Random` effect using seeded deterministic randomness.
    ///
    pub def handleWithSeed(seed: Int64, f: a -> b \ ef): a -> b \ ef - Random = {
        // Given a specifc seed, JRandom is just a mutable iterator and therefore we type it as such.
        x -> region local {
            let _ = local; // avoid redundancy check
            let rnd = unchecked_cast (new JRandom(seed) as _ \ local);
            run {
                f(x)
            } with handler Random {
                def randomBool(k)       = k(unchecked_cast (rnd.nextBoolean() as _ \ local))
                def randomFloat32(k)    = k(unchecked_cast (rnd.nextFloat() as _ \ local))
                def randomFloat64(k)    = k(unchecked_cast (rnd.nextDouble() as _ \ local))
                def randomInt32(k)      = k(unchecked_cast (rnd.nextInt() as _ \ local))
                def randomInt64(k)      = k(unchecked_cast (rnd.nextLong() as _ \ local))
                def randomGaussian(k)   = k(unchecked_cast (rnd.nextGaussian() as _ \ local))
            }
        }
    }

    ///
    /// Runs the `Random` effect of the given function `f` from an initial seed.
    ///
    /// In other words, re-interprets the `Random` effect using seeded deterministic randomness.
    ///
    pub def runWithSeed(seed: Int64, f: Unit -> a \ ef): a \ ef - Random = handleWithSeed(seed, f)()

}
