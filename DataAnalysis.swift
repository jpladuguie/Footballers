//
//  DataAnalysis.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 30/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation


//https://www.fourmilab.ch/rpkp/experiments/analysis/zCalc.js

var Z_MAX: Float = 6.0;                    // Maximum ąz value
var ROUND_FLOAT = 6;              // Decimal places to round numbers

/*  The following JavaScript functions for calculating normal and
 chi-square probabilities and critical values were adapted by
 John Walker from C implementations
 written by Gary Perlman of Wang Institute, Tyngsboro, MA
 01879.  Both the original C code and this JavaScript edition
 are in the public domain.  */

/*  POZ  --  probability of normal z value
 
 Adapted from a polynomial approximation in:
 Ibbetson D, Algorithm 209
 Collected Algorithms of the CACM 1963 p. 616
 Note:
 This routine has six digit accuracy, so it is only useful for absolute
 z values <= 6.  For z values > to 6.0, poz() returns 0.0.
 */

func poz(z: Float) -> Float {
    var y: Float
    var x: Float
    var w: Float
    
    if (z == 0.0) {
        x = 0.0
    } else {
        y = 0.5 * abs(z)
        if (y > (Z_MAX * 0.5)) {
            x = 1.0
        } else if (y < 1.0) {
            w = y * y
            x = ((((((((0.000124818987 * w
                - 0.001075204047) * w + 0.005198775019) * w
                - 0.019198292004) * w + 0.059054035642) * w
                - 0.151968751364) * w + 0.319152932694) * w
                - 0.531923007300) * w + 0.797884560593) * y * 2.0
        } else {
            y -= 2.0
            x = (((((((((((((-0.000045255659 * y
                + 0.000152529290) * y - 0.000019538132) * y
                - 0.000676904986) * y + 0.001390604284) * y
                - 0.000794620820) * y - 0.002034254874) * y
                + 0.006549791214) * y - 0.010557625006) * y
                + 0.011630447319) * y - 0.009279453341) * y
                + 0.005353579108) * y - 0.002141268741) * y
                + 0.000535310849) * y + 0.999936657524
        }
    }
    return z > 0.0 ? ((x + 1.0) * 0.5) : ((1.0 - x) * 0.5)
}


/*  CRITZ  --  Compute critical normal z value to
 produce given p.  We just do a bisection
 search for a value within CHI_EPSILON,
 relying on the monotonicity of pochisq().  */

func critz(p: Float) -> Float {
    let Z_EPSILON: Float = 0.000001     /* Accuracy of z approximation */
    var minz: Float = -Z_MAX
    var maxz: Float = Z_MAX
    var zval: Float = 0.0
    var pval: Float
    
    if (p < 0.0 || p > 1.0) {
        return -1
    }
    
    while ((maxz - minz) > Z_EPSILON) {
        pval = poz(z: zval)
        if (pval > p) {
            maxz = zval
        } else {
            minz = zval
        }
        zval = (maxz + minz) * 0.5
    }
    return(zval)
}

func calcRating(value: Float) -> Int {
    let prob = Float(1.0-(value/2184.0))
    let z = critz(p: prob)
    
    return(Int(50.0 + 15.0*z))
}


