def sect(name, *nodes):
  o = "name is " + name
  for n in nodes:
    o = o + n
  return o
class DocTreeNode:
  def __init__(self, name, type=None, value=None, parent=None):
    self.name     = name
    self.parent   = parent
    self.type     = type
    self.value    = value
    self.children = []
  def isRoot(self):
    return self.parent == None
  def addChild(self, c):
    self.children.append(c)
    c.parent = self

# Test in Windows Path Environment
import unittest
class DocTreeNodeTest(unittest.TestCase):
  def testSingleNode(self):
    d = DocTreeNode('1')
    self.assertEqual('1', d.name)
    self.assert_(d.isRoot())
  def testDirectChildren(self):
    d = DocTreeNode('1')
    c = DocTreeNode('2')
    d.addChild(c)
    self.assertEqual('2', d.children[0].name)
    self.assertEqual('1', c.parent.name)
  def testSect(self):
    o = sect("name", '''abcd
def rwd
  class 
''', "abcd")
    self.assertEqual('2', o)

if __name__ == '__main__':
 unittest.main()
