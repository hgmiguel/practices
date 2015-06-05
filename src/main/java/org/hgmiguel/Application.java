package org.hgmiguel;

import org.hgmiguel.service.Binomial;
import org.hgmiguel.service.ArithmeticProgression;
import org.hgmiguel.service.OddElement;
import java.util.Arrays;

public class Application {
  public static void main(String[] args) {
    OddElement ap = new OddElement();
    int[] elements2 = {9,9,-1,8,8,-1,-7,-7,0};
    System.out.println(ap.oddElementJava7( elements2 ));
    int[] elements = { 4, 2, 1, 6, 6, 4, 1 };

    System.out.println(ap.oddElementJava7( elements ));
//    System.out.println(ap.oddElementJava7( {-1} ));
    System.out.println("XXXXXX");
  }

}
