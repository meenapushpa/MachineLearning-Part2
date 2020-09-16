import sentencepiece as spm
import json
import sys
import os
cwd = os.getcwd()

with open('D:\\Priya\\Work6\\Workspace\\Testing\\discomt2019\\experiments\\ur-en\\global_config.json') as f:
  data = json.load(f)
  sp = spm.SentencePieceProcessor(model_file=data['spm']['model_file'])
  fname=sys.argv[1]
  f=open(fname,'r')
  for line in f:
      print(sp.decode(line))
  f.close()
