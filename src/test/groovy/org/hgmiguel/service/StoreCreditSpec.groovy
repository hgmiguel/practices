package org.hgmiguel.service

import org.hgmiguel.service.codejam.StoreCredit

import spock.lang.Specification
import spock.lang.Unroll

class StoreCreditSpec extends Specification{

  @Unroll
  void "simple case" () {
    setup:
    int n = 3
    StoreCredit storeCredit = new StoreCredit()

    when:
    List<Integer> out = storeCredit.solve(credit, inputSize, input)

    then:
    out == output
    where:
    credit|inputSize| input|| output
    100|3|[5, 75, 25]|| [2,3]
    200|7|[150,24, 79, 50, 88, 345, 3] || [1, 4]
    8|8|[2, 1, 9, 4, 4, 56, 90, 3] || [4, 5]
  }

  @Unroll
  void "test a input file"() {
    setup:
    StoreCredit storeCredit = new StoreCredit()

    when:
    String output = storeCredit.writeOutPut(fileInput)
    then:
    output
    where:
    fileInput << ["test", "small", "large"]
  }

}
