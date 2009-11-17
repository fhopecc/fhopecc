import os, fnmatch
def istmp(f):
  return fnmatch.fnmatch(f, '*~') or \
    fnmatch.fnmatch(f, '*.pyc') or \
    fnmatch.fnmatch(f, 'log') or \
    fnmatch.fnmatch(f, 'log2') or \
    fnmatch.fnmatch(f, 'lextab.py') or \
    fnmatch.fnmatch(f, 'parsetab.py') or \
    fnmatch.fnmatch(f, 'parser.out') 

def clear_tmps(dir):
  for root, dirs, files in os.walk(dir):
    for f in [f for f in files if istmp(f) ]:
      p = os.path.join(root, f)
      os.remove(p)
      print 'remove ' + p
if __name__ == '__main__':
  clear_tmps(os.path.dirname(__file__).replace(r'\task', ''))
