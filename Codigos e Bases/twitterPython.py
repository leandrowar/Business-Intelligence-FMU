# -*- coding: utf-8 -*-
#
#  twitterPython.py
#  
#  Copyright 2015 Leandro <Leandro@leandrowar>

import sys 
import unicodedata
from TwitterSearch import *
import csv
import datetime
import time
reload(sys) 
sys.setdefaultencoding("ascii")

#
def coleta_tweets(query, max = 3000):
    #recebe o termo de consulta e a quantidade máxima de tweets por busca
    #escreve os resultados em um arquivo csv, sem sobreposição de dados 
    
    #contador
    i = 0
    #recebe o termo de busca
    search = query
	
	#abre um aquivo csv com o nome do termo de busca
    with open(search+'.csv', 'a') as outf: # o parametro "a" indica que não averá sobreposição
		#cada novo registro será adicionado ao final do arquivo
        writer = csv.writer(outf,delimiter='|') #utiliza o | como delimitador de campo
        writer.writerow(['user','time','tweet','latitude','longitude'])
        try:
            tso = TwitterSearchOrder()
            tso.set_keywords([search])
            tso.set_language('pt') # Apenas Tweets em portugues
 
            ts = TwitterSearch(
				access_token  = '38855125-pNaSiE7TKu4VMl8S41fXKKVYV7qSgYlEtIXswRY8p',
				access_token_secret  = 'vrYHEa3oeqdOifeYUzaACThvR5B1IMIL5DWATRCc',
				consumer_key  = 'LyL3DPwb7UXJSpghHQclQ',
				consumer_secret  = 'jO8NXrad1F8iP6TfCbM8AIseBMuQP03kMO0ZC7wxus'
				)
 
            for tweet in ts.search_tweets_iterable(tso):
                lat = None
                long = None
                time = tweet['created_at'] # base UTC
                user = tweet['user']['screen_name']
                tweet_text =  unicodedata.normalize('NFKD',tweet['text'].strip()).encode('ascii', 'ignore')
                #tweet_text =  tweet['text'].strip().encode('ascii', 'ignore')
                tweet_text = ''.join(tweet_text.splitlines())
                print i,time,
                if tweet['geo'] != None and tweet['geo']['coordinates'][0] != 0.0: #tratamos para evitar sujeira
                    lat = tweet['geo']['coordinates'][0]
                    long = tweet['geo']['coordinates'][1]
                    print('@%s: %s' % (user, tweet_text)), lat, long
                else:
                    print('@%s: %s' % (user, tweet_text))
 
                writer.writerow([user, time, tweet_text, lat, long])
                i += 1
                if i > max:
                    return()
 
        except TwitterSearchException as e: #apenas para mostrar o tipo de erro, caso exista
            print(e)
 
query = raw_input ("Sua busca: ")
max_tweets = 2000
tempo_espera = 300 # Tempo de espera entre uma busca e outra (em segundos)
quantidade_buscas = 10000

#Loop para busca
for l in range(1,quantidade_buscas+1):
	coleta_tweets(query, max_tweets)
	time.sleep(tempo_espera)
	l += 1

