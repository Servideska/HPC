# Software Development and Tools

This section provides you with the basic knowledge and tools for software development
on the ZIH systems.
It will tell you:

- How to compile your code
    - [General advises for building software](building_software.md)
    - [Using compilers](compilers.md)
    - [GPU programming](gpu_programming.md)
- How to use libraries
    - [Using mathematical libraries](math_libraries.md)
- How to deal with (or even prevent) bugs
    - [Find caveats and hidden errors in MPI application codes](mpi_usage_error_detection.md)
    - [Using debuggers](debuggers.md)
- [How to investigate the performance and efficiency of your code](performance_engineering_overview.md)

!!! hint "Some general, helpful hints"

    - Stick to standards wherever possible, e.g. use the `-std` flag
      for CLANG, GNU and Intel C/C++ compilers. Computers are short living
      creatures, migrating between platforms can be painful. In addition,
      running your code on different platforms greatly increases the
      reliably. You will find many bugs on one platform that never will be
      revealed on another.
    - Compile your code with optimization, e.g. `-O2` will turn on a moderate level of optimization
      where most optimization algorithms are applied. Please refer to the specific documentation of
      your compiler of choice for detailed information.
    - Before and during performance tuning: Make sure that your code delivers the correct results.

!!! questions "Some questions you should ask yourself"

    - Given that a code is parallel, are the results independent from the
      numbers of threads or processes?
    - Have you ever run your Fortran code with array bound and subroutine argument checking (the
      `-check all` and `-traceback` flags for the Intel compilers)?
    - Have you checked that your code is not causing floating point exceptions?
    - Does your code work with a different link order of objects?
    - Have you made any assumptions regarding storage of data objects in memory?
