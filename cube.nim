import strformat, macros

macro `<-`*(l: untyped, funcs: untyped) : untyped =
    result = newStmtList()
    for f in funcs:
        result.add(nnkDotExpr.newTree(ident($l), ident($f)))

type
    initState* = enum
        solved, scrambled

type
    Cube* = object
        f*, b*, u*, d*, r*, l* : array[9, char]

func initCube*(state : initState) : Cube =
    if state == solved:
        return Cube(f : ['g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g'], 
                u : ['w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w'], 
                b : ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'], 
                d : ['y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y'], 
                l : ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o'], 
                r : ['r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r'])
    else:
        return Cube(f : ['g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g'], # Temporary, Will add a scrambling functionality event
            u : ['w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w'], 
            b : ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'], 
            d : ['y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y'], 
            l : ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o'], 
            r : ['r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r'])

func reflect(i, tp : int | float) : int | float =
    return tp - i + tp

func printCube*(cube : Cube) : string =
    return &"""

                            {cube.u[0]}  {cube.u[1]}  {cube.u[2]}
                            {cube.u[3]}  {cube.u[4]}  {cube.u[5]}
                            {cube.u[6]}  {cube.u[7]}  {cube.u[8]}

       {cube.b[0]}  {cube.b[1]}  {cube.b[2]}   {cube.l[0]}  {cube.l[1]}  {cube.l[2]}    {cube.f[0]}  {cube.f[1]}  {cube.f[2]}   {cube.r[0]}  {cube.r[1]}  {cube.r[2]}
       {cube.b[3]}  {cube.b[4]}  {cube.b[5]}   {cube.l[3]}  {cube.l[4]}  {cube.l[5]}    {cube.f[3]}  {cube.f[4]}  {cube.f[5]}   {cube.r[3]}  {cube.r[4]}  {cube.r[5]}
       {cube.b[6]}  {cube.b[7]}  {cube.b[8]}   {cube.l[6]}  {cube.l[7]}  {cube.l[8]}    {cube.f[6]}  {cube.f[7]}  {cube.f[8]}   {cube.r[6]}  {cube.r[7]}  {cube.r[8]}
    
                            {cube.d[0]}  {cube.d[1]}  {cube.d[2]}
                            {cube.d[3]}  {cube.d[4]}  {cube.d[5]}
                            {cube.d[6]}  {cube.d[7]}  {cube.d[8]}
                            """

func swapStickersVerti(a, b : var array[9, char], i : int, swapnum : int) =
    if swapnum == 2:
        a[i].swap(b[i.reflect(1) + 6])
        a[i + 3].swap(b[i.reflect(1) + 3])
        a[i + 6].swap(b[i.reflect(1)])
    else:
        a[i].swap(b[i])
        a[i + 3].swap(b[i + 3])
        a[i + 6].swap(b[i + 6])

func swapStickersHori(a, b : var array[9, char], i, swapnum : int) =
    if swapnum == 1:
        if i == 2:
            a[i].swap(b[8])
            a[i + 3].swap(b[7])
            a[i + 6].swap(b[6])
        else:
            a[i].swap(b[2])
            a[i + 3].swap(b[1])
            a[i + 6].swap(b[0])
    elif swapnum == 2:
        a[i].swap(b[i.reflect(1) + 6])
        a[i + 3].swap(b[i.reflect(1) + 3])
        a[i + 6].swap(b[i.reflect(1)])
    elif swapnum == 3:
        if i == 0:
            a[i].swap(b[6])
            a[i + 3].swap(b[7])
            a[i + 6].swap(b[8])
        else:           
            a[i].swap(b[0])
            a[i + 3].swap(b[1])
            a[i + 6].swap(b[2])

func swapStickersSkew(a, b : var array[9, char], i, swapnum : int) =
    a[i].swap(b[i])
    a[i + 1].swap(b[i + 1])
    a[i + 2].swap(b[i + 2])

func rotf(a : var array[9, char], prime : bool) =
    if prime:
        swap(a[0], a[6]) # Corners
        swap(a[0], a[8])
        swap(a[0], a[2])

        swap(a[1], a[3]) # Edges
        swap(a[1], a[7])
        swap(a[1], a[5])
    else:  
        swap(a[0], a[2])
        swap(a[0], a[8])
        swap(a[0], a[6])

        swap(a[1], a[5])
        swap(a[1], a[7])
        swap(a[1], a[3])

func verti(cube : var Cube, i : int, a, b, c, d : var array[9, char], prime : bool, e : var array[9, char] ) =
    if prime:
        a.swapStickersVerti(d, i, 3)
        a.swapStickersVerti(c, i, 2)
        a.swapStickersVerti(b, i, 1)
    else:
        a.swapStickersVerti(b, i, 1)
        a.swapStickersVerti(c, i, 2)
        a.swapStickersVerti(d, i, 3)
    e.rotf(prime)

func hori(cube : var Cube, i : int, a, b, c, d : var array[9, char], prime : bool, e : var array[9, char]) =
    if prime:
        a.swapStickersHori(d, i, 3)
        a.swapStickersHori(c, i, 2)
        a.swapStickersHori(b, i, 1)
    else:
        a.swapStickersHori(b, i, 1)
        a.swapStickersHori(c, i, 2)
        a.swapStickersHori(d, i, 3)

func skew(cube : var Cube, i : int, a, b, c, d : var array[9, char], prime : bool, e : var array[9, char]) =
    if prime:
        a.swapStickersSkew(d, i, 1)
        a.swapStickersSkew(c, i, 2)
        a.swapStickersSkew(b, i, 3)
    else:
        a.swapStickersSkew(b, i, 3)
        a.swapStickersSkew(c, i, 2)
        a.swapStickersSkew(d, i, 1)

func R*(cube: var Cube) =
    cube.verti(2, cube.f, cube.u, cube.b, cube.d, false, cube.r)

func L*(cube : var Cube) =
    cube.verti(0, cube.f, cube.d, cube.b, cube.u, false, cube.l)

func Rp*(cube: var Cube) =
    cube.verti(2, cube.f, cube.u, cube.b, cube.d, true, cube.r)

func Lp*(cube : var Cube) =
    cube.verti(0, cube.f, cube.d, cube.b, cube.u, true, cube.l)

func F*(cube: var Cube) =
    cube.hori(2, cube.l, cube.u, cube.r, cube.d, false, cube.f)
    cube.f.rotf(false)

func Fp*(cube: var Cube) =
    cube.hori(2, cube.l, cube.u, cube.r, cube.d, true, cube.f)
    cube.f.rotf(true)

func B*(cube: var Cube) =
    cube.hori(0, cube.l, cube.u, cube.r, cube.d, true, cube.b)
    cube.b.rotf(false)

func Bp*(cube: var Cube) =
    cube.hori(0, cube.l, cube.u, cube.r, cube.d, false, cube.b)
    cube.b.rotf(true)

func U*(cube: var Cube) =
    cube.skew(0, cube.f, cube.r, cube.b, cube.l, true, cube.u)
    cube.u.rotf(false)

func Up*(cube: var Cube) =
    cube.skew(0, cube.f, cube.r, cube.b, cube.l, false, cube.u)
    cube.u.rotf(true)

func D*(cube: var Cube) =
    cube.skew(6, cube.f, cube.r, cube.b, cube.l, false, cube.d)
    cube.d.rotf(false)

func Dp*(cube: var Cube) =
    cube.skew(6, cube.f, cube.r, cube.b, cube.l, true, cube.d)
    cube.d.rotf(true)

func R2*(cube: var Cube) =
    cube.R; cube.R

func L2*(cube : var Cube) =
    cube.L; cube.L

func U2*(cube: var Cube) =
    cube.U; cube.U

func D2*(cube: var Cube) =
    cube.D; cube.D

func F2*(cube: var Cube) =
    cube.F; cube.F

func B2*(cube : var Cube) =
    cube.B; cube.B

var cube = initCube(solved)
echo cube.printCube