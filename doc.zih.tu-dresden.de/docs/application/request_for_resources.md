# Request for Resources

Important note: ZIH systems run Linux. Thus for effective work, you should know your way around Linux based systems and the Bash Shell. Beginners can find a lot of tutorials on the internet.

## Determine the Required CPU and GPU Hours

ZIH systems are focused on data-intensive computing. They are meant to be used for highly parallelized code. Please take that into account when transferring sequential code from a local machine. To estimate your execution time when executing your previously sequential program parallely, you can use [Amdahl's law][1]. Think in advance about the parallelization strategy for your project.

## Available Software

It is good practice for working on HPC clusters to use software and packages with parallelization wherever possible. Open-source software is more preferable than proprietary software. You can check for already installed software at the [Software module list][2]. However, the majority of popular programming languages, scientific applications, software and packages can be installed on the HPC cluster using different dependencies. There are [two different software environments](../software/modules.md) implementing these varying dependencies: `scs5` (the regular one) and `ml` (environment for the Machine Learning partition). When looking for your software, keep in mind that it needs to work on Linux.

[1]: https://en.wikipedia.org/wiki/Amdahl%27s_law
[2]: https://gauss-allianz.de/de/application?organizations%5B0%5D=1200

