# Content Guide Lines

!!! cite "George Bernard Shaw"

    The golden rule is that there are no golden rules.

!!! cite "Proverb"

    There is an exception to every rule.

This page holds <del>rules</del> guide lines regarding the layout, content, and writing of this
documentation. The goals are to provide a comprehensive, consistent, up-to-date and well-written
documentation that is pure joy to read and use. It shall help to find answers and provide knowledge
instead of being the bottleneck and a great annoyance. Therefore, it need some guide lines which are
outlined in the following.

## Pages Structure and New Page

The pages structure is defined in the configuration file `mkdocs.yaml`:

```Bash
nav:
  - Home: index.md
  - Application for Login and Resources:
    - Overview: application/overview.md
    - Terms: application/terms_of_use.md
    - Request for Resources: application/request_for_resources.md
    - Project Request Form: application/project_request_form.md
    - Project Management: application/project_management.md
  - Access to ZIH Systems:
    - Overview: access/overview.md
  [...]
```

Follow these two steps to add a new page to the documentation:

1. Create a new markdown file under `docs/subdir/file_name.md` and put the documentation inside.
The sub-directory and file name should follow the pattern `fancy_title_and_more.md`.
1. Add `subdir/file_name.md` to the configuration file `mkdocs.yml` by updating the navigation
   section. Yes, the order of files is crucial and defines the structure of the content. Thus,
   carefully consider the right spot and section for the new page.

Make sure that the new page **is not floating**, i.e., it can be reached directly from
the documentation structure.

## Markdown

All this documentation is written in markdown. Please keep things simple, i.e., avoid using fancy
markdown dialects.

* [Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
* [Style Guide](https://github.com/google/styleguide/blob/gh-pages/docguide/style.md)


### Graphics and Attachments

Images and graphics are an important part of technical documentation. This also holds for this HPC
compendium. Thus, we encourage you to add images and graphics for illustration purposes.

Attachments may be used to provide a more detailed documentation or further outline a certain
process and topic.

All images, graphics and attachments are stored in the `misc` subdirectory of the corresponding
section.

!!! example "Syntax"

    ```markdown
    ![Alternative text](misc/<graphics_file>)
    {: align="center"}
    ```

The attribute `align` is optional. By default, graphics are left aligned. **Note:** It is crucial to
have `{: align="center"}` on a new line.

!!! warning

    Do not add large binary files or high resolution images to the repository. See this valuable
    document for [image optimization](https://web.dev/fast/#optimize-your-images).


### Admonitions

[Admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/), also known as
call-outs, may be actively used to highlight examples, warnings, tips, important information etc.
Admonitions are an excellent choice for including side content without significantly interrupting
the document flow.

Several different admonitions are available within the material theme, e.g., `note`, `info`,
`example`, `tip`, `warning` and `cite`.
Please refer to the
[documentation page](https://squidfunk.github.io/mkdocs-material/reference/admonitions/#supported-types)
for a comprehensive overview.

All admonitions blocks start with `!!! <type>` and the following content block is indented by
(exactly) four spaces.

!!! example "Syntax"

    ```markdown
    !!! note

        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
        tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
        vero eos et accusam et justo duo dolores et ea rebum.
    ```

#### Folding

Admonitions can be made foldable by using `???` instead of `!!!`. A small toggle on the right side
is displayed. The block is open by default if `???+` is used. Long code examples should be folded by
default.

#### Title

The title corresponds to the admonition type. However, the title of an admonition can be changed for
further decoration by providing the desired title as quoted string after the type qualifier.

```markdown

!!! note "Random title"

    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
    tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
    vero eos et accusam et justo duo dolores et ea rebum.
```

## Writing Style

* Capitalize headings, e.g. *Exclusive Reservation of Hardware*
* Give keywords in link texts, e.g. [Code Blocks](#code-blocks-and-syntax-highlighting) is way more
  descriptive than [this subsection](#code-blocks-and-syntax-highlighting).
* Use active over passive voice
    * Write with confidence. This confidence should be reflected in the documentation, so that
      the readers trust and follow it.
    * Example: `We recommend something` instead of `Something is recommended.`
* Write directly to the readers/users, e.g., use `you can/have` instead of `users can/have`
* If there are multiple ways of doing things, recommend one over the others and justify

## Spelling and Technical Wording

To provide a consistent and high quality documentation, and help users to find the right pages,
there is a list of conventions w.r.t. spelling and technical wording.

* Language settings: en_us

| Do | Don't |
|----|-------|
| I/O | IO |
| Slurm | SLURM |
| filesystem(s) | file system(s) |
| ZIH system(s) | Taurus, HRSKII, our HPC systems, etc. |
| workspace | work space |
|       | HPC-DA |
| partition `ml` | ML partition, ml partition, `ml` partition, "ml" partition, etc. |



## Code Blocks and Command Prompts

Showing commands and sample output is an important part of all technical documentation. To make
things as clear for readers as possible and provide a consistent documentation, some guide lines have to
be followed.

1. Use ticks to mark code blocks and commands, not italic font.
1. Specify language for code blocks ([see below](#code-blocks-and-syntax-highlighting)).
1. All code blocks and commands should be runnable from a login node or a node within a specific
   partition (e.g., `ml`).
1. It should be clear from the [prompt](#prompts), where the command is run (e.g., local machine,
   login node or specific partition).

### Long Options

We use long over short parameter names where possible to ease understanding.

!!! example

    `srun --nodes=2 --ntasks-per-node=4 ...` is preferred over `srun -N 2 -n 4 ...`

Use `module` over the short front-end `ml` in documentation and examples.

### Prompts

We follow this rules regarding prompts to make clear where a certain command or example is executed.
This should help to avoid errors.

| Host/Partition         | Prompt           |
|------------------------|------------------|
| Login nodes            | `marie@login$`   |
| Arbitrary compute node | `marie@compute$` |
| `haswell` partition    | `marie@haswell$` |
| `ml` partition         | `marie@ml$`      |
| `alpha` partition      | `marie@alpha$`   |
| `romeo` partition      | `marie@romeo$`   |
| `julia` partition      | `marie@julia$`   |
| Localhost              | `marie@local$`   |

* **Always use a prompt**, even there is no output provided for the shown command.
* All code blocks which specify some general command templates, e.g. containing `<` and `>`
  (see [Placeholders](#mark-placeholders)), should use `bash` for the code block. Additionally,
  an example invocation, perhaps with output, should be given with the normal `console` code block.
  See also [Code Block description below](#code-blocks-and-syntax-highlighting).
* Using some magic, the prompt as well as the output is identified and will not be copied!
* Stick to the [generic user name](#data-privacy-and-generic-user-name) `marie`.

### Code Blocks and Syntax Highlighting

This project makes use of the extension
[pymdownx.highlight](https://squidfunk.github.io/mkdocs-material/reference/code-blocks/) for syntax
highlighting.  There is a complete list of supported
[language short codes](https://pygments.org/docs/lexers/).

For consistency, use the following short codes within this project:

With the exception of command templates, use `console` for shell session and console:

````markdown
```console
marie@login$ ls
foo
bar
```
````

Make sure that shell session and console code blocks are executable on the login nodes of HPC system.

Command templates use [Placeholders](#mark-placeholders) to mark replaceable code parts. Command
templates should give a general idea of invocation and thus, do not contain any output. Use a
`bash` code block followed by an invocation example (with `console`):

````markdown
```bash
marie@local$ ssh -NL <local port>:<compute node>:<remote port> <zih login>@tauruslogin.hrsk.tu-dresden.de
```

```console
marie@local$ ssh -NL 5901:172.24.146.46:5901 marie@tauruslogin.hrsk.tu-dresden.de
```
````

Also use `bash` for shell scripts such as job files:

````markdown
```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --output=slurm-%j.out

module load foss

srun a.out
```
````


`python` for Python source code:

````markdown
```python
from time import gmtime, strftime
print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
```
````

`pycon` for Python console:

````markdown
```pycon
>>> from time import gmtime, strftime
>>> print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
2021-08-03 07:20:33
```
````

Line numbers can be added via

````markdown
```bash linenums="1"
#!/bin/bash

#SBATCH -N 1
#SBATCH -n 23
#SBATCH -t 02:10:00

srun a.out
```
````

_Result_:

![lines](misc/lines.png)

Specific Lines can be highlighted by using

```` markdown
```bash hl_lines="2 3"
#!/bin/bash

#SBATCH -N 1
#SBATCH -n 23
#SBATCH -t 02:10:00

srun a.out
```
````

_Result_:

![lines](misc/highlight_lines.png)

### Data Privacy and Generic User Name

Where possible, replace login, project name and other private data with clearly arbitrary placeholders.
E.g., use the generic login `marie` and the corresponding project name `p_marie`.

```console
marie@login$ ls -l
drwxr-xr-x   3 marie p_marie      4096 Jan 24  2020 code
drwxr-xr-x   3 marie p_marie      4096 Feb 12  2020 data
-rw-rw----   1 marie p_marie      4096 Jan 24  2020 readme.md
```

## Mark Omissions

If showing only a snippet of a long output, omissions are marked with `[...]`.

## Unix Rules

Stick to the Unix rules on optional and required arguments, and selection of item sets:

* `<required argument or value>`
* `[optional argument or value]`
* `{choice1|choice2|choice3}`

## Random things

**Remark:** Avoid using tabs both in markdown files and in `mkdocs.yaml`. Type spaces instead.
