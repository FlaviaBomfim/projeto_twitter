from TwitterAPI import TwitterAPI
import boto3
import json

## twitter credentials

consumer_key = "xxxxxxxxxxxxxxxxxxxxxxx"
consumer_secret = "xxxxxxxxxxxxxxxxxxxxxxx"
access_token_key = "xxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxx"
access_token_secret = "xxxxxxxxxxxxxxxxxxxxxxx"


def lambda_handler(event, context):
        r = event.api.GetSearch('search/tweets', {'q':'DesafioDE'})
            for item in r:
                        return(item)
