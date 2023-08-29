
import argparse
import os
import requests.adapters
import ssl
import subprocess
import urllib3

from datetime import datetime


class CITestsHandler:

    dashboard_url = os.getenv('SDK_DASHBOARD_URL') or os.getenv('TESTING_HOST')
    record = {
        'id': os.getenv('SITE_ID'),
        'key': os.getenv('SDK_DASHBOARD_TOKEN'),  # site_token
        'data': {
            'run_id': os.getenv('CI_PIPELINE_ID') or os.getenv('RANDOM'),
            'branch': os.getenv('CI_COMMIT_BRANCH'),
            'test_name': '',
            'test_start_time': '',
            'test_end_time': '',
            'module': '',
            'function': '',
            'results': {},
            'extras': {}
        }
    }

    def __init__(self):
        self._args = self.get_args()

        ctx = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
        ctx.options |= 0x4  # OP_LEGACY_SERVER_CONNECT
        ctx.check_hostname = False
        self._session = requests.session()
        self._session.mount('https://', TransportAdapter(ctx))

    def run(self):
        if self._args.start:
            self.record['data'].update({
                'test_name': 'Set Environment',
                'test_start_time': str(datetime.now()),
                'test_end_time': str(datetime.now()),
                'module': '_conftest',
                'function': '_discover_environment',
                'extras': {
                    'start_time': str(datetime.now()),  # run_start_time
                    'git_branch': self.record['data']['branch'],
                    'config': {
                        'im_number': os.getenv('IM_NUMBER'),
                        'maintainer_email': os.getenv('MAINTAINER')
                    }
                }
            })

        elif self._args.end:
            self.record['data'].update({
                'test_name': 'Final State',
                'test_start_time': str(datetime.now()),
                'test_end_time': str(datetime.now()),
                'module': '_conftest',
                'function': '_end'
            })

        elif self._args.command:
            tests_group = os.getenv('TESTS_GROUP', '').lower()
            name = self._args.name or self._args.command.split()[0]

            start_time = str(datetime.now())
            results, out = self.execute_test(self._args.command)
            self.record['data'].update({
                'test_name': name,
                'test_start_time': start_time,
                'test_end_time': str(datetime.now()),
                'module': tests_group,
                'function': 'main',
                'results': results,
                'extras': {
                    'tests_group': tests_group
                }
            })

            print('### %s: %s' % (name, results['call']['status']))
            if self._args.stdout:
                print(out)

        else:
            raise RuntimeError('No viable option called, exiting...')

        self._session.post(self.dashboard_url, json=self.record, verify=False)

    @staticmethod
    def execute_test(command):
        results = {'setup': {'passed': True,
                             'status': 'passed',
                             'exception': None,
                             'report': ''},
                   'call':  {'passed': False,
                             'status': '',  # passed, failed, timeout
                             'exception': None,
                             'report': ''}}

        try:
            out = subprocess.check_output(command, shell=True,
                                          stderr=subprocess.STDOUT,
                                          timeout=300)
        except subprocess.CalledProcessError as exc:
            out = exc.output
            status = 'failed'
            exception = str(repr(exc))
        except subprocess.TimeoutExpired as exc:
            out = exc.output
            status = 'timeout'
            exception = str(repr(exc))
        else:
            status = 'passed'
            exception = None

        out = out.decode('utf-8') if out else ''
        passed = bool(status == 'passed')
        results['call'].update({'passed': passed,
                                'status': status,
                                'exception': exception,
                                'report': out if not passed else ''})

        return results, out

    @staticmethod
    def get_args():
        """
        Get arguments.
        :return: Arguments namespace.
        :rtype: _AttributeHolder
        """
        parser = argparse.ArgumentParser(
            description='Run SDK Tests by providing a corresponding command')

        test_group = parser.add_mutually_exclusive_group(required=True)
        test_group.add_argument(
            '-c', '--command', action='store', type=str, default=None,
            help='Command to be executed')
        test_group.add_argument(
            '-s', '--start', action='store_true', default=False,
            help='Start a series of test runs with the same id')
        test_group.add_argument(
            '-e', '--end', action='store_true', default=False,
            help='End a series of test runs with the same id')

        parser.add_argument(
            '-n', '--name', action='store', type=str,
            help='Name of the software tool (abbreviation)')
        parser.add_argument(
            '--stdout', action='store_true', default=False,
            help='Add STDOUT of the test run to the result')

        return parser.parse_args()


class TransportAdapter(requests.adapters.HTTPAdapter):

    """
    Transport adapter that allows to use custom ssl_context.
    """

    def __init__(self, ssl_context=None, **kwargs):
        self.ssl_context = ssl_context
        super().__init__(**kwargs)

    def init_poolmanager(self, connections, maxsize, block=False, **kwargs):
        # save these values for pickling
        self._pool_connections = connections
        self._pool_maxsize = maxsize
        self._pool_block = block

        self.poolmanager = urllib3.poolmanager.PoolManager(
            num_pools=connections, maxsize=maxsize, block=block,
            ssl_context=self.ssl_context, **kwargs)


if __name__ == '__main__':
    CITestsHandler().run()

