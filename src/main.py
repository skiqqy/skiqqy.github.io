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
    results = []
    if dom == 'all':
        for sub in domains:
            ip = os.popen('ping -c 1  -w 5 %s.%s | head -1 | cut -d \" \" -f 3' % (sub, main_domain)).read()
            results.append("%s.%s:%s" % (sub, main_domain, ip))
    elif dom not in domains:
        results = ["unknown domain"]
    else:
        ip = os.popen('ping -c 1  -w 5 %s.%s | head -1 | cut -d \" \" -f 3' % (dom, main_domain)).read()
        results.append("%s.%s:%s" % (dom, main_domain, ip))
    return render_template('domain_status.html', results=results, TITLE=str("Results for " + dom))

def setup():
    app.template_folder = "../assets/api_templates/"

setup()
