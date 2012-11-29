//
//  main.cpp
//  Random Sequence Experiment
//
//  Created by Xiyang Chen on 11/28/12.
//  Copyright (c) 2012 Xiyang Chen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
    std::cout << "Hello, World!\n";
    
    int m = 7;
    
    
    for(int i=1;i<=m;i++){
        int md = i%5; if(md ==0) md =5;
        int x = (m/5)*md+(i-1)/5;
        if(x>m) x = m-m%5-(x-m-1)*5;
        std::cout << x << ", ";
    }
    
    return 0;

}


