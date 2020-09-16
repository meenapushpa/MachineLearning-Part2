import nltk
from nltk.tokenize import word_tokenize
import codecs
import sys

newfile=sys.argv[2]
#infile=sys.stdin
with open(newfile, 'w', encoding='utf-8') as outfile:
    with open(sys.stdin.fileno(), 'r', encoding='ISO-8859-1') as inputfile:
        for data in inputfile:
            tokens = nltk.word_tokenize(data)
            for i in tokens:
                outfile.write(i)
