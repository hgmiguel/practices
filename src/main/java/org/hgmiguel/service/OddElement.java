package org.hgmiguel.service;

public class OddElement {
/*
  public int oddElement(int[] a) {
    return Arrays.stream(a)
      .boxed()
      .collect(Collectors.groupingBy(i -> i, Collectors.counting()))
      .entrySet()
      .stream()
      .min(Map.Entry.comparingByValue(Long::compareTo))
      .get()
      .getKey();
  }
*/

  public int oddElementJava7(int[] a) {
    for(int c :a) {
      int f = -1;
      for(int j: a) {
        if (c == j) 
          f++;
      }
      if(f == 0) 
          return c;
    }
    return a[0];
  }
}
