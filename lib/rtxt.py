import os, re, unittest
class RTxtLexerTest(unittest.TestCase):
  def testDStar(self):
    self.assertEqual(r'^.*(?=\\test$)',
                       glob2re(r'**/test'))
if __name__ == '__main__':
 unittest.main()
