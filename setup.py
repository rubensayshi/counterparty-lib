#!/usr/bin/env python
from setuptools.command.install import install as _install
from setuptools.command.bdist_egg import bdist_egg as _bdist_egg
from setuptools import setup, find_packages, Command
import inspect
import ssl
import os
import zipfile
import urllib.request
import sys
import shutil

from counterpartylib.lib import config

CURRENT_VERSION = config.VERSION_STRING

# NOTE: Why we don’t use the the PyPi package:
# <https://github.com/rogerbinns/apsw/issues/66#issuecomment-31310364>
class install_apsw(Command):
    description = "Install APSW 3.8.7.3-r1 with the appropriate version of SQLite"
    user_options = []

    def initialize_options(self):
        pass
    def finalize_options(self):
        pass

    def run(self):
        # In Windows APSW should be installed manually
        if os.name == 'nt':
            print('To complete the installation you have to install APSW: https://github.com/rogerbinns/apsw/releases')
            return

        try:
            import apsw
            return
        except:
            pass

        print("downloading apsw.")
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        with urllib.request.urlopen('https://github.com/rogerbinns/apsw/archive/3.8.7.3-r1.zip', timeout=10, context=ctx) as u, open('apsw-3.8.7.3-r1.zip', 'wb') as f:
            f.write(u.read())

        print("extracting.")
        with zipfile.ZipFile('apsw-3.8.7.3-r1.zip', 'r') as zip_file:
            zip_file.extractall()

        executable = sys.executable
        if executable is None:
            executable = "python"

        print("install apsw.")
        install_command = ('cd apsw-3.8.7.3-r1 && {executable} '
          'setup.py fetch --version=3.8.7.3 --all build '
          '--enable-all-extensions install'.format(executable=executable)
        )
        os.system(install_command)

        print("clean files.")
        shutil.rmtree('apsw-3.8.7.3-r1')
        os.remove('apsw-3.8.7.3-r1.zip')


class install_serpent(Command):
    description = "Install Ethereum Serpent"
    user_options = _install.user_options + [
        ("global-install-serpent", None, "Install `serpent` in /usr/bin"),
    ]
    boolean_options = _install.boolean_options + ['global-install-serpent']

    def initialize_options(self):
        self.global_install_serpent = False
        self.clean = True
        pass

    def finalize_options(self):
        pass

    def run(self):
        repo = "rubensayshi"
        branch = "counterparty"

        # In Windows Serpent should be installed manually
        if os.name == 'nt':
            print('To complete the installation you have to install Serpent %s branch: https://github.com/%s/serpent/tree/%s' % (branch, repo, branch))
            return

        if not os.path.isdir("./serpent-%s" % branch):
            print("downloading serpent.")
            urllib.request.urlretrieve('https://github.com/%s/serpent/archive/%s.zip' % (repo, branch), 'serpent.zip')

            print("extracting.")
            with zipfile.ZipFile('serpent.zip', 'r') as zip_file:
                zip_file.extractall()

        print("making serpent.")
        os.system('cd serpent-%s && make' % branch)

        print("install serpent as python lib.")
        os.system('cd serpent-%s && python setup.py install' % branch)

        print("install serpent in `./bin`.")
        os.system('cp serpent-%s/serpent ./bin/serpent' % branch)

        if self.global_install_serpent:
            print("global install serpent using sudo.")
            print("hence it might request a password.")
            os.system('cd serpent-%s && sudo make install' % branch)

        if self.clean:
            print("clean files.")
            shutil.rmtree('serpent-%s' % branch)
        os.remove('serpent.zip')


class install_solc(_install):
    """
    http://www.ethdocs.org/en/latest/ethereum-clients/cpp-ethereum/building-from-source/linux-ubuntu.html
     - the LLVM part is not neccesary
     - the `sudo add-apt-repository -y ppa:ethereum/ethereum-qt` is not neccesary
        - but then you need to remove the following from the apt-get install:
          `qtbase5-dev qt5-default qtdeclarative5-dev libqt5webkit5-dev libqt5webengine5-dev`
     - if fails `sudo apt-get -y install libjson-rpc-cpp-dev` try `apt-get -y install libjsonrpccpp-dev`

    """

    description = "Install Ethereum Solidity"
    user_options = _install.user_options + [
        ("global-install-solc", None, "Install `solc` in /usr/bin"),
    ]
    boolean_options = _install.boolean_options + ['global-install-solc']

    def initialize_options(self):
        self.global_install_solc = False
        self.clean = True
        _install.initialize_options(self)

    def finalize_options(self):
        pass

    def run(self):
        repo = "rubensayshi"
        branch = "counterparty"

        # In Windows Solidity should be installed manually
        if os.name == 'nt':
            print('Windows requires manual install, good luck ... @TODO')  # @TODO
            return

        if not os.path.isdir("./webthree-umbrella"):
            print("downloading webthree-umbrella.")
            print('git clone --recursive --branch v1.2.6 git://github.com/ethereum/webthree-umbrella.git')
            os.system('git clone --recursive --branch v1.2.6 git://github.com/ethereum/webthree-umbrella.git')

            os.system('cd webthree-umbrella/solidity && '
                      'git remote add counterparty git://github.com/%s/solidity.git' % (repo))

        os.system('cd webthree-umbrella/solidity && '
                  'git fetch counterparty && '
                  'git checkout -f %s &&'
                  'git reset --hard counterparty/%s' % (branch, branch))

        print("building.")
        os.system('cd webthree-umbrella && ./webthree-helpers/scripts/ethbuild.sh --no-git --project solidity --cores 4 -DEVMJIT=0 -DETHASHCL=0 -DGUI=0')

        print("copying to ./bin")
        os.system('cp webthree-umbrella/solidity/build/solc/solc ./bin')

        if self.global_install_solc:
            print("copying to /usr/bin")
            os.system('sudo cp webthree-umbrella/solidity/build/solc/solc /usr/bin/solc')

        if self.clean:
            print("clean files.")
            shutil.rmtree('webthree-umbrella')


class move_old_db(Command):
    description = "Move database from old to new default data directory"
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        import appdirs

        old_data_dir = appdirs.user_config_dir(appauthor='Counterparty', appname='counterpartyd', roaming=True)
        old_database = os.path.join(old_data_dir, 'counterpartyd.9.db')
        old_database_testnet = os.path.join(old_data_dir, 'counterpartyd.9.testnet.db')

        new_data_dir = appdirs.user_data_dir(appauthor=config.XCP_NAME, appname=config.APP_NAME, roaming=True)
        new_database = os.path.join(new_data_dir, '{}.db'.format(config.APP_NAME))
        new_database_testnet = os.path.join(new_data_dir, '{}.testnet.db'.format(config.APP_NAME))

        # User have an old version of `counterpartyd`
        if os.path.exists(old_data_dir):
            # Move database
            if not os.path.exists(new_data_dir):
                os.makedirs(new_data_dir)
                files_to_copy = {
                    old_database: new_database,
                    old_database_testnet: new_database_testnet
                }
                for src_file in files_to_copy:
                    if os.path.exists(src_file):
                        dest_file = files_to_copy[src_file]
                        print('Copy {} to {}'.format(src_file, dest_file))
                        shutil.copy(src_file, dest_file)


def post_install(cmd, install_serpent=False, install_solc=False):
    cmd.run_command('install_apsw')
    if install_serpent:
        cmd.run_command('install_serpent')
    if install_solc:
        cmd.run_command('install_solc')
    cmd.run_command('move_old_db')


class install(_install):
    user_options = _install.user_options + [
        ("with-serpent", None, "Install Ethereum Serpent"),
        ("with-solc", None, "Install Ethereum Solc"),
    ]
    boolean_options = _install.boolean_options + ['with-serpent', 'with-solc']

    def initialize_options(self):
        self.with_serpent = False
        self.with_solc = False
        _install.initialize_options(self)

    #Some of this code taken from https://bitbucket.org/pypa/setuptools/src/4ce518784af886e6977fa2dbe58359d0fe161d0d/setuptools/command/install.py?at=default&fileviewer=file-view-default
    @staticmethod
    def _called_from_setup(run_frame):
        """
        Attempt to detect whether run() was called from setup() or by another
        command.  If called by setup(), the parent caller will be the
        'run_command' method in 'distutils.dist', and *its* caller will be
        the 'run_commands' method.  If called any other way, the
        immediate caller *might* be 'run_command', but it won't have been
        called by 'run_commands'. Return True in that case or if a call stack
        is unavailable. Return False otherwise.
        """
        if run_frame is None:
            msg = "Call stack not available. bdist_* commands may fail."
            warnings.warn(msg)
            if platform.python_implementation() == 'IronPython':
                msg = "For best results, pass -X:Frames to enable call stack."
                warnings.warn(msg)
            return True
        res = inspect.getouterframes(run_frame)[2]
        caller, = res[:1]
        info = inspect.getframeinfo(caller)
        caller_module = caller.f_globals.get('__name__', '')
        return (
            caller_module == 'distutils.dist'
            and info.function == 'run_commands'
        )
        
    def run(self):
        # Explicit request for old-style install?  Just do it
        if self.old_and_unmanageable or self.single_version_externally_managed:
            _install.run(self)
            self.execute(post_install, (self, False), msg="Running post install tasks")
            return

        if not self._called_from_setup(inspect.currentframe()):
            # Run in backward-compatibility mode to support bdist_* commands.
            _install.run(self)
        else:
            self.do_egg_install()
        self.execute(post_install, (self, self.with_serpent, self.with_solc), msg="Running post install tasks")

class bdist_egg(_bdist_egg):
    def run(self):
        _bdist_egg.run(self)
        self.execute(post_install, (self, False), msg="Running post install tasks")

required_packages = [
    'python-dateutil==2.5.3',
    'Flask-HTTPAuth==3.1.2',
    'Flask==0.11',
    'appdirs==1.4.0',
    'colorlog==2.7.0',
    'json-rpc==1.10.3',
    'pycoin==0.62',
    'pycrypto==2.6.1',
    'pysha3==0.3',
    'pytest==2.9.1',
    'pytest-cov==2.2.1',
    'python-bitcoinlib==0.5.0',
    'requests==2.10.0',
    'tendo==0.2.8',
    'xmltodict==0.10.1',
    'cachetools==1.1.6',
    'rlp==0.4.4',
]

setup_options = {
    'name': 'counterparty-lib',
    'version': CURRENT_VERSION,
    'author': 'Counterparty Developers',
    'author_email': 'dev@counterparty.io',
    'maintainer': 'Counterparty Developers',
    'maintainer_email': 'dev@counterparty.io',
    'url': 'http://counterparty.io',
    'license': 'MIT',
    'description': 'Counterparty Protocol Reference Implementation',
    'keywords': 'counterparty, bitcoin',
    'classifiers': [
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "Intended Audience :: Financial and Insurance Industry",
        "License :: OSI Approved :: MIT License",
        "Natural Language :: English",
        "Operating System :: Microsoft :: Windows",
        "Operating System :: POSIX",
        "Programming Language :: Python :: 3 :: Only ",
        "Topic :: Office/Business :: Financial",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: System :: Distributed Computing"
    ],
    'download_url': 'https://github.com/CounterpartyXCP/counterparty-lib/releases/tag/v' + CURRENT_VERSION,
    'provides': ['counterpartylib'],
    'packages': find_packages(),
    'zip_safe': False,
    'setup_requires': ['appdirs'],
    'install_requires': required_packages,
    'include_package_data': True,
    'cmdclass': {
        'install': install,
        'move_old_db': move_old_db,
        'install_apsw': install_apsw,
        'install_serpent': install_serpent,
        'install_solc': install_solc
    }
}

if sys.argv[1] == 'sdist':
    setup_options['long_description_markdown_filename'] = 'README.md'
    setup_options['setup_requires'].append('setuptools-markdown')

setup(**setup_options)
