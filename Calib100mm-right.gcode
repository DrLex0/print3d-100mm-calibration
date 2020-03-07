;- - - Extrude exactly 100mm of filament on the right extruder, for calibration purposes. - - -
;- - - by DrLex; 2017/07-2020/02. Released under Creative Commons Attribution License. - - -
;- Divide 100mm by the actual length of consumed filament to obtain the extrusion multiplier. -
;
T0; set primary extruder
M73 P0; enable show build progress

M104 S220 T0; Set extruder temperature here

G21; set units to mm
G90; set positioning to absolute
M320; acceleration enabled for all commands that follow
G162 X Y F8400; home XY axes maximum
G92 X0 Y0 Z0 E0 B0; set (rough) reference point (also set E and B to make GPX happy)
M132 X Y Z A B; recall home offsets
G1 X135 Y75 F1500; do a slow small move to allow Sailfish to initialise XY acceleration
G1 X0 Y0 F8400; center the right nozzle
G1 X40 Y-40 F6000
M6 T0; wait for extruder to heat up
M73 P1; pretend we're progressing
G92 E0; ensure this really is the zero extrusion coordinate

M300 S880 P300; beep
M71; Press OK to start   extruding 100mm     on right extruder

M70 P5; Extruding 100mm on  right extruder...

G1 F900.00; Feed rate for the extrusions. Each move is roughly the equivalent of extruding a 0.6mm wide line at 0.3mm thickness, at about 15mm/s. This should be slow enough for flexible filaments. If not, use a lower F number.

G1 X-40 Y-40 E5.00
G1 X-40 Y40 E10.00
G4 P0; prevent the next M73 command from being executed until we're really here
M73 P10; progress
G1 X40 Y40 E15.00
G1 X40 Y-40 E20.00
G4 P0
M73 P20; progress
G1 X-40 Y-40 E25.00
G1 X-40 Y40 E30.00
G4 P0
M73 P30; progress
G1 X40 Y40 E35.00
G1 X40 Y-40 E40.00
G4 P0
M73 P40; progress
G1 X-40 Y-40 E45.00
G1 X-40 Y40 E50.00
G4 P0
M73 P50; progress
G1 X40 Y40 E55.00
G1 X40 Y-40 E60.00
G4 P0
M73 P60; progress
G1 X-40 Y-40 E65.00
G1 X-40 Y40 E70.00
G4 P0
M73 P70; progress
G1 X40 Y40 E75.00
G1 X40 Y-40 E80.00
G4 P0
M73 P80; progress
G1 X-40 Y-40 E85.00
G1 X-40 Y40 E90.00
G4 P0
M73 P90; progress
G1 X40 Y40 E95.00
G1 X40 Y-40 E100.00

G4 P0
M73 P99; progress: almost done
; Make many stupid small moves to fill the pipeline and ensure Sailfish doesn't believe the print is already over when it hasn't even started.
G1 X1 Y20 F6000.00
G1 X1 Y19 F1000.00
G1 X2 Y19 F1000.00
G1 X2 Y18 F1000.00
G1 X3 Y18 F1000.00
G1 X3 Y17 F1000.00
G1 X4 Y17 F1000.00
G1 X4 Y16 F1000.00
G1 X5 Y16 F1000.00
G1 X5 Y15 F1000.00
G1 X6 Y15 F1000.00
G1 X6 Y14 F1000.00
G1 X7 Y14 F1000.00
G1 X7 Y13 F1000.00
G1 X8 Y13 F1000.00
G1 X8 Y12 F1000.00
G1 X9 Y12 F1000.00
G1 X9 Y11 F1000.00
G1 X10 Y11 F1000.00
G1 X10 Y10 F1000.00
G1 X11 Y10 F1000.00
G1 X11 Y9 F1000.00
G1 X12 Y9 F1000.00
G1 X12 Y8 F1000.00
G1 X13 Y8 F1000.00
G1 X13 Y7 F1000.00
G1 X14 Y7 F1000.00
G1 X14 Y6 F1000.00
G1 X15 Y6 F1000.00
G1 X15 Y5 F1000.00
G1 X16 Y5 F1000.00
G1 X16 Y4 F1000.00
G1 X17 Y4 F1000.00
G1 X17 Y3 F1000.00
G1 X18 Y3 F1000.00
G1 X18 Y2 F1000.00
G1 X19 Y2 F1000.00
G1 X19 Y1 F1000.00
G1 X20 Y1 F1000.00
G1 X20 Y0 F1000.00

M73 P100; end build progress
G4 P1000; show the fake 100% for one second
M109 S0 T0; set bed temperature to 0
M104 S0 T0; set 1st extruder temperature to 0
M104 S0 T1; set 2nd extruder temperature to 0
M18; disable all stepper motors
M70 P5; We <3 Calibrating   Things!
M72 P1; Play Ta-Da song
