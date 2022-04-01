import argparse
import requests
from datetime import datetime
import random
import pprint
import subprocess
import sys
import os

tag = os.getenv("tag").split("_")
run_id = os.getenv("run_id")
branch = os.getenv("branch")
url = 'https://sdk.testing.exaworks.org/result'

config = { "maintainer_email" : "morton30@llnl.gov", "repo":"sdk"}

extras = { "config" : config,
           "Base Image": tag[0],
           "Package Manager": tag[1],
           "MPI Flavor": tag[2],
           "Python Version": tag[3],
           "git_branch" : branch,
           "start_time" : str(datetime.now())
         }


data = { "run_id" : run_id,
         "branch": branch,
        }

def get_conf():
    results = {}
    data.update( {"test_name" : "Set Environment",
                  "results" : results,
                  "extras": extras,
                  "test_start_time": str(datetime.now()),
                  "test_end_time" : str(datetime.now()),
                  'function' : '_discover_environment',
                  "module" : '_conftest' })
    return data


def get_result(command, name):
    if not name:
        name = command.split()[0]
    start = str(datetime.now())

    try:
        out = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT).decode("utf-8")
        ret = True
    except subprocess.CalledProcessError as exc:
        out = exc.output.decode("utf-8")
        ret = False

    end = str(datetime.now())
    results = { name:
                       {"passed" : ret},
              }
    data.update({ "test_name" : name,
                  "results" : results,
                  "test_start_time": start,
                  "test_end_time" : end,
                  "extras": {},
                  "function" : name,
                  "module" : "Sanity Checks",
                  "stdout" : out
            })
    return data

def get_end():
    results = {}
    data.update( {"test_name" : "Set Environment",
                  "results" : results,
                  "extras": extras,
                  "test_start_time": str(datetime.now()),
                  "test_end_time" : str(datetime.now()),
                  'function' : '_discover_environment',
                  "module" : '_end' })

    return data

def get_args():
    parser = argparse.ArgumentParser(description='Runs SDK Tests by passing in shell commands')
    parser.add_argument('-c', '--command', action='store', type=str, default=None,
                        help='The command in which you want to test.')
    parser.add_argument('-n', '--name', action='store', type=str, default=None,
                        help='The name of the test.')
    parser.add_argument('-s', '--start', action="store_true",  default=False,
                        help='Start a series of test runs with the same id')
    parser.add_argument('-e', '--end', action="store_true",  default=False,
                        help='End a series of test runs with the same id')
    args = parser.parse_args(sys.argv[1:])
    return args

def main():
    args = get_args()

    ret = True
    if args.start:
        data = get_conf()
    elif args.end:
        data = get_end()
    elif args.command:
        data = get_result(args.command, args.name)
    else:
        print("No viable option called, Exiting")
        exit(1)

    msg = {"id" : "Github Actions", "key" : "42", "data" : data}
    requests.post(url, json=msg)

if __name__ == '__main__':
    main()
