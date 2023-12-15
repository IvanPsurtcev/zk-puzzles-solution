pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";


/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/

template CheckSumAndMul () {
    signal input in[4]; 
    signal output Sum;
    signal output Mul;

    var sum = 0;
    var mul1 = 1;
    var mul2 = 1;
    for(var q = 0; q < 4; q++) {
        sum += in[q]; 
        log("sum: ", sum);
        if (q % 4 == 0 || q % 4 == 1) {
            mul1 = mul1 * in[q]; 
            log("mul1: ", mul1);
        } else {
            mul2 = mul2 * in[q]; 
            log("mul2: ", mul2);
        }
        
    }
    Sum <-- sum; // 10
    Mul <-- mul1 * mul2; // 24
}

template Sudoku () {
    // Question Setup 
    signal input  question[16];
    signal input solution[16];
    signal output out;
    
    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log("solution[v],question[v]: ", solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    var correct;

    // checking the sum and mul of each row
    component checkRow[4];
    component sumRow[4];
    component mulRow[4];
    
    for(var q = 0; q < 4; q++) {
        checkRow[q] = CheckSumAndMul();
        sumRow[q] = IsEqual();
        mulRow[q] = IsEqual();

        for(var i = 0; i < 4; i++) {
            log("solution[q*4+i]: ", solution[q*4+i]);
            checkRow[q].in[i] <== solution[q*4+i];
        }

        log("checkRow[q].Mul: ", checkRow[q].Mul);
        checkRow[q].Mul ==> mulRow[q].in[0];
        24 ==> mulRow[q].in[1];
        log("checkRow[q].Sum: ", checkRow[q].Sum);
        checkRow[q].Sum ==> sumRow[q].in[0];
        10 ==> sumRow[q].in[1];
        log("correct0: ", correct);
        correct += sumRow[q].out + mulRow[q].out;
        log("correct1: ", correct);
    }

    //checking the sum and mul of each column
    component checkColumn[4];
    component sumCol[4];
    component mulCol[4];

    for(var q = 0; q < 4; q++) {
        checkColumn[q] = CheckSumAndMul();
        sumCol[q] = IsEqual();
        mulCol[q] = IsEqual();
        var k = 0;
        for (var i = 0; i < 16; i++) {
            if (i%4 == q) {
                log("solution[i]: ", solution[i]);
                checkColumn[q].in[k] <== solution[i];
                k += 1;
            }
        }
    }
    
    for(var q = 0; q < 4; q++) {
        log("checkColumn[q].Mul: ", checkColumn[q].Mul);
        checkColumn[q].Mul ==> mulCol[q].in[0];
        24 ==> mulCol[q].in[1];
        log("checkColumn[q].Sum: ", checkColumn[q].Sum);
        checkColumn[q].Sum ==> sumCol[q].in[0];
        10 ==> sumCol[q].in[1];
        log("correct2: ", correct);
        correct += sumCol[q].out + mulCol[q].out;
        log("correct3: ", correct);
    }

    component finalCheck = IsEqual();
    finalCheck.in[0] <== correct;
    finalCheck.in[1] <== 16;
    out <== finalCheck.out;
}

component main = Sudoku();
