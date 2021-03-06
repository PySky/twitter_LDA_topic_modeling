#!/bin/bash
# setting up the entire environment from 
# fresh Ubuntu 16.04 LTS 64-bit install
sudo apt-get -y update
sudo apt-get -y upgrade

# install accelerated BLAS environment 
# openBLAS should be there by default...just in case
sudo apt-get -y install vim git build-essential libblas-dev liblapack-dev libatlas-base-dev gfortran python-dev libfreetype6-dev libxft-dev awscli
export LAPACK=/usr/lib/liblapack.so
export ATLAS=/usr/lib/libatlas.so

# download the repository
git clone https://www.github.com/kenneth-orton/twitter_LDA_topic_modeling

# create virtual_env and install requirements
cd twitter_LDA_topic_modeling/
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
rm get-pip.py
sudo pip install virtualenv

virtualenv -p /usr/bin/python2.7 venv
source venv/bin/activate
pip install -r requirements.txt
sudo activate-global-python-argcomplete

# check for BLAS installation
python -c 'import numpy; numpy.show_config()'

# patch Gensim modules and download stopword lists
printf 'd\nstopwords\nq' | python -c 'import nltk; nltk.download()'
mv patches/english ~/nltk_data/corpora/stopwords

# wikicorpus patch 
# 1. increases the min size of acceptable articles to 200 words
# 2. uses a stopword list to filter words during lemmatization 
# 3. selects only noun POS tags during lemmatization

cp patches/wikicorpus.py venv/lib/python2.7/site-packages/gensim/corpora/
cp patches/prog_class.py venv/lib/python2.7/site-packages/pyprind/prog_class.py
cp patches/english ~/nltk_data/corpora/stopwords/
