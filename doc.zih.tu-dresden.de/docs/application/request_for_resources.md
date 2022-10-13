# Request for Resources

Important note: ZIH systems run Linux. Thus, for effective work, you should know your way around
Linux based systems and the Bash Shell. Beginners can find a lot of tutorials on the internet.

## Determine the Required CPU and GPU Hours

ZIH systems are focused on data-intensive computing. They are meant to be used for highly
parallelized code. Please take that into account when migrating sequential code from a local
machine to our HPC systems. To estimate your execution time when executing your previously
sequential program in parallel, you can use [Amdahl's law][1]. Think in advance about the
parallelization strategy for your project and how to effectively use HPC resources.

## Available Software

Pre-installed software on our HPC systems is managed via [modules][2]. You can see the list of
software that's already installed and accessible via module [here][3]. However, there are many
different variants of these modules available. We have divided these into two different software
environments: `scs5` (for regular partitions) and `ml` (for the Machine Learning partition). Within
each environment there are further dependencies and variants.

[1]: https://en.wikipedia.org/wiki/Amdahl%27s_law
[2]: https://doc.zih.tu-dresden.de/software/modules/
[3]: https://gauss-allianz.de/de/application?organizations%5B0%5D=1200
