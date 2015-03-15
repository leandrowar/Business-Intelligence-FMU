# -*- coding: utf-8 -*-


import sys 
import unicodedata
from TwitterSearch import *
import csv
import datetime
import time
reload(sys) 
sys.setdefaultencoding("ascii")

 
def get_tweets(query, max = 3000):
    # takes a search term (query) and a max number of tweets to find
    # gets content from twitter and writes it to a csv bearing the name of your query
    
    i = 0
    search = query
 
    with open(search+'.csv', 'a') as outf:
        writer = csv.writer(outf,delimiter='|')
        writer.writerow(['user','time','tweet','latitude','longitude'])
        try:
            tso = TwitterSearchOrder()
            tso.set_keywords([search])
            tso.set_language('pt') # Portuguese tweets only
 
            ts = TwitterSearch(
				access_token  = '38855125-pNaSiE7TKu4VMl8S41fXKKVYV7qSgYlEtIXswRY8p',
				access_token_secret  = 'vrYHEa3oeqdOifeYUzaACThvR5B1IMIL5DWATRCc',
				consumer_key  = 'LyL3DPwb7UXJSpghHQclQ',
				consumer_secret  = 'jO8NXrad1F8iP6TfCbM8AIseBMuQP03kMO0ZC7wxus'
				)
 
            for tweet in ts.search_tweets_iterable(tso):
                lat = None
                long = None
                time = tweet['created_at'] # UTC time when Tweet was created.
                user = tweet['user']['screen_name']
                tweet_text =  unicodedata.normalize('NFKD',tweet['text'].strip()).encode('ascii', 'ignore')
                #tweet_text =  tweet['text'].strip().encode('ascii', 'ignore')
                tweet_text = ''.join(tweet_text.splitlines())
                print i,time,
                if tweet['geo'] != None and tweet['geo']['coordinates'][0] != 0.0: # avoiding bad values
                    lat = tweet['geo']['coordinates'][0]
                    long = tweet['geo']['coordinates'][1]
                    print('@%s: %s' % (user, tweet_text)), lat, long
                else:
                    print('@%s: %s' % (user, tweet_text))
 
                writer.writerow([user, time, tweet_text, lat, long])
                i += 1
                if i > max:
                    return()
 
        except TwitterSearchException as e: # take care of all those ugly errors if there are some
            print(e)
 
query = raw_input ("Search for: ")
max_tweets = 3000
tempo_espera = 60 # Tempo de espera entre uma busca e outra (em segundos)
quantidade_buscas = 10000
for l in range(1,quantidade_buscas+1):
	get_tweets(query, max_tweets)
	time.sleep(tempo_espera)
	l += 1

