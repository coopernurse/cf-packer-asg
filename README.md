# Proof of Concept - CF / Packer / ASG

## Usage

    $ cp env-sample .env
    
    # edit .env as desired
    
    $ source .env
    $ ./ops/create-update-stack.sh
    
The stack will output an ELB DNSName, which you can then use with `rolling-update-test.py`

For example:

    # edit .env and bump AppVersion
    $ source .env
    $ ./ops/create-update-stack.sh
    $ ./test/rolling-update-test.py http://poc-cf-packer-webapp-elb-1409725999.us-west-2.elb.amazonaws.com/

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