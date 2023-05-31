# How-To Contribute

!!! cite "Chinese proverb"

    Ink is better than the best memory.

In this section you will find information about the technical setup of this documentation, the
writing rules that apply, the Git workflow, and specific ways to contribute.

Your contributions are highly welcome. This can range from fixing typos, improving the phrasing and
wording to adopting examples, command lines and adding new content. Our goal is to provide a
general, consistent and up to date documentation. Thus, it is by no means a static documentation.
Moreover, is is constantly reviewed and updated.

## Technical Setup

This documentation is written in markdown and translated into static html pages using
[mkdocs](https://www.mkdocs.org/). The single configuration file `mkdocs.yml` contains the page
structure as well as the specification of the theme and extensions.

We manage all project files (markdown pages, graphics, configuration, theme, etc.) within a
[public Git repository](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium),
allowing for collaborative working and revision control. GitLab's features offer different
possibilities of contribution and ensure up-to-date and consistent content by including a review
process. There are three possible ways how you can contribute to this documentation.
These are mentioned below.

!!! tip "Before you start"

    Before you start your very first commit, please make sure that you are familiar with our
    [Git workflow](#git-workflow) and that you have at least skimmed through the
    [Writing Rules](content_rules.md).

## Git Workflow

We employ a so-called Git feature workflow with a development branch. In our case, the working branch
is called `preview` and is kept in parallel to the `main` branch.

All contributions, e.g., new content, improved wording, fixed typos, etc., are added to separate
feature branches which base on `preview`. If the contribution is ready, you will have to create a
merge request back to the `preview` branch. A member of the ZIH team will review the changes
(four-eyes principle) and finally merge your changes to `preview`. All contributions need to pass
through the CI pipeline consisting of several checks to ensure compliance with the content rules.
Please, don't worry too much about the checks. The ZIH staff will help you with that. You can find
some more information about the [CI/CD pipeline](cicd-pipeline) at the bottom of this page.

In order to publish the updates and make them visible in the compendium,
the changes on the `preview` branch are either automatically merged into the `main` branch on every
Monday via a pipeline schedule, or manually by admin staff. Moreover, the `main` branch is deployed
to [https://compendium.hpc.tu-dresden.de](https://compendium.hpc.tu-dresden.de) and always reflects
a production-ready state. Manual interventions are only necessary in case of merge conflicts.
This process is handled by the admins.

???+ note "Graphic on Git workflow"

    The applied Git workflow is depicted in the following graphic. Here, two feature branches `foo`
    and `bar` are created basing on `preview`. Three individual commits are added to branch `foo`
    before it is ready and merged back to `preview`. The contributions on `bar` consist of only one
    commit. In the end, all contributions are merged to the `main` branch.

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

## Writing Rules

To ensure a high-quality and consistent documentation, and to make it easier for readers to
understand all content, we have established [writing rules](content_rules.md). Please follow
these rules and conventions regarding markdown syntax, styling and wording when writing
contributons! As a benefit, reviewing
your changes takes less time and your improvements appear faster on the official documentation.

!!! note "Legal Notice"

    If you contribute, you are fully and solely responsible for the content you create and have to
    ensure that you have the right to create it under applicable laws.

## Contribute via Issue

You can contribute to the documentation using
[GitLab's issue tracking system](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium/-/issues).
For that, open an issue to report typos and missing documentation or request for more precise
wording etc. ZIH staff will get in touch with you to resolve the issue and improve the
documentation. You can use both, German or English for the issue description.

??? tip "Create an issue in GitLab"

    ![GIF showing how to create an issue in GitLab](misc/create_gitlab_issue.gif)
    {: align=center}

!!! warning "HPC support"

    Non-documentation issues and requests need to be send as a ticket to
    [hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de).

## Contribute via Web IDE

For minor changes like fixing typos and improve wording you can use GitLab's web interface on the
fly in your browser without the need to install external components. Changes, however, may only be
made visible as a markdown preview which differs from the compendium's final appearance.
Find more information on the page [Contributing via web browser](contribute_browser.md).

## Contribute via Local Clone

For experienced Git users, we provide a Docker container that includes all the checks of the CI
engine used in the backend. Using them should ensure that merge requests are not blocked due to
automatic checks. All changes are made visible throught the `mkdocs` building process as they would
look in the final appearance.
The page [Contributing via local clone](contribute_container.md) provides you
with the details about how to set up and use your local clone of the repository.

## CI/CD Pipeline

All contributions need to pass through the CI pipeline which consists of various checks to ensure
that the [writing rules](content_rules.md) have been followed.

The stages of the CI/CD pipeline are defined in a `.gitlab.yaml` file. For security reasons, this
file is maintained in a second, private repository.
