import toml
import os
import platform
import requests

def command():
    # parse config
    if not os.path.exists('./build'):
        os.mkdir('./build')
    
    if not os.path.exists('./build/__init__.py'):
        open('./build/__init__.py','a').close()

    result = toml.load('./karma.toml')

    target = result.get('target', {})
    arch = target.get('arch', platform.machine())
    pl = target.get('platform', platform.system())
    url = 'https://raw.githubusercontent.com/tiannian/KBT/python/platform/' + pl.lower() + '.py'
        
    print('Use ' + platform + '.py to build this project.')
    r = requests.get(url,stream=True)
    if r.status_code != 200:
        print('The specified platform does not exist, You can check the KBT home page to see the supported platforms.')
    print(url)
    #  with open('./build/' + pl.lower() + '.py', 'wb') as fd:
    #      for chunk in r.iter_content(chunk_size=128):
    #          fd.write(chunk)
    #
    #  handle = __import__('')

    # load platform

    # parse deps
    deps = []
    for dep in deps:
        # download deps
        pass
        # load download


