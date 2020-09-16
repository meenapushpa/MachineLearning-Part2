#  -*- coding: utf-8 -*-

import spacy
import sys
import os
import re
import codecs
import re
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords

nlp = spacy.blank('ur')
nlp.max_length = 29100000
newfile = sys.argv[2]
with open(newfile, 'w', encoding='utf-8') as outfile:
    file = codecs.open(sys.stdin.fileno(), encoding='utf-8', mode='r')
    for data in file:
        doc=nlp(data)
        for word in doc:
            outfile.write(str(word))

#doc.vocab.strings[

'''
f1=codecs.open("eout.txt",'r',encoding='utf-8')
for i in f1:
    textout=i
    print(textout.decode('utf-8'))
f1.close()

#with open("output.txt",'w',encoding="utf-8") as f:
for data in sys.stdin:
    #line=data.encode('unicode-escape').decode('utf-8')
    tokens = nltk.word_tokenize(data)
    for i in tokens:
        print(i)
'''

#for line in sys.stdin:
#    doc=line.encode('utf-8','surrogateescape')
#    doc=nlp(str(doc))
    #result=re.findall(r'[\u0600-\u06ff]+',str(doc))
    #print(result)

#    lines=line.encode('utf-8','surrogateescape').strip()
    #print(lines)
    #data=UTF8Reader(lines)
#lines=data.read()
#line=string.strip(lines)
#doc=nlp(str(data))
#result=re.findall(r'[\u0600-\u06ff]+',str(line))
