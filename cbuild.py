import toml
import os
import platform
import requests
import sys

sys.path.append('.')

def command():
    # parse config
    if not os.path.exists('./build'):
        os.mkdir('./build')

    if not os.path.exists('./build/__init__.py'):
        open('./build/__init__.py','a').close()

    if not os.path.exists('./build/kbt'):
        os.mkdir('./build/kbt')
    
    if not os.path.exists('./build/kbt/__init__.py'):
        open('./build/kbt/__init__.py','a').close()

    result = toml.load('./karma.toml')

    target = result.get('target', {})
    arch = target.get('arch', platform.machine())
    pl = target.get('platform', platform.system()).lower()

    print('Use ' + pl + '.py to build this project.')
    if not os.path.exists('./build/kbt/' + pl + '.py'):
        url = 'https://raw.githubusercontent.com/tiannian/KBT/python/platform/' + pl.lower() + '.py'
        r = requests.get(url,stream=True)
        if r.status_code != 200:
            print('The specified platform does not exist, You can check the KBT home page to see the supported platforms.')
            return
        with open('./build/kbt/' + pl + '.py', 'wb') as fd:
            for chunk in r.iter_content(chunk_size=128):
                fd.write(chunk)

    handle = __import__('build.kbt.' + pl, fromlist=pl)

    # load platform
    ccompiler, cxxcompiler = handle.toolchain()
    cdebug, cxxdebug = handle.debug()
    crelease, cxxrelease = handle.release()

    # parse deps
    deps = result.get('dependences',{})
    for name, version in deps.items():
        # download deps
        pass
        # load download

    # build ninja

    # start build

