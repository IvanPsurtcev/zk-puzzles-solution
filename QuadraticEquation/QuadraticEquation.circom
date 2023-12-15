pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create a Quadratic Equation( ax^2 + bx + c ) verifier using the below data.
// Use comparators.circom lib to compare results if equal

template QuadraticEquation() {
    signal input x;     // x value
    signal input a;     // coeffecient of x^2
    signal input b;     // coeffecient of x 
    signal input c;     // constant c in equation
    signal input res;   // Expected result of the equation
    signal output out;  // If res is correct , then return 1 , else 0 . 

    signal one;
    signal two;
    signal three;
    signal four;
    signal five;

    one <== x * x;
    two <== a * one;
    three <== b * x;
    four <==  two + three + c;
    five <-- res == four;
    out <== five;
}

component main  = QuadraticEquation();



