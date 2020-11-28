// Written in the V programming language
// Compile with v -prod -autofree damm.v

import os
import time
import strings

[inline]
const (
  qg10_matrix = [
    [0,3,1,7,5,9,8,6,4,2],[7,0,9,2,1,5,4,8,6,3],
    [4,2,0,6,8,7,1,3,5,9],[1,7,5,0,9,8,3,4,2,6],
    [6,1,2,3,0,4,5,9,7,8],[3,6,7,4,2,0,9,5,8,1],
    [5,8,6,9,7,2,0,1,3,4],[8,9,4,5,3,6,2,0,1,7],
    [9,4,3,8,6,1,7,2,0,5],[2,5,8,1,4,3,6,7,9,0],
  ]
)

[inline]
fn numstr_gen(n int) string {
  mut sb := strings.new_builder(n)
  sb.write('1234567890'.repeat(n))
  return sb.str()
}

[inline]
fn check_digit(s string) ?int {
  mut num := 0
  for i, chr in s {
    if !chr.is_digit() {
      return error('Characters other than digits are not allowed.')
    }
    if i == 0 && chr == `0` {
      return error('Invalid number (leading zeros).')
    }
    num = qg10_matrix[num][chr - `0`]
  }
  return int(num)
}

[inline]
fn calc(s string) {
  println('Testing a number ' + s.len.str() + ' digits long...')
  mut d := 0
  sw := time.new_stopwatch({})
  d = check_digit(s) or {
    println(err)
    return
  }
  t := sw.elapsed().nanoseconds() / 100 + 1
  match d {
    0 {
      println('Valid number.')
    }
    else {
      println('Invalid number (but can be made valid appending $d).')
    }
  }
  println('(Calculated in less than $t hnsec.)')
  return
}

fn main() {
  println('Damm verification algorithm')
  arg := os.args
  match arg.len {
    1 { calc(numstr_gen(100_000)) }
    2 { calc(arg[1]) }
    else {
      println('Too many arguments.\nYou must pass a number.')
    }
  }
}
