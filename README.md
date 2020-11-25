# Rubik's Nim

Rubik's-nim is a nim library that provides a representation of and common functions for the Rubiks cube.

Features

- Cube datatype
- Functions for every WCA FMC legal move (including primes and double moves, excluding M, E, and S)
- cubeRepr function, which provides an easy way to display the cube inside the terminal
- `<-` macro, which allows for easy feeding of moves via `cube <- (R, U, Rp, Up)` instead of `cube.R; cube.F; cube.Rp; cube.Up`

Upcoming

- Rotations (ie rotating the entire cube in different directions, tentative)
- Solver (probably Thistlewaite algorithm)
- Scrambler

## Thistlethwaite Algorithm explanation

Let `G = <L, R, F, B, U, D>`, `G1 =  <L, R, F, B, U2, D2>`, `G3 =  <L, R, F2, B2, U2, D2>`, `G4 =  <L2, R2, F2, B2, U2, D2>`. Note how each sucessive group excludes some moves from those prior (notably, allowing U turns allow for U2 and Uprime moves, but only allowing a U2 move allows nothing but a U2 move)

A basic plan then can be to go from group G_i to G_i+1