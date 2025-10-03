## Pushing a release to production.

The process for pushing a new release to production are as follows:

- Create a release that starts with "v" and has dotted version numbering (i.e. `v0.0.4` oe `v1.0`). *Make sure to select main as the target branch*. Be sure to include a description of changes included in the release;  
- Monitor that Gitlab picks up the release and deploys it to Rancher.
- Ensure that the deployment pods update successfully.
- Move JIRA tasks in "Ready for Prod Deploy" to "Done". Update non-LT stakeholders as necessary.
