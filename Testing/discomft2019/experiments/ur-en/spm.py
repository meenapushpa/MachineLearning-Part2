import sentencepiece as spm
import json
import sys
import os
cwd = os.getcwd()
fname=sys.argv[1]
path=(cwd)
print(''+ fname +'\\__src', ''+ fname +'\\__trg')
with open('D:\\Priya\\Work6\\Workspace\\Testing\\discomt2019\\experiments\\en-fr\\global_config.json') as f:
  data = json.load(f)
  spm.SentencePieceTrainer.train(input=[''+ fname +'\\__src', ''+ fname +'\\__trg'],
                                 model_prefix=data['spm']['model_prefix'],
                                 vocab_size=data['spm']['vocab_size'],
                                 character_coverage=0.9995,
                                 pad_id=data['spm']['PAD_ID'],
                                 bos_id=data['spm']['SOS_ID'],
                                 eos_id=data['spm']['EOS_ID'],
                                 unk_id=data['spm']['UNK_ID'],
                                 user_defined_symbols=data['spm']['CONC'])
  #sp = spm.SentencePieceProcessor(model_file=data['spm']['model_prefix'])
  #sp.load('.model')
  # encode: text => id
  #input_sentence_size=1000000,
  #shuffle_input_sentence=True,
  #spmmodel = sys.argv[2]
  #sp.encode(spmmodel)
  #print(sp.encode_as_ids('This is a test'))
  # input_sentence_size=10000,
  #shuffle_input_sentence=True,
