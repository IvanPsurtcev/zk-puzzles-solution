pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.
include "../node_modules/circomlib/circuits/comparators.circom";

template Equality() {
   signal input a[3];
   signal output c;

   component equals1 = IsEqual();
   a[0] ==> equals1.in[0];
   a[1] ==> equals1.in[1];

   component equals2 = IsEqual();
   a[1] ==> equals2.in[0];
   a[2] ==> equals2.in[1];

   c <== equals1.out * equals2.out;

   // other solution
   // signal result;
   // result <-- a[0] == a[1] && a[0] == a[2];
   // c <== result;
}

component main = Equality();