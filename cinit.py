from git import Repo
import os
import toml
import platform

def init_bin(name):
    os.mkdir('./src')
    string = '#include "' + name + '.h"\n\n' + 'int main() {\n\n}\n'
    f = open('./src/' + name + '.c', 'w')
    f.write(string)
    f.close()

def init_lib(name):
    os.mkdir('./src')
    #  string = '#include "' + name + '.h"\n\n' + 'int () {\n\n}\n'
    #  f = open('./src/' + name + '.c', 'w')
    #  f.write(string)
    #  f.close()

def command(t):
    # init git repo
    r = Repo.init('.')
    config = r.config_reader(config_level='global')
    name = config.get_value('user','name')
    dir_name = os.path.basename(os.getcwd())
    pname = name + '/' + dir_name

    # create karma.toml
    karma = open('./karma.toml', 'w')
    config = {}
    project = {}
    project['name'] = pname
    project['version'] = '0.1.0'
    project['type'] = 'lib' if t else 'bin'

    target = {}
    target['arch'] = platform.machine()
    target['platform'] = platform.system()

    expect = {}
    expect['arch'] = ['General']
    expect['platform'] = ['General']

    dep = {}

    config['project'] = project
    config['target'] = target
    config['expect'] = expect
    config['dependences'] = dep
    
    toml.dump(config, karma)
    karma.close()
    os.chmod('./karma.toml',0o640)

    # create source file
    os.mkdir('./include')
    string = '#ifndef ' + dir_name.upper() + '_H\n' + '#define ' + dir_name.upper() + '_H' + '\n\n' + '#endif\n'
    f = open('./include/' + dir_name + '.h', 'w')
    f.write(string)
    f.close()
    if t:
        init_lib(dir_name)
    else:
        init_bin(dir_name)
    
    # add gitignore
    f = open('./.gitignore','w')
    f.write('dependences/\n')
    f.write('build/\n')
    f.write('build.ninja\n')
    f.close()
