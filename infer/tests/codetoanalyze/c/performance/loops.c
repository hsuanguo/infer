/*
 * Copyright (c) 2018-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
// j is not a control var, so shouldn't affect the bound
int if_in_loop(int t) {
  int p = 0;
  int j = t + 1;
  for (int i = 0; i < 5; i++) {
    if (j < 2) {
      p++;
    } else {
      p = 3;
      for (int k = 0; k < 10; k++) {
        int m = 0;
      }
    }
  }
  return p;
}

// j is not a control var, so shouldn't affect the bound
int if_out_loop(int t) {
  int p = 10;
  int j = t + 10;
  if (j < 2) {
    p++;
  } else {
    p = 3;
    for (int k = 0; k < 100; k++) {
      int m = 0;
    }
  }
  return p;
}
