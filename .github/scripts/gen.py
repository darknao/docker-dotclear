#!/usr/bin/env python
import glob
import json
import os
from packaging.version import Version
from argparse import ArgumentParser
from pprint import pprint

parser = ArgumentParser()
parser.add_argument("--set-output", default=False, dest='set_output', action='store_true', help="Set Github actions output")
parser.add_argument("--prime", default=False, dest='prime', action='store_true', help="use only base image, for caching")
parser.add_argument("--no-prime", default=False, dest='noprime', action='store_true', help="ignore base image")
opts = parser.parse_args()

dockerfiles = glob.glob("*/*/Dockerfile")
l = []
known_variant = []
for df in dockerfiles:
  variant,version,_ = df.split('/')
  l.append({
    'version': version,
    'variant': variant,
    'file': df,
    })

l.sort(key=lambda f: Version(f['version']))
latest = l[-1]['version']
#print("latest is %s" % (latest,))
if opts.set_output:
  strategy = {
    "fail-fast": False,
    "matrix": {
      "include": [],
      }}
else:
  strategy = []
for im in l:
  tags = []
  if im['variant'] == "apache":
    tags.append(im['version'])
    if im['version'] == latest:
      tags.append("latest")
      tags.append("apache")
  else:
    tags.append("%s-%s" % (im['version'], im['variant']))
    if im['version'] == latest:
      tags.append(im['variant'])

  if opts.set_output:
    if im['variant'] not in known_variant:
      known_variant.append(im['variant'])
      if opts.noprime:
        continue
    elif opts.prime:
      continue
    strategy['matrix']['include'].append(
      {
        "name": "%s-%s" % (im['version'], im['variant']),
        "os": "ubuntu-latest",
        "cache": "%s-cache" % (im['variant'],),
        "tags": ",".join(map(lambda x: "darknao/dotclear:%s" % (x,), tags)),
        "context": "%s/%s" % (im['variant'], im['version']),
        "dockerfile": im['file'],
        })
  else:
    strategy.append(
      {
        "name": "%s-%s" % (im['version'], im['variant']),
        "tags": tags,
        "dockerfile": im['file'],
        })

#pprint(strategy)
if opts.set_output:
  with open(os.getenv("GITHUB_OUTPUT"), 'a') as f:
    f.write("strategy=%s" % (json.dumps(strategy),))
else:
  print(json.dumps(strategy))
