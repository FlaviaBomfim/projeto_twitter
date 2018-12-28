from twitter import *

consumer_key = "XXXXXXXXXXX"
consumer_secret = "XXXXXXXXXXXXXXXX"
access_key = "XXXXXXXXXX-XXXXXXXXX"
access_secret = "XXXXXXXXXXXXXXXXX"


import config

conta_twitter = Twitter(auth = OAuth(config.access_key,
                      config.access_secret,
                                        config.consumer_key,
                                                          config.consumer_secret))

#-----------------------------------------------------------------------
test = conta_twitter.search.tweets( q = "#DesafioDE")


for result in test["statuses"]:
        print("  @%s %s " % ( result["user"]["screen_name"], result["text"])).encode('utf8')
