# coding=utf-8
import sys, os
#sys.path.append(os.path.dirname(__file__).replace(r'lib','config'))
import pymssql
class NETDB(object):
  def __init__(self):
    self.conn = pymssql.connect(host='netdb', user='eltweb', \
        password='bewt_111', database='yrxweb')
  def cursor(self):return self.conn.cursor()
netdb = NETDB()
if __name__ == '__main__':
  c = netdb.cursor()
  #c.execute('ALTER TABLE YRXC828 ADD ORG_GVNR NVARCHAR(10)')
  #netdb.conn.commit()
  c.execute('select ORG_GVNR from YRXC828')
  r = c.fetchone()
  print r
