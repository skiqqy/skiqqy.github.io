# Needed libs
from flask import Flask, render_template, request, jsonify
from hashlib import sha256
from datetime import datetime
import os
# My libs

main_domain = 'skiqqy.xyz'
domains = ['git', 'irc', 'proj', 'blog', 'pay', 'wiki', 'files', 'social', 'music', 'dev'] # TODO: Save this in file to reduce coupling with dns.py

app = Flask(__name__)

@app.route('/')
def main():
    return render_template('index.html')

@app.route('/domain/status/<dom>', methods = ["GET"])
def domstatus(dom):
    if dom == 'all':
        dom = ''
        for sub in domains:
            ip = os.popen('ping -c 1  -w 5 %s.%s | head -1 | cut -d \" \" -f 3' % (sub, main_domain)).read()
            dom += sub + ':' + ip + '\n'
    elif dom not in domains:
        dom = "unknown domain"
    else:
        dom += ':' + str(os.popen('ping -c 1  -w 5 %s.%s | head -1 | cut -d \" \" -f 3' % (dom, main_domain)).read())
    return dom

def setup():
    app.template_folder = "../assets/api_templates/"

setup()
