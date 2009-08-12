from os import path
import os, re, unittest
def p(s):
  print s
  return True
def listdir(dir='.'):
  for f in os.listdir(dir):
    print f
def walkdir(dir, visit):
  os.chdir(dir)
  for f in os.listdir(dir):
    if path.isdir(f):
      visit(path.abspath(f))
      os.chdir(f)
      walkdir('.',visit)
    else:
      visit(path.abspath(f)) 
  os.chdir('..') # *.gif -> \w*.gif
def glob2re(glob):
  glob = glob.replace('/', os.sep)
  glob = glob.replace('\\',r'\\')
  globr = ''
  while not globr == glob:
    globr = glob.replace('**', '.rstar(?=', 1)
    if not globr == glob:
      glob = globr + '$)'
  glob = glob.replace('*', r'[^\]*')
  glob = glob.replace('rstar', r'*')
  glob = '^' + glob
  # + '$'
  return glob
#listdir()
mf = []
def fmatch(glob):
  if not path.isabs(glob):
    glob = path.join(os.getcwd(),glob)
  glob = glob2re(glob)
  print glob
  def _fmatch(f):
    r = re.compile(glob)
    m = r.match(f)
    if m != None:
      mf.append(f)
      p(f)
  return _fmatch
# Test in Windows Path Environment
class ClassifyDocWinTest(unittest.TestCase):
  def testDStar(self):
    self.assertEqual(r'^.*(?=\\test$)',
                       glob2re(r'**/test'))
    self.assert_(re.match(r'^.*(?=\\test$)', 
                 r'c:\abc\ddd\test'))
    #self.assert_(re.match(glob2re(r'**/test'), 
    #             'c:\\abc\\ddd\\test'))
    #self.assertEqual(r'^.*(?=\\test\\qef$)$',
    #                   glob2re(r'**/test/qef'))
    #self.assertEqual(r'^abc\\.*(?=\\test\\qef$)$',
    #                   glob2re(r'abc/**/test/qef'))
    #self.assertEqual(r'^abc\\.*(?=\\test\\.*(?=\\qef$)$)$',
    #                   glob2re(r'abc/**/test/**/qef'))
  #def testStar(self):
    #self.assertEqual(r'^[^\]*\\test$',
    #                   glob2re(r'*/test'))
  #def testPathSep(self):
    #self.assertEqual(r'^lib\\test$',
    #                   glob2re(r'lib/test'))
    
if __name__ == '__main__':
 unittest.main()
