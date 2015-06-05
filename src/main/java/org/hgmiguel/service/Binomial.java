package org.hgmiguel.service;

import java.lang.Math;

public class Binomial {

  int binomial(Integer n, int k) {
      if (k < 0 || k > n) {
            return 0;
          }
      if (k == 0 || k == n) {
            return 1;
          }
  
      int symerick = Math.min(k, n - k);
      int c = 1;
      for(int i =  0; i < symerick; i++) {
            c = c * ((n -i) / (i + 1));
          }
      return c;
  }


public  int[] PascalRow(int n) {
    int[] result = new int[n + 1];
      for (int row = 0; row < n + 1; row++) {
            result[row] = binomial(n, row);
          }
      return result;
  
  }


}

