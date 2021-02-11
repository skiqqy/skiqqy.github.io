# Needed libs
from flask import Flask, render_template, request, jsonify
from hashlib import sha256
from datetime import datetime
import os
# My libs

domain = 'skiqqy.xyz'
domains = ['git', 'irc', 'proj', 'blog', 'wiki', 'music', 'files', 'social', 'dev'] # TODO: Save this in file to reduce coupling with dns.py
app = Flask(__name__)

### Helper Functions ###
def setup():
    app.template_folder = "../assets/api_templates/"

def getip(dom):
    return os.popen('ping -c 1 -w 5 %s | head -1 | cut -d \" \" -f 3' % dom).read()

# Checks to see that we are not being redirected to an nginx page.
def not_nginx(dom):
    # Yes i know i can use requests, and I know its not efficeint to pass
    # calls to the shell, but this is just temporary.
    nginx = os.popen('curl -s %s | head -5 | grep nginx' % dom).read()
    if nginx == '':
        return True
    return False

def is_service_up(dom):
    if sip == getip(dom) and not_nginx('https://' + dom):
        return True
    return False

### End Helper Functions ###

sip = getip(domain)

@app.route('/')
def main():
    return render_template('index.html')

# Check domain status -> Mainly used to check that ip's have updated after loadshedding.
@app.route('/domain/status/<dom>', methods = ["GET"])
def domstatus(dom):
    info = "<div class=succ>Green: Service is up </div><div class=fail>Red: Service is down</div>"
    up = []
    down = []
    if dom == 'all':
        for sub in domains:
            res = "%s.%s" % (sub, domain)
            if is_service_up(sub + '.' + domain):
                up.append(res)
            else:
                down.append(res)
    elif dom not in domains:
        return render_template('domain_status.html', ERROR="Unknown Domain", TITLE="ERROR")
    else:
        res = "%s.%s" % (dom, domain)
        if is_service_up(dom + '.' + domain):
            up.append(res)
        else:
            down.append(res)
    return render_template('domain_status.html', up=up, down=down, TITLE=str("Results for " + dom), INFO=info)

@app.errorhandler(404)
def err(error):
    return render_template('404.html'), 404

setup()
