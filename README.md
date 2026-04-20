## Project 4A

In this project I was implementing the `delta_debugging` funciton for
delta.py file, that finds one-minimal interesting set. Initial
implementation was using sets as the data entries, however, later, I
decided to use lists due to higher ease of implementation (partitioning)
and speed (less operations for partitioning and union)

## Project 4B

Figured out that patches should be applied in increasing order.
Additionally, only on this step I noticed that all the elements are
treated as strings in delta.py, not as integers. Implemented several
conversions into strings and back in delta.py script. Another bug
involved removing exit code 0 in is-failure-inducing-change.sh script
simply because the last operation was removal of temporaral files, not
the gcc compliation, therefore, causing it to be constantly 0 (fixed
with creation of `EXITCODE` varible)

## Project 4C

Initially coded interesting_sanity.sh so it runs all tests, then runs
the tests provided by the test file, and finally compares the results.
Later I changed it so it doesn't run all tests (since the result would
be the same) but just compares the result of running provided test files
with number for all tests.


I encountered with the following problem while running the picire:

```{bash}
  File ".../Project4/p4c/.venv/lib/python3.12/site-packages/picire/cache.py", line 146, in _evict
    self._evict(e, length - 1)
  [Previous line repeated 990 more times]
RecursionError: maximum recursion depth exceeded
```

Looking at the source code, it seems like the implementation decreases
length by 1. I am not sure what the length is, but if it somewhat
represents the number of tests, it might be the case that recursion hits
1000 call (Python limit), meanwhile, there are more than 1000 tests to
run. To resolve this problem, I:

1) in .venv/pyvenv.cfg changed `include-system-site-packages` to true

2) created .venv/lib/python3.12/site-packages/usercustomize.py file and
   wrote the following code:
    ```{python}
    import sys
    sys.setrecursionlimit(5000)
    ```
    This python module is imported before running the program, effectivelyq
    making the recursion limit set to 5000.

After running for several hours and 200 runs, the final one-minimal test file
contains 86 images.

