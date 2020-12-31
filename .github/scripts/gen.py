#!/usr/bin/env python
import glob
import json
from distutils.version import StrictVersion
from argparse import ArgumentParser
from pprint import pprint

parser = ArgumentParser()
parser.add_argument("--set-output", default=False, dest='set_output', action='store_true', help="Set Github actions output")
opts = parser.parse_args()

dockerfiles = glob.glob("*/*/Dockerfile")
l = []
for df in dockerfiles:
  variant,version,_ = df.split('/')
  l.append({
    'version': version,
    'variant': variant,
    'file': df,
    })

l.sort(key=lambda f: StrictVersion(f['version']))
latest = l[-1]['version']
#print("latest is %s" % (latest,))
if opts.set_output:
  strategy = {
    "max-parallel": 1,
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
  print("::set-output name=strategy::%s" % (json.dumps(strategy),))
else:
  print(json.dumps(strategy))
