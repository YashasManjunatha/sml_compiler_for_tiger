# Typechecker

> Duke University\
> CS 553: Compiler Construction\
> Professor Andrew Hilton\
> Spring 2020

### Team
Yashas Manjunatha (ym101)\
Trishul Nagenalli (tn74)\
Jason Wang (jw502)

We have finished the register allocator part of our compiler

### Special Functions

We implemented dynamic checking for number of callee-saved registers used. The 
program is initially compiled with no callee-saved registers and the program tries to 
recompile with one more s register until everything works. It tries up to all 8 callee 
save registers.

We have not implemented spilling. That said, we expect there to be very little chance 
of spilling. Since our liveness analysis is done at an instruction level, which can use 
use/define a maximum of 3 registers and we have over 20 registers, we believe the need 
for spilling would be limited to a very small set of programs.


