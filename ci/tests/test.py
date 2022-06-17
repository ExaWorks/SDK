import argparse
import requests
from datetime import datetime
import random
import pprint
import subprocess
import sys
import os
from pprint import pprint as pp

test = os.getenv("test")
run_id = os.getenv("run_id")
branch = os.getenv("branch")
url = os.getenv("url")
location = os.getenv("location")
maintainer_email = os.getenv("contact")
imnumber = os.getenv("imnumber")

config = { "maintainer_email" : maintainer_email}

extras = { "config" : config,
           "Test": test,
           "git_branch" : branch,
           "start_time" : str(datetime.now())
         }

if imnumber:
    config["IM Number"] = imnumber

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


def get_result(command, name, stdout):
    if not name:
        name = command.split()[0]
    start = str(datetime.now())

    try:
        out = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, timeout=1200).decode("utf-8")
        results = {name: {"passed": True,
                          "status": "passed",
                          "exception": None,
                          "report": ""}}
        extras['returncode'] = 0
    except subprocess.CalledProcessError as exc:
        out = exc.output.decode("utf-8")
        results = {name: {"passed": False,
                          "status": "failed",
                          "exception": exc,
                          "report": ""}}
        extras['returncode'] = exc.returncode
        print(f"Test: {name} failed.\n{out}")
    except subprocess.TimeoutExpired as exc:
        out = exc.output.decode("utf-8")
        results = {name: {"passed": False,
                          "status": "timeout",
                          "exception": exc,
                          "report": ""}}
        extras['returncode'] = 1
        print(f"Test: {name} failed due to time out.\n{out}")

    end = str(datetime.now())
    data.update({ "test_name" : name,
                  "results" : results,
                  "test_start_time": start,
                  "test_end_time" : end,
                  "extras": extras,
                  "function" : name,
                  "module" : "Sanity Checks",
            })
    if stdout:
        data["stdout"] = out
    else:
        print(out)

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
    test_group = parser.add_mutually_exclusive_group(required=True)
    test_group.add_argument('-c', '--command', action='store', type=str, default=None,
                        help='The command in which you want to test.')
    parser.add_argument('-n', '--name', action='store', type=str, default=None,
                        help='The name of the test.')
    test_group.add_argument('-s', '--start', action="store_true",  default=False,
                        help='Start a series of test runs with the same id')
    test_group.add_argument('-e', '--end', action="store_true",  default=False,
                        help='End a series of test runs with the same id')
    parser.add_argument('--stdout', action="store_true",  default=False,
                        help='Add std out of test to result')
    args = parser.parse_args()
    return args

def main():
    args = get_args()

    if args.start:
        data = get_conf()
    elif args.end:
        data = get_end()
    elif args.command:
        data = get_result(args.command, args.name, args.stdout)
    else:
        print("No viable option called, Exiting")
        exit(1)

    msg = {"id": location, "key": "42", "data": data}
    import pprint
    pprint.pprint([url, msg])
    requests.post(url, json=msg, verify=False)

if __name__ == '__main__':
    main()
