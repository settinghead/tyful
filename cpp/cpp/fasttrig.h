//
//  fasttrig.h
//  cpp
//
//  Created by Xiyang Chen on 12/22/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef cpp_fasttrig_h
#define cpp_fasttrig_h

//#define INV_PI 0.31830988618
//#define H 0.00002480158
//#define J 0.00138888888
//#define K 0.00416666666
//#define L 0.5
//inline
//double cos(double n)
//{
//    /// cos(x)  = sum[k=0..inf] (-1^k * x^(2*k)) / (2*k)!
//    ///         = sum[k=0..inf] -x^(2*k) / (2*k)!
//    ///        ~= sum[k=0..4]   -x^(2*k) / (2*k)!
//    /// cos(x) ~=  1 - x^2/2 + x^4/24 - x^6/720 + x^8 / 40320
//    /// cos(n) ~= (n^2*((n^2/40320 - 1/720)*n^2 + 1/24) - 1/2)*n^2 + 1
//    /// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//    
//    // m = n/PI
//    double m(n * INV_PI);
//    // m = int(n/PI+PI/2)
//    int im(m);
//    // get fractional, then scale to [-PI..+PI] domain
//    n = (m - im) * PI;
//    // get 'i'
//    double i = 1.0f - 2.0f * (im & 1);
//    
//    // compute n^2
//    double n2(n * n);
//    
//    // compute the serie expansion (shortcut for 4 terms)
//    return ((n2 * ((n2 * H - J) * n2 + K) - L) * n2 + 1.0) * i;
//}
//
//inline
//double sin(double n)
//{ 
//    return cos(HALF_PI - n);
//}

//inline double shift(double x) {
//    //always wrap input angle to -PI..PI
//    while (x < -3.14159265)
//        x += 6.28318531;
//    while (x > 3.14159265)
//        x -= 6.28318531;
//    return x;
//}
//
//inline double sin(double x) {
//    double sin = 0;
//    x = shift( x );
//    //compute sine
//    if (x < 0) {
//        sin = 1.27323954 * x + .405284735 * x * x;
//        if (sin < 0)
//            sin = .225 * (sin * -sin - sin) + sin;
//        else
//            sin = .225 * (sin * sin - sin) + sin;
//    } else {
//        sin = 1.27323954 * x - 0.405284735 * x * x;
//        if (sin < 0)
//            sin = .225 * (sin * -sin - sin) + sin;
//        else
//            sin = .225 * (sin * sin - sin) + sin;
//    }
//    return sin;
//}
//
//inline double cos(double x) {
//    double cos = 0;
//    //compute cosine: sin(x + PI/2) = cos(x)
//    x += 1.57079632;
//    if (x > 3.14159265)
//        x -= 6.28318531;
//    if (x < 0) {
//        cos    = 1.27323954 * x + 0.405284735 * x * x;
//        if (cos < 0)
//            cos = .225 * (cos *-cos - cos) + cos;
//        else
//            cos = .225 * (cos * cos - cos) + cos;
//    }
//    else
//    {
//        cos = 1.27323954 * x - 0.405284735 * x * x;
//        if (cos < 0)
//            cos = .225 * (cos *-cos - cos) + cos;
//        else
//            cos = .225 * (cos * cos - cos) + cos;
//    }
//    return cos;
//}

#endif
