package org.hgmiguel.service;

public class ArithmeticProgression {
    public int SumOfFunctions(int m, int n) {
      if (n == 0) {
          return m + 1;
        }
      return SumOfFunctions(m +1, n - 1);
    }

}
