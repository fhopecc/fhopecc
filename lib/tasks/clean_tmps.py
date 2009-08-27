import os, fnmatch
def clear_tmps(dir):
  for root, dirs, files in os.walk(dir):
    for f in [f for f in files if fnmatch.fnmatch(f, '*~')]:
      p = os.path.join(root, f)
      os.remove(p)
      print 'remove ' + p
if __name__ == '__main__':
  clear_tmps(os.path.dirname(__file__).replace(r'\task', ''))
