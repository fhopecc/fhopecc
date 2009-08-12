class OpenStruct:
	def __init__(self, **dic):
		self.__dict__.update(dic)
	def __getattr__(self, i):
		if i in self.__dict__:
			return self.__dict__[i]
		else:
			raise AttributeError, i

	def __setattr__(self,i,v):
		if i in self.__dict__:
			self.__dict__[i] = v
		else:
			self.__dict__.update({i:v})
		return v # i like cascates :)

class DocTreeNode(OpenStruct):
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

def sect(name, title, *nodes):
  return DocTreeNode(name, nodes)

# Test in Windows Path Environment
import unittest
class DocTreeNodeTest(unittest.TestCase):
  def testOpenStruct(self):
    d = DocTreeNode('1')
    d.new_attr = "new value"
    self.assertEqual('new value', d.new_attr)
    self.assertRaises(AttributeError, lambda :d.no_attr)
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
#  def testSect(self):
    #n = sect("sect name", 
#"This is a section title", '''
#This is section content, 
#and it's multi lines.
#''')
#    self.assertEqual('sect name', n.name)

if __name__ == '__main__':
 unittest.main()
