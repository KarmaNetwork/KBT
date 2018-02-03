def toolchain():
    return 'gcc', 'g++'

def debug():
    return 'gcc -g -o %s -c %s', 'g++ -g -o %s -c %s'

def release():
    return 'gcc -Os -o %s -c %s', 'g++ -Os -o %s -c %s'
