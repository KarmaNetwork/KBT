def toolchain():
    return 'gcc', 'g++'

def debug():
    return '-g -o $out -c $in', '-g -o $out -c $in'

def release():
    return '-Os -o $out -c $in', '-Os -o $out -c $in'
