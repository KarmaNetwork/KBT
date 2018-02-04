import toml
import os
import platform
import requests
import sys
import tarfile
import io
from lib.ninja_syntax import Writer as Ninja

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

    if not os.path.exists('./dependences'):
        os.mkdir('./dependences')

    # parse deps
    def load_deps(name, version):
        if not os.path.exists('./dependences/' + name + '-' + version):
            print('Downloading ' + name + '-' + version)
            url = 'https://codeload.github.com/' + name + '/tar.gz/' + version
            r = requests.get(url, stream=True)
            if r.status_code != 200:
                print('The specified dependency does not exist.')
                return False
            t = tarfile.open(fileobj=io.BytesIO(r.content), mode="r|gz")
            t.extractall("./dependences")
        # load
        result = toml.load("./dependences/" + name + '-' + version + 'karma.toml')
        dependences = result.get('dependences',{})
        for name, version in dependences.items():
            load_deps(name, version)

    deps = result.get('dependences',{})
    for name, version in deps.items():
        load_deps(name, version)

    # search files get array

    def load_files(path,clist,cxxlist):
        r = os.listdir(path)
        for f in r:
            if f == '.git' or f == 'build':
                continue
            p = os.path.join(path,f)
            if os.path.isdir(p):
                load_files(p,clist,cxxlist)
            elif os.path.splitext(p)[1] == '.c':
                clist.append(p)
            elif os.path.splitext(p)[1] == '.cpp':
                cxxlist.append(p)
    clist = []
    cxxlist = []
    load_files('./',clist,cxxlist)

    # build ninja
    n = open('./build.ninja','w')
    ninja = Ninja(n)
    ninja.rule('cdebug',ccompiler + ' -MMD -MF ' + cdebug, description='Building C debug $out ...', depfile='$out.d')
    ninja.rule('cxxdebug', cxxcompiler + ' -MMD -MF ' + cxxdebug, description='Building CXX debug $out ...', depfile='$out.d')
    ninja.rule('crelease', ccompiler + ' -MMD -MF ' + crelease, description='Building C release $out ...', depfile='$out.d')
    ninja.rule('cxxrelease', cxxcompiler + ' -MMD -MF ' + cxxrelease, description='Building CXX release $out ...', depfile='$out.d')
    for f in clist:
        na = os.path.split(f)[1]
        ninja.build('./build/debug/'+ na + '.o','cdebug',inputs=f)
        ninja.build('./build/release'+ na + '.o','crelease',inputs=f)
    for f in cxxlist:
        na = os.path.split(f)[1]
        ninja.build('./build/debug/'+ na + '.o','cdebug',inputs=f)
        ninja.build('./build/release'+ na + '.o','crelease',inputs=f)
    n.close()
    
    # link ninja

    # deal ninja

    # start build

