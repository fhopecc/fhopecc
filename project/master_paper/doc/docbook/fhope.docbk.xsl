<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="docbook.xsl"/>
<!-- we use chinese -->
<xsl:param name="l10n.gentext.language" select="'zh_tw'"/>
<!-- we only need the short name for cross ref -->
<xsl:param name="xref.with.number.and.title" select="0"/>
<!-- sci ref is only show number -->
<xsl:param name="bibliography.numbered" select="1"/>
<!-- section number -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.autolabel.max.depth" select="2"/>
<!-- figure position configure -->
<xsl:param name="formal.title.placement">
figure after
example before
equation before
table before
procedure before
task before
</xsl:param>
<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title,figure,table
book      toc,title,figure,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
</xsl:param>
</xsl:stylesheet>
