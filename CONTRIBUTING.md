# Contribution Guide

This project welcomes all contributors. This short guide (based loosely on [
Collective Code Construction Contract](http://zeromq-rfc.wikidot.com/spec:22))
details how to contribute in a standardized and efficient manner.

## Development Process

- Change on the project SHALL be governed by the pattern of accurately
  identifying problems and applying minimal, accurate solutions to these
  problems.
- To request changes, a user SHOULD log an issue on the project Platform issue
  tracker.
- The user or Contributor SHOULD write the issue by describing the problem they
  face or observe.
- The user or Contributor SHOULD seek consensus on the accuracy of their
  observation, and the value of solving the problem.
- Before submitting a patch, an Issue describing the problem SHOULD be
  submitted, and a generally consensus around the solution should be achieved.
  - Minor changes (e.g., grammatical fixes) do not require an Issue first.
- A contributor SHALL NOT commit changes directly to the project
- To submit a patch, a contributor SHALL create a pull request back to the
  project.

## Submitting a Pull Request (PR)

- To work on an issue, a Contributor SHALL fork the project repository and then
  work on their forked repository.
- 
- A patch commit message SHOULD consist of a single short (less than 50
  character) line summarizing the change, optionally followed by a blank line
  and then a more thorough description.
- A PR SHOULD be a minimal and accurate answer to exactly one identified and
  agreed problem. PRs that tackle multiple problems are harder to review and
  slower to merge when the uncontroversial changes are held up by the more
  discussed changes.
- Where applicable, a PR or commit message body SHOULD reference an Issue by
  number (e.g. Fixes #33”).
- Use the Draft PR feature on Github or title your PR with `WIP` if your PR is
  not ready for review immediately upon submission

## Pull Request (PR) Merging Process

- PR reviews should be timely. Both reviewer and PR issuer should make a good
  attempt at resolving the conversation as quickly as possible.
- PR reviews exist to check obvious things aren't missed, not to achieve
  perfection.
- A PR SHALL be eligible for merging if it has at least one approval from a
  project maintainer and no outstanding requested changes or discussions.
- Discussions created via an inline comment on GitHub SHOULD only be "resolved"
  by whomever opened the discussion.
- The person to mark the last open discussion "resolved" SHOULD also merge the
  PR ("close the door when you leave")
- Maintainers SHOULD NOT merge their own patches except in exceptional cases,
  such as non-responsiveness from other Maintainers for an extended period (more
  than 1-2 days).
