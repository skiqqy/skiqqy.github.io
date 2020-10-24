#!/bin/python3
# @Author skiqqy
import requests
import os
import time

f = open("secret/godaddy_key", "r")

secret = ""
key = ""
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
                {"name": "git", "type": "A"},
                {"name": "irc", "type": "A"},
                {"name": "proj", "type": "A"},
                {"name": "blog", "type": "A"},
                {"name": "pay", "type": "A"},
                {"name": "wiki", "type": "A"},
                {"name": "files", "type": "A"},
                {"name": "social", "type": "A"},
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
    for sub in domains[domain]:
        post[0]["type"] = sub["type"]
        post[0]["name"] = sub["name"]
        if sub["type"] != "MX":
            post[0]["data"] = ip
        else:
            post[0]["data"] = domain
            post[0]["priority"] = 0
        post[0]["ttl"] = 3600

        # Do the put
        req_url = url + "v1/domains/" + domain + "/records/" + sub["type"] + "/" + sub["name"]
        r = requests.put(req_url, headers=header, json=post)
        print(r)
