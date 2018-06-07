/*
 * Copyright (c) 2018-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
package codetoanalyze.java.performance;

public class Break{
/* t is also in control variables but once we have invariant analysis, it shouldn't be */
private static int break_loop(int p, int t){
for (int i = 0; i < p; i++) {
  // do something
  if (t < 0)
    break;
  // do something
}
 return 0;
}


/* calling break_loop with a negative t should give constant
   cost. Currently, this doesn't work because parameters are removed
   when computing the env size :( */
private static int break_constant(int p)
{
  return break_loop(p, -1);
}

}
