# How-To Contribute

!!! cite "Chinese proverb"

    Ink is better than the best memory.

In this section you will find information on the technical setup of this documentation, the applied
content rules, Git workflow and certain ways for contribution.

Your contributions are highly welcome. This can range from adding new content, fixing typos,
improving the phrasing and wording, adopting examples and command lines, etc. Our goal is to
provide a consistent and up to date documentation. Thus, it is by no means a static documentation.
Moreover, is is constantly reviewed and updated.

## Technical Setup

This documentation is written in markdown and translated into static html pages using
[mkdocs](https://www.mkdocs.org/). The single configuration file `mkdocs.yml` holds the pages
structure as well as specification of the theme and extensions.

We manage all essential files (markdown pages, graphics, configuration, theme, etc.) within a
[public Git repository](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium), which
makes it quite easy to contribute to this documentation. In principle, there are three possible ways
how to contribute to this documentation. These ways are outlined below.

!!! tip "Before you start"

    Before you start your very first commit, please make sure, that you are familiar with our
    [Git workflow](#git-workflow) and that you have at least skimmed the
    [Content Rules](content_rules.md).

## Git Workflow

We employ a so-called Git feature workflow with development branch. In our case, the working branch
is called `preview` and is kept in parallel to the `main` branch.

All contributions, e.g., new content, improved wording, fixed typos, etc, are added to separate
feature branches which base on `preview`. If the contribution is ready, you will have to create a
merge request back to the `preview` branch. A member of ZIH team will review the changes (four-eyes
principle) and finally merge your changes to `preview`. All contributions need to pass the CI
pipeline consisting of several checks to ensure compliance with the content rules. Please, don't
worry to much about the checks. ZIH staff will help you with that. You will find more information
on the [CI/CD pipeline](cicd-pipeline) in the eponymous subsection.

The changes on `preview` branch are either automatically merged into the `main` branch on every
Monday via a pipeline schedule, or manually by admin staff. Moreover, the `main` branch is deployed
to [https://compendium.hpc.tu-dresden.de](https://compendium.hpc.tu-dresden.de) and always reflects
a production-ready state. Manual interventions are only necessary in case of merge conflicts. The
admin staff will take care on this process.

???+ note "Graphic on Git workflow"

    The applied Git workflow is depicted in the following graphic. Here, two feature branches `foo`
    and `bar` are created basing on `preview`. Three individual commits are added to branch `foo`
    before it is ready and merged back to `preview`. The contributions on `bar` consist only one
    commit. In the end, all contribution are merged to the `main` branch.

    ```mermaid
    %% Issues:
    %% - showCommitLabel: false does not work; workaround is to use `commit id: " "`%%
    %% - Changing the theme does not effect the rendered output. %%
    %%{init: { 'logLevel': 'debug', 'theme': 'base', 'gitGraph': {'showCommitLabel': false} }%%
    gitGraph
        commit
        branch preview
        checkout preview
        commit
        branch foo
        checkout foo
        commit
        commit
        checkout preview
        branch bar
        checkout bar
        commit
        checkout preview
        merge bar
        checkout foo
        commit
        checkout preview
        merge foo
        checkout main
        merge preview
    ```

## Content Rules

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
with repositories. To start fixing typos and edit source files, please find more information on the
page [Contributing via web browser](contribute_browser.md).

## Contribute via Local Clone

For experienced Git users, we provide a Docker container that includes all checks of the CI engine
used in the back-end. Using them should ensure that merge requests will not be blocked
due to automatic checking.
The page on [Contributing via local clone](contribute_container.md) provides you with the details
about how to setup and use your local clone of the repository.

## CI/CD Pipeline

All contributions need to pass the CI pipeline which consists of various checks to ensure, that the
[content rules](content_rules.md) are met.

The stages of the CI/CD pipeline are defined in a `.gitlab.yaml` file. For security reasons, this
file is managed in a second, private repository.
