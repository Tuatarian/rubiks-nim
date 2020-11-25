# Rubik's Nim

Rubik's-nim is a nim library that provides a representation of and common functions for the Rubiks cube.

Features

- Cube datatype
- Functions for every WCA FMC legal move (including primes and double moves, excluding M, E, and S)
- cubeRepr function, which provides an easy way to display the cube inside the terminal
- `<-` macro, which allows for easy feeding of moves via `cube <- (R, U, Rp, Up)` instead of `cube.R; cube.F; cube.Rp; cube.Up`