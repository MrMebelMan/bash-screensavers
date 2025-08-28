# GitHub Workflows

This directory contains the GitHub Actions workflows for this project.

## Workflows

- **`create.release.for.tag.yml`**: This workflow automates the process of creating a new GitHub release whenever a new tag is pushed to the repository. It generates release notes based on the commit history since the last tag.

- **`run-tests.yml`**: This workflow runs the project's test suite on every pull request to the `main` branch. This ensures that all changes are verified before being merged.
