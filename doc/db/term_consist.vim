:%s/關聯式/關連式
:%s/關聯表/表格
:%s/關連/表格
:%s/屬性值/紀錄值
:%s/屬性/欄位
:%s/表格式代數/關連式代數
:%s/表格式計算/關連式計算
:%s/<chapter><title>/<%section '
:%s/<\/chapter>/<%end%>
:%s/<sect1><title>/% section '
:%s/<procedure>/% paragraph do
:%s/<procedure [^>]*><title>/% section '
:%s/<\/procedure>/% end
:%s/<\/sect1>/% end
:%s/<\/title>/' do
:%s/<para>/% paragraph do
:%s/<\/para>/% end
:%s/<listitem>/% paragraph do
:%s/<\/listitem>/% end
:%s/<step>/% paragraph do
:%s/<step [^>]*>/% paragraph do
:%s/<\/step>/% end
:%s/<substeps>/% paragraph do
:%s/<\/substeps>/% end
:%s/<emphasis>//
:%s/<\/emphasis>//
:%s/<xref linkend=/<%=xref /
:%s/<itemizedlist>//
:%s/<\/itemizedlist>//
:%s/% paragraph$/% paragraph do/
