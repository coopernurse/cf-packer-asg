# Proof of Concept - CF / Packer / ASG

## Troubleshooting

### Error creating stack

    Could not find access token for server type github
    
Cause: AWS needs an OAuth token for your repo at GitHub

Fix:

* Login to AWS Console web ui
* Go to CodeBuild
* Create a new project and select GitHub
* Click authorize to trigger OAuth flow
* Authorize AWS access to your GitHub account

Currently there's no way to do this programmatically. This is a one time manual step that has to be done before you can setup CodeBuild to use GitHub.    