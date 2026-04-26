## Project 4A

In this project I was implementing the `delta_debugging` funciton for
delta.py file, that finds one-minimal interesting set. Initial
implementation was using sets as the data entries, however, later, I
decided to use lists due to higher ease of implementation (partitioning)
and speed (less operations for partitioning and union). Another fix
included removing logger (it wasn't getting on with a testing system for
some reason), as well as parsing the command arguments with
`shlex.split()` (see [sources](#sources)) in order to run first token of
the passed string command as a separate command.

## Project 4B

Figured out that patches should be applied in increasing order.
Additionally, only on this step I noticed that all the elements are
treated as strings in delta.py, not as integers. Implemented several
conversions into strings and back in delta.py script. Another bug
involved removing exit code 0 in is-failure-inducing-change.sh script
simply because the last operation was removal of temporaral files, not
the gcc compliation, therefore, causing it to be constantly 0 (fixed
with creation of `EXITCODE` varible). I also added running the patch
command with -s option, which makes running it in sielent.

## Project 4C

interesting_sanity.sh script is a script, that gets a testing file with
all global path pngs to test as an argument, then runs pngtest for all
the testing images possible, erases gcovr data and does the same thing
for images in the testing file. If the number of lines from testing file
is the same or greater than number of lines from all files, then script
exits with status code 0 (which is interpreted as interesting by
picire), otherwise, return 1 (not interesting).

Initially coded interesting_sanity.sh so it runs all tests, then runs
the tests provided by the test file, and finally compares the results.
Later I changed it so it doesn't run all tests (since the result would
be the same) but just compares the result of running provided test files
with number for all tests. This way, it reduced the time at least by half.


I encountered with the following problem while running the picire:

```
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
   (see [sources](#sources) for reference to manual)

2) created .venv/lib/python3.12/site-packages/usercustomize.py file and
   wrote the following code:
    ```
    import sys
    sys.setrecursionlimit(5000)
    ```
    This python module is imported before running the program, effectivelyq
    making the recursion limit set to 5000.

After running for several hours and 200 runs, the final one-minimal test
file contains 86 images, that get the same 4092 lines covered as all the
initial testing files. One-minimal test files means that we couldn't
extract a single image from there to not decrease the coverage. 

The reason why it was running for so long is because each run of the
test images takes a lot of time, and since it increases graduality over
and over again, it runs over a lot of the same images with every
iteration. Taking into account that folder with all tests images weights
9.3 Mbytes (in every run there are many calls of
is-failure-inducing-change.sh), it goes over gygabytes of processing
data. One of the possible options to optimize it though is to initially
put all the images on RAM instead of openning and closing them over and
over for every call of interesting_sanity.sh.

Overall, delta debugging showed that it could substantially decrease the
testing dataset size by almost 95% (from 1639 to 86 pngs) without loss
in effectiveness metrics (such as line coverage). This could be very
important for the testing step of CI pipeline and safe substantial
amount of time of the developers.  

## Sources

- <https://docs.python.org/3/library/site.html> - site specific
  configuration reference, used to increase recursion limit in part 4C 

- <https://docs.python.org/3/library/subprocess.html#popen-constructor>
  - popen constructor + `shlex.split()` used in part 4A

- <https://myslu.stlawu.edu/~kangstadt/teaching/spring26/340/p4.html> -
  project 4 description and instructions. If the source is not found
  here, it is highly likely to be found there

