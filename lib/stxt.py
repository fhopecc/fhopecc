from __future__ import with_statement
import os, re, unittest
class Token:
  def __init__(self, token, lexeme, value, pos, len):
    self.token, self.lexeme, self.value = token, lexeme, value
    self.pos, self.len = pos, len
class Lexer:
  def __init__(self, src):
    self.src=src
    self.grammar=[(re.compile(r'^\S*\n=+\n', re.M), 
                   self.sect1Head),
                  (re.compile(r'^code\..*\n', re.M), 
                   self.codeHead),
                  (re.compile(r'(.+\n)+(^::\n)', re.M), 
                   self.codeBlock),
                  (re.compile(r'\* .*\n', re.M), 
                   self.listItem),
                  (re.compile(r'(.+\n)+(\n|\Z)', re.M), 
                   self.para),
                  (re.compile(r'^\s*$\n', re.M), 
                   self.emptyLine),
                  (re.compile(r'.*',re.M),
                   self.lexError)
                 ]
  def run(self):
    with open(r"d:\fhopecc\doc\db\timestamp.rtxt") as f:
      self.src, self.cur, self.tokens = f.read(), 0, []
      while self.cur < len(self.src):
        for p in self.grammar:
          m = p[0].match(self.src, self.cur)
          if m:
            p[1](m)
            self.cur += len(m.group(0))
            break
  def sect1Head(self,m):
    lexeme = m.group(0)
    tok = Token('sect1Head', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def codeHead(self,m):
    lexeme = m.group(0)
    tok = Token('codeHead', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def codeBlock(self,m):
    lexeme = m.group(0)
    tok = Token('codeBlock', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def para(self,m):
    lexeme = m.group(0)
    tok = Token('para', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def listItem(self,m):
    lexeme = m.group(0)
    tok = Token('listItem', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def emptyLine(self,m):
    lexeme = m.group(0)
    tok = Token('emptyLine', lexeme, 0, self.cur+1, len(lexeme))
    self.tokens.append(tok)
  def lexError(self,m):
    raise ValueError('LexError at (' + 
          str(self.src[self.cur:]).decode('utf8').encode('cp950')+')')
class RTxtLexerTest(unittest.TestCase):
  def testSource(self):
    l = Lexer(src='abcd')
    self.assertEqual('abcd', l.src)
    l.run()
    for t in l.tokens:
      print t.token+'['+t.lexeme.decode('utf8').encode('cp950')+']'
    print 'There are ' + str(len(l.tokens)) + ' tokens.'
if __name__ == '__main__':
  unittest.main()
