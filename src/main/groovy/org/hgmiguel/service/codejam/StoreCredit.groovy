package org.hgmiguel.service.codejam

import groovy.transform.CompileStatic

class StoreCredit {
  String inOutDirectory = "src/test/resource/" 
  List<Integer> solve(int credit, int inputSize, List<Integer> input){
    List<Integer> output
    inputSize.times {x ->
      if(output)
        return
      input[x..-1].eachWithIndex {e, i ->
        if(output)
          return
        if(x != i+x&& input[x] + e == credit) {
          output = [x + 1, i+x+1]
        }
      }
    }
    output
  }

  String writeOutPut(String fileInput) {
    File inputFile = new File("${inOutDirectory}${fileInput}.txt")
    File outputFile = new File("${inOutDirectory}${fileInput}Output.txt")
    outputFile.withWriter {writer -> 
      inputFile.withReader { reader ->
        Integer cases = reader.readLine().toInteger()
        cases.times{noCase -> 
          Integer credit = reader.readLine().toInteger()
          Integer inputSize = reader.readLine().toInteger()
          List<Integer> input = reader.readLine().split(" ").collect{it.toInteger()}
          List<Integer> output = solve(credit, inputSize, input)
          writer.write ("Case #${noCase+1}: ${output.join(" ")}\n")
        }
      }
    }
    "${inOutDirectory}${fileInput}Output.txt"
  }



}

