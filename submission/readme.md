# Final Compiler

Yashas Manjunatha (ym101)
Trishul Nagenalli (tn74)
Jason Wang (jw502)

We would like to submit our final compiler. We have tested it on merge.tig, queens.tig, and factorial.tig. Please see the test folders 
for the tests we were primarily working with
  - `tests/semanticfix`
  - `tests/factorial`
  - `tests/queens`
  - `tests/merge`

We would like this submission to correct some errors we had in previous submissions as well:

Semantics Phase:
- Fails to detect cyclic types, compiler isntead stalls infinitely (-5%)
    - Circular types cause errors as shown in `tests/semanticfix/circulartypes.tig`
- duplicate type names in recursive group not detected (-5%)
    - Duplicate type names cause errors as shown in `tests/semanticfix/duptypes.tig`
- duplicate function names in recursive group not detected (-5%)
    - Duplicate function names cause errors as shown in `tests/semanticfix/dupfuncnames.tig`
- type mismatches on correct declerations, caused by user defined array types being subscripted (see test42 for example*) (-3%)
    - Unaddressed
- index variable should be unassignable (-5%)
    - Index variables are not assignalble
- nil list intializations should not cause errors (-5%)
    - Nil initialization for record arrays no longer throw errors, but will throw errors for non-record type arrays as shown in `tests/semanticfix/nilinit.tig`

IR and Instruction Selection Phases

- arguments not being passed between procedures correctly, a regs being used to pass to the function, however the callee doesn't use the a reg to refer to the passed value (ex. test27) -3
    - This is resolved. All arguments are assumed to escape and are stored into memory during the prologue and loaded at the start of a given function.
- process/program doesn't exit -4
    - We are not able to reproduce this error
- extraneous stores to addresses that will end up seg faulting (ex. test27) -5
    - Stack allocation happens at the beginning of the prologue and deallocation happens at the end. Test 27 Runs smoothly
- should use initarray to initialize an array instead of malloc (ex. test1)(and if you were going to use malloc, you would not pass in 10 as arr size, would be 40) -3
    - We use init array
- need an init value for arrays -1
    - We initialize with correctly
- some temp names are incorrect/malformed (ex. test5 'd0)
    - No temps are malformed
- string formatiing incorrect -3
    - Strings are formatted correctly in mips assembly and are printable now
- LA shold be used for strings/labels -1
    - Labels are marked in assembly as LA1 rather than L1
- no nil checks for records -2
    - When records are initialized, they must be set to non-nil value, or a type must be annotated.
