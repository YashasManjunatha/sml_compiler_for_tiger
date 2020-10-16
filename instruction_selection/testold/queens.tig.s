

Instructions 
L105:
addi $t386 $r0 8
sw $t386 ~4($fp)
addi $t387 $fp ~8
addi $t382 $t387 0
lw $t388 malloc
lw $t389 ~4($fp)
addi $a0 $t389 0
jal $t388
addi $t366 $v0 0
addi $t390 $r0 0
addi $t367 $t390 0
lw $t392 ~4($fp)
sub $t391 $t367 $t392
 bgtz $t391 L106
L107:
add $t393 $t366 $t367
addi $t394 $r0 0
sw $t393 $t394
lw $t396 ~4($fp)
sub $t395 $t367 $t396
 bltz $t395 L108
L108:
addi $t397 $t367 1
addi $t367 $t397 0
lw $t398 L107
j $t398
L106:
sw $t382 $t366
addi $t399 $fp ~12
addi $t383 $t399 0
lw $t400 malloc
lw $t401 ~4($fp)
addi $a0 $t401 0
jal $t400
addi $t368 $v0 0
addi $t402 $r0 0
addi $t369 $t402 0
lw $t404 ~4($fp)
sub $t403 $t369 $t404
 bgtz $t403 L109
L110:
add $t405 $t368 $t369
addi $t406 $r0 0
sw $t405 $t406
lw $t408 ~4($fp)
sub $t407 $t369 $t408
 bltz $t407 L111
L111:
addi $t409 $t369 1
addi $t369 $t409 0
lw $t410 L110
j $t410
L109:
sw $t383 $t368
addi $t411 $fp ~16
addi $t384 $t411 0
lw $t412 malloc
lw $t415 ~4($fp)
lw $t416 ~4($fp)
add $t414 $t415 $t416
addi $t413 $t414 -1
addi $a0 $t413 0
jal $t412
addi $t370 $v0 0
addi $t417 $r0 0
addi $t371 $t417 0
lw $t421 ~4($fp)
lw $t422 ~4($fp)
add $t420 $t421 $t422
addi $t419 $t420 -1
sub $t418 $t371 $t419
 bgtz $t418 L112
L113:
add $t423 $t370 $t371
addi $t424 $r0 0
sw $t423 $t424
lw $t428 ~4($fp)
lw $t429 ~4($fp)
add $t427 $t428 $t429
addi $t426 $t427 -1
sub $t425 $t371 $t426
 bltz $t425 L114
L114:
addi $t430 $t371 1
addi $t371 $t430 0
lw $t431 L113
j $t431
L112:
sw $t384 $t370
addi $t432 $fp ~20
addi $t385 $t432 0
lw $t433 malloc
lw $t436 ~4($fp)
lw $t437 ~4($fp)
add $t435 $t436 $t437
addi $t434 $t435 -1
addi $a0 $t434 0
jal $t433
addi $t372 $v0 0
addi $t438 $r0 0
addi $t373 $t438 0
lw $t442 ~4($fp)
lw $t443 ~4($fp)
add $t441 $t442 $t443
addi $t440 $t441 -1
sub $t439 $t373 $t440
 bgtz $t439 L115
L116:
add $t444 $t372 $t373
addi $t445 $r0 0
sw $t444 $t445
lw $t449 ~4($fp)
lw $t450 ~4($fp)
add $t448 $t449 $t450
addi $t447 $t448 -1
sub $t446 $t373 $t447
 bltz $t446 L117
L117:
addi $t451 $t373 1
addi $t373 $t451 0
lw $t452 L116
j $t452
L115:
sw $t385 $t372
lw $t453 L119
addi $t454 $r0 0
addi $a0 $t454 0
jal $t453
addi $v0 $v0 0
lw $t455 L152
j $t455
L152:


Instructions 
L119:
lw $t457 ($fp)
lw $t456 ~4($t457)
beq $t375 $t456 L149
L149:
lw $t458 L118
jal $t458
addi $t381 $v0 0
lw $t459 L151
j $t459
L150:
addi $t460 $r0 0
sw $t460 ~4($fp)
lw $t462 ~4($fp)
lw $t465 ($fp)
lw $t464 ~4($t465)
addi $t463 $t464 -1
sub $t461 $t462 $t463
 bgtz $t461 L133
L147:
lw $t469 ($fp)
lw $t468 ~8($t469)
lw $t471 ~4($fp)
addi $t472 $r0 4
mult $t471 $t472
 mflo $t470
add $t467 $t468 $t470
lw $t466 ($t467)
addi $t473 $r0 0
beq $t466 $t473 L136
L136:
addi $t474 $r0 1
addi $t376 $t474 0
lw $t478 ($fp)
lw $t477 ~16($t478)
lw $t481 ~4($fp)
add $t480 $t481 $t375
addi $t482 $r0 4
mult $t480 $t482
 mflo $t479
add $t476 $t477 $t479
lw $t475 ($t476)
addi $t483 $r0 0
beq $t475 $t483 L134
L135:
addi $t484 $r0 0
addi $t376 $t484 0
L134:
addi $t377 $t376 0
lw $t485 L138
j $t485
L137:
addi $t486 $r0 0
addi $t377 $t486 0
L138:
addi $t487 $r0 0
bne $t487 $t377 L141
L141:
addi $t488 $r0 1
addi $t378 $t488 0
lw $t492 ($fp)
lw $t491 ~20($t492)
lw $t496 ~4($fp)
addi $t495 $t496 7
sub $t494 $t495 $t375
addi $t497 $r0 4
mult $t494 $t497
 mflo $t493
add $t490 $t491 $t493
lw $t489 ($t490)
addi $t498 $r0 0
beq $t489 $t498 L139
L140:
addi $t499 $r0 0
addi $t378 $t499 0
L139:
addi $t379 $t378 0
lw $t500 L143
j $t500
L142:
addi $t501 $r0 0
addi $t379 $t501 0
L143:
addi $t502 $r0 0
bne $t502 $t379 L144
L144:
lw $t505 ($fp)
lw $t504 ~8($t505)
lw $t507 ~4($fp)
addi $t508 $r0 4
mult $t507 $t508
 mflo $t506
add $t503 $t504 $t506
addi $t509 $r0 1
sw $t503 $t509
lw $t512 ($fp)
lw $t511 ~16($t512)
lw $t515 ~4($fp)
add $t514 $t515 $t375
addi $t516 $r0 4
mult $t514 $t516
 mflo $t513
add $t510 $t511 $t513
addi $t517 $r0 1
sw $t510 $t517
lw $t520 ($fp)
lw $t519 ~20($t520)
lw $t524 ~4($fp)
addi $t523 $t524 7
sub $t522 $t523 $t375
addi $t525 $r0 4
mult $t522 $t525
 mflo $t521
add $t518 $t519 $t521
addi $t526 $r0 1
sw $t518 $t526
lw $t529 ($fp)
lw $t528 ~12($t529)
addi $t531 $r0 4
mult $t375 $t531
 mflo $t530
add $t527 $t528 $t530
lw $t532 ~4($fp)
sw $t527 $t532
lw $t533 L119
addi $t534 $t375 1
addi $a0 $t534 0
jal $t533
lw $t537 ($fp)
lw $t536 ~8($t537)
lw $t539 ~4($fp)
addi $t540 $r0 4
mult $t539 $t540
 mflo $t538
add $t535 $t536 $t538
addi $t541 $r0 0
sw $t535 $t541
lw $t544 ($fp)
lw $t543 ~16($t544)
lw $t547 ~4($fp)
add $t546 $t547 $t375
addi $t548 $r0 4
mult $t546 $t548
 mflo $t545
add $t542 $t543 $t545
addi $t549 $r0 0
sw $t542 $t549
lw $t552 ($fp)
lw $t551 ~20($t552)
lw $t556 ~4($fp)
addi $t555 $t556 7
sub $t554 $t555 $t375
addi $t557 $r0 4
mult $t554 $t557
 mflo $t553
add $t550 $t551 $t553
addi $t558 $r0 0
sw $t550 $t558
addi $t559 $r0 0
addi $t380 $t559 0
lw $t560 L146
j $t560
L145:
addi $t561 $r0 0
addi $t380 $t561 0
L146:
lw $t563 ~4($fp)
lw $t566 ($fp)
lw $t565 ~4($t566)
addi $t564 $t565 -1
sub $t562 $t563 $t564
 bltz $t562 L148
L148:
lw $t568 ~4($fp)
addi $t567 $t568 1
sw $t567 ~4($fp)
lw $t569 L147
j $t569
L133:
addi $t570 $r0 0
addi $t381 $t570 0
L151:
addi $v0 $t381 0
lw $t571 L153
j $t571
L153:


Instructions 
L118:
addi $t572 $r0 0
sw $t572 ~4($fp)
lw $t574 ~4($fp)
lw $t577 ($fp)
lw $t576 ~4($t577)
addi $t575 $t576 -1
sub $t573 $t574 $t575
 bgtz $t573 L120
L130:
addi $t578 $r0 0
sw $t578 ~8($fp)
lw $t580 ~8($fp)
lw $t583 ($fp)
lw $t582 ~4($t583)
addi $t581 $t582 -1
sub $t579 $t580 $t581
 bgtz $t579 L121
L127:
lw $t587 ($fp)
lw $t586 ~12($t587)
lw $t589 ~4($fp)
addi $t590 $r0 4
mult $t589 $t590
 mflo $t588
add $t585 $t586 $t588
lw $t584 ($t585)
lw $t591 ~8($fp)
beq $t584 $t591 L124
L124:
lw $t592 L122
addi $t374 $t592 0
lw $t593 L126
j $t593
L125:
lw $t594 L123
addi $t374 $t594 0
L126:
lw $t595 print
addi $a0 $t374 0
jal $t595
lw $t597 ~8($fp)
lw $t600 ($fp)
lw $t599 ~4($t600)
addi $t598 $t599 -1
sub $t596 $t597 $t598
 bltz $t596 L128
L128:
lw $t602 ~8($fp)
addi $t601 $t602 1
sw $t601 ~8($fp)
lw $t603 L127
j $t603
L121:
lw $t604 print
lw $t605 L129
addi $a0 $t605 0
jal $t604
lw $t607 ~4($fp)
lw $t610 ($fp)
lw $t609 ~4($t610)
addi $t608 $t609 -1
sub $t606 $t607 $t608
 bltz $t606 L131
L131:
lw $t612 ~4($fp)
addi $t611 $t612 1
sw $t611 ~4($fp)
lw $t613 L130
j $t613
L120:
lw $t614 print
lw $t615 L132
addi $a0 $t615 0
jal $t614
addi $v0 $v0 0
lw $t616 L154
j $t616
L154:
L132("
")L129("
")L123(" .")L122(" O")