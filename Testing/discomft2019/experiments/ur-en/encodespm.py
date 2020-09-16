import sentencepiece as spm
import json
import sys
import os
import codecs
cwd = os.getcwd()
#inputfile=sys.argv[1]
with open('D:\\Priya\\Work6\\Workspace\\Testing\\discomt2019\\experiments\\en-fr\\global_config.json') as f:
  data = json.load(f)
  sp = spm.SentencePieceProcessor(model_file=data['spm']['model_file'])
  with open('output1.txt','r',encoding='ISO-8859-1')as f1:
      for line in f1:
          print(sp.encode(line))
