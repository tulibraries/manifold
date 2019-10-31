## Pushing a release to production.

The process for pushing a new release to production are as follows:

- Ensure that the manifold playbook master branch is up to date with the qa branch.
- When all commits on manifold merged to `qa` branch have been tested and approved( moved into the Ready for Prod Deploy column in JIRA), create a pull request merging changes from `qa` into `master`.
- Merge the `qa`->`master` pr to trigger a CircleCI deploy to stage.
- Monitor the CircleCI deployment triggered by that merge; if successful those changes will be live on stage.
- Run a smoke test on stage (no need for a full re-qa process) to ensure the site is running as expected.
- Create a release that starts with "v" and has dotted version numbering (i.e. `v0.0.4` oe `v1.0`). *Make sure to select master as the target branch* (BE CAREFUL, IT DEFAULTS TO QA!!). Be sure to include a description of changes included in the release;  
- Monitor the CircleCI job  trigged by the release deploying it to production.
- Move JIRA tasks in "Ready for Prod Deploy" to "Done". Update non-LT stakeholders as necessary.
