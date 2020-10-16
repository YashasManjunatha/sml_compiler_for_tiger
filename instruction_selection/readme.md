# Typechecker

> Duke University\
> CS 553: Compiler Construction\
> Professor Andrew Hilton\
> Spring 2020

### Team
Yashas Manjunatha (ym101)\
Trishul Nagenalli (tn74)\
Jason Wang (jw502)

We have finished the instruction selection phase of our compiler.

#### Optimizations

We have optimizations that take advantage of MIPS's offset(reg) syntax to perform 
address load/stores and arithmetic in the same instruction. We have also 
implemented an optimization to take advantage of MIPS' jal LABEL instead of 
loading the label into a register and then jumping to that register.
