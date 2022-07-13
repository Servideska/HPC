# How-To Contribute

!!! cite "Chinese proverb"

    Ink is better than the best memory.

This documentation is written in markdown and translated into static html pages using
[mkdocs](https://www.mkdocs.org/). A single configuration file holds the pages structure
as well as specification of the theme and extensions. This file is `mkdocs.yaml`.

We manage all essential files (markdown pages, graphics, configuration, theme, etc.) within a Git
repository, which makes it quite easy to contribute to this documentation. In principle, there are
three possible ways how to contribute to this documentation. These ways are outlined below.

## Content Guide Lines

To ensure a high-quality and consistent documentation and to make it easier for readers to
understand all content, we set some [Content rules](content_rules.md). Please follow
these rules regarding markdown syntax and writing style when contributing! Furthermore, reviewing
your changes takes less time and your improvements appear faster on the official documentation.

!!! note

    If you contribute, you are fully and solely responsible for the content you create and have to
    ensure that you have the right to create it under the laws which apply.

## Contribute via Issue

You can contribute to the documentation via the
[GitLab issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/issues).
For that, open an issue to report typos and missing documentation or request for more precise
wording etc. ZIH staff will get in touch with you to resolve the issue and improve the
documentation.

??? tip "Create an issue in GitLab"

    ![GIF showing how to create an issue in GitLab](misc/create_gitlab_issue.gif)
    {: align=center}

!!! warning "HPC support"

    Non-documentation issues and requests need to be send as ticket to
    [hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de).

## Contribute via Web IDE

If you have a web browser (most probably you are using it to read this page) and want to contribute
to the documentation, you are good to go. GitLab offers a rich and versatile web interface to work
with repositories. To start fixing typos and edit source files, please find more information on
[Contributing via web browser](contribute_browser.md).

## Contribute via Local Clone

For experienced Git users, we provide a Docker container that includes all checks of the CI engine
used in the back-end. Using them should ensure that merge requests will not be blocked
due to automatic checking.
The page on [Contributing via local clone](contribute_container.md) provides you with the details
about how to setup and use your local clone of the repository.
