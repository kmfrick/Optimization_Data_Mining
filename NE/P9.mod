var x1 >=0;
var x2 >=0;
#var x1 >=0, integer;
#var x2 >=0, integer;


minimize P9:
-x1 -x2;

subject to c1: -2 * x1 +2 * x2 <= 5;
subject to c2: 2 * x2 <= 7;
subject to c3: 5 * x1 + 2 * x2 <= 26;
#subject to branch1: x1 >= 4;
#subject to gomory1: x1 + 2 * x2 <= 10;
#subject to chvatalgomory1: x2 <= 3;