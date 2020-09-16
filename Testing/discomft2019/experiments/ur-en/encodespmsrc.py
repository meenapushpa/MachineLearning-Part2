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
  f=codecs.open('output.txt','r',encoding='utf-8')
  for line in f:
      print(sp.encode(line))
  f.close()
