#!/bin/python3
# @Author skiqqy
import requests
import os
import time
import sys, getopt

secret = ""
key = ""

try:
    opts, args = getopt.getopt(sys.argv[1:],"hk:s:",["key=","secret="])
except getopt.GetoptError:
    print('Usage: $ dns.py [-k <key> -s <secret>]')
    sys.exit(1)

for opt, arg in opts:
    if opt == "-h":
        print('Usage: $ dns.py [-k <key> -s <secret>]')
        sys.exit(0)
    elif opt in ("-k", "--key"):
        key=arg
    elif opt in ("-s", "--secret"):
        secret=arg

if secret == "" or key == "":
    f = open("secret/godaddy_key", "r")
    for line in f:
        line = line.replace("\n","")
        parse = line.split(":")
        if parse[0] == "secret":
            secret = parse[1]
        elif parse[0] == "key":
            key = parse[1]

if secret == "" or key == "":
    print("No key or secret set")
    exit(1)

url="https://api.godaddy.com/"

header={
        "content-type":"application/json",
        "Authorization":"sso-key " + key + ":" + secret
        }


# Domains and subdomains
domains = {
        "skiqqy.xyz":[
                {"name": "api", "type": "A"},
                {"name": "git", "type": "A"},
                {"name": "irc", "type": "A"},
                {"name": "proj", "type": "A"},
                {"name": "blog", "type": "A"},
                {"name": "pay", "type": "A"},
                {"name": "wiki", "type": "A"},
                {"name": "files", "type": "A"},
                {"name": "social", "type": "A"},
                {"name": "music", "type": "A"},
                {"name": "dev", "type": "A"},
                {"name": "games", "type": "A"},
            ]
        }

# Get current public ip
# Max 60s then give up (1s per try + 1s sleep = 2s per iter => 30*2 =60
for i in range(30):
    ip = os.popen('curl ifconfig.me --max-time 1').read()
    if ip == "":
        # We timed out
        time.sleep(1)
    else:
        break

if ip == "":
    exit(1) # We could not get our ip

# Construct the post data
for domain in domains:
    post = [{}]
    req_url = url + "v1/domains/" + domain + "/records/A/@"
    post[0]["type"] = "A"
    post[0]["name"] = "@"
    post[0]["data"] = ip
    post[0]["ttl"] = 600
    r = requests.put(req_url, headers=header, json=post)
    print("Refreshing <" + domain + "> ---> " + str(r))
    for sub in domains[domain]:
        post[0]["type"] = sub["type"]
        post[0]["name"] = sub["name"]
        post[0]["data"] = ip
        post[0]["ttl"] = 3600

        # Do the put
        req_url = url + "v1/domains/" + domain + "/records/" + sub["type"] + "/" + sub["name"]
        r = requests.put(req_url, headers=header, json=post)
        print("Refreshing <" + sub["name"] + "." + domain + "> ---> " + str(r))
