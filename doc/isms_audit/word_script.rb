require "win32ole" 
require 'iconv'  
module WordConst
end 
ic = Iconv.new("big5", "utf-8")  
begin 
  word = WIN32OLE.connect("word.application") 
rescue 
  word = WIN32OLE.new("word.application") 
  word.documents.add 
end 
WIN32OLE.const_load word, WordConst
include WordConst
selection = word.selection
doc = word.activedocument

word.visible = true 
pagesetup = doc.pagesetup
pagesetup.orientation = WdOrientLandscape
pagesetup.topmargin = word.centimeterstopoints(2)
pagesetup.bottommargin = word.centimeterstopoints(1)
pagesetup.leftmargin = word.centimeterstopoints(2)
pagesetup.rightmargin = word.centimeterstopoints(1)

selection.paragraphFormat.alignment = WdAlignParagraphCenter
selection.font.namefareast          = ic.iconv("標楷體")
selection.font.nameascii            = "Times New Roman"
selection.font.size                 = 32
selection.typetext ic.iconv("花蓮縣地方稅務局")
selection.typeparagraph 
selection.font.size                 = 28
selection.typetext ic.iconv("98年度資訊稽核工作底稿")
selection.typeparagraph 

selection.font.size                 = 20
cur_table = doc.tables.add selection.range, 7, 2
cur_table.borders.insidelinestyle  = WdLineStyleSingle
cur_table.borders.outsidelinestyle = WdLineStyleSingle

col  = cur_table.columns(1)
colv = cur_table.columns(2)
cur_table.columns(1).width = 200
cur_table.columns(2).width = 560
col.cells(1).range.text  = ic.iconv("稽核項目")
colv.cells(1).range.text = ic.iconv("9.存取控制、10.資訊系統獲取、開發及維護、11.資訊安全事故管理")
colv.cells(1).range.font.size = 12

col.cells(2).range.text = ic.iconv("稽核日期")
colv.cells(2).range.text = ic.iconv("97年11月10日-97年11月24日")

col.cells(3).range.text = ic.iconv("稽核人員")
col.cells(4).range.text = ic.iconv("複核人員")
col.cells(5).range.text = ic.iconv("參與檢討人員")
col.cells(6).range.text = ic.iconv("相關稽核文書")
cur_table.rows(7).cells.merge
note = "    分發：討論用□      供相關單位參考□      納入稽查報告□"
range =  cur_table.rows(7).cells(1).range
range.text  = ic.iconv(note) 
range.paragraphformat.alignment = WdAlignParagraphLeft

selection.endkey WdStory, WdMove
selection.insertbreak "Type" => WdPageBreak
selection.font.size                 = 20
report_title = ic.iconv("花蓮縣地方稅務局98年度資訊稽核工作底稿")
section_title = ic.iconv("9.存取控制")

selection.paragraphFormat.alignment = WdAlignParagraphCenter
selection.typeText report_title
selection.typeParagraph

selection.paragraphFormat.alignment = WdAlignParagraphLeft
selection.typeText section_title

selection.endKey WdStory, WdMove
selection.font.size                 = 12
cur_table = doc.tables.add selection.range, 1, 6
cur_table.borders.insidelinestyle  = WdLineStyleSingle
cur_table.borders.outsidelinestyle = WdLineStyleSingle
cur_table.columns(1).width = 20
cur_table.columns(2).width = 200
cur_table.columns(3).width = 70
cur_table.columns(4).width = 250
cur_table.columns(5).width = 140
cur_table.columns(6).width = 80
row = cur_table.rows(1)
row.range.paragraphformat.alignment = WdAlignParagraphDistribute
row.cells(1).range.text = ic.iconv("編號")
row.cells(2).range.text = ic.iconv("稽核項目")
row.cells(3).range.text = ic.iconv("受檢單位")
row.cells(4).range.text = ic.iconv("事實狀況")
row.cells(5).range.text = ic.iconv("改進建議事項")
row.cells(6).range.text = ic.iconv("備註")
entry_no = 0
entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否訂有資訊存取控制政策及相關說明文件？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否訂定使用者存取權限註冊及註銷之作業程序？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否定期審查並移除久未使用之使用者權限？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否要求使用者對其個人通行碼應盡保護及保密責任？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否強制要求使用者初次登入電腦系統後必須立即更改預設之通行碼？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("對於忘記通行碼之處理，是否要求須作身份確認程序？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("使用者存取權限是否定期檢查(建議每六個月一次)或在權限變更後立即複檢？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("通行碼長度是否規定須超過6個字元(建議以9位或以上)？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("通行碼是否規定需有大小寫字母及數字組成？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("通行碼輸入錯誤，是否訂有三次以下之限制？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否依規定期限或使用次數限制，要求變更通行碼？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否規定避免使用與個人有關資料（如生日、身份證字號、單位簡稱、電話號碼等）當做通行碼？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科、業務單位")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("應用系統是否具有作業結束後或在一定期間未操作時即自動登出之保護機制？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科、業務單位")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("個人電腦及終端機不使用時是否有關機或登出或設定螢幕通行碼或其他控制措施進行保護？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科、業務單位")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否訂有重要資訊不得閒置於桌面及螢幕淨空政策？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("網路使用者(含外單位人員)是否取得正式存取授權？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否設有檢測連線的來源位址與目的位址網路路由之控管措施？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否限制登入失敗次數的上限(建議三次)並中斷連線？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否於登入作業完成後顯示前一次登入的日期與時間，或提供登入失敗的詳細資料？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("使用者是否均有唯一的識別碼？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否訂有使用者及應用系統對資訊存取之權限管制措施？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("機密及敏感性資料的處理是否採用專屬(隔離)的電腦作業環境？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")


ranget = row.cells(1).range
ranget.move "Unit" => WdWord, "Count" => 1
ranget.select
word.selection.rows.headingformat = true
selection.endkey WdStory, WdMove
selection.insertbreak "Type" => WdPageBreak
selection.font.size                 = 20
report_title = ic.iconv("花蓮縣地方稅務局98年度資訊稽核工作底稿")
section_title = ic.iconv("10.資訊系統獲取、開發及維護")

selection.paragraphFormat.alignment = WdAlignParagraphCenter
selection.typeText report_title
selection.typeParagraph

selection.paragraphFormat.alignment = WdAlignParagraphLeft
selection.typeText section_title

selection.endKey WdStory, WdMove
selection.font.size                 = 12
cur_table = doc.tables.add selection.range, 1, 6
cur_table.borders.insidelinestyle  = WdLineStyleSingle
cur_table.borders.outsidelinestyle = WdLineStyleSingle
cur_table.columns(1).width = 20
cur_table.columns(2).width = 200
cur_table.columns(3).width = 70
cur_table.columns(4).width = 250
cur_table.columns(5).width = 140
cur_table.columns(6).width = 80
row = cur_table.rows(1)
row.range.paragraphformat.alignment = WdAlignParagraphDistribute
row.cells(1).range.text = ic.iconv("編號")
row.cells(2).range.text = ic.iconv("稽核項目")
row.cells(3).range.text = ic.iconv("受檢單位")
row.cells(4).range.text = ic.iconv("事實狀況")
row.cells(5).range.text = ic.iconv("改進建議事項")
row.cells(6).range.text = ic.iconv("備註")
entry_no = 0
entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("輸入資料是否作檢查，以確認其正確且適切性？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("作業系統軟體更新是否需經管理階層授權之人員處理？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("委外開發合約中是否對著作權之歸屬訂有規範？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否定期執行各項系統漏洞修補程式？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")


ranget = row.cells(1).range
ranget.move "Unit" => WdWord, "Count" => 1
ranget.select
word.selection.rows.headingformat = true
selection.endkey WdStory, WdMove
selection.insertbreak "Type" => WdPageBreak
selection.font.size                 = 20
report_title = ic.iconv("花蓮縣地方稅務局98年度資訊稽核工作底稿")
section_title = ic.iconv("11.資訊安全事故管理")

selection.paragraphFormat.alignment = WdAlignParagraphCenter
selection.typeText report_title
selection.typeParagraph

selection.paragraphFormat.alignment = WdAlignParagraphLeft
selection.typeText section_title

selection.endKey WdStory, WdMove
selection.font.size                 = 12
cur_table = doc.tables.add selection.range, 1, 6
cur_table.borders.insidelinestyle  = WdLineStyleSingle
cur_table.borders.outsidelinestyle = WdLineStyleSingle
cur_table.columns(1).width = 20
cur_table.columns(2).width = 200
cur_table.columns(3).width = 70
cur_table.columns(4).width = 250
cur_table.columns(5).width = 140
cur_table.columns(6).width = 80
row = cur_table.rows(1)
row.range.paragraphformat.alignment = WdAlignParagraphDistribute
row.cells(1).range.text = ic.iconv("編號")
row.cells(2).range.text = ic.iconv("稽核項目")
row.cells(3).range.text = ic.iconv("受檢單位")
row.cells(4).range.text = ic.iconv("事實狀況")
row.cells(5).range.text = ic.iconv("改進建議事項")
row.cells(6).range.text = ic.iconv("備註")
entry_no = 0
entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否建立資安事件(含安全漏洞、系統弱點、病毒、非法入侵及系統異常)之通報及處理程序？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("是否建立資安事故管理責任及應變程序？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科")

entry_no += 1
cur_row = cur_table.rows.add
cur_col = 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphCenter
range.text = entry_no.to_s
cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("機關員工及外部使用者是否知悉資安事件通報及處理程序並依規定辦理？")

cur_col += 1
range = cur_row.cells(cur_col).range
range.paragraphformat.alignment = WdAlignParagraphLeft
range.text = ic.iconv("資訊科、業務單位")


ranget = row.cells(1).range
ranget.move "Unit" => WdWord, "Count" => 1
ranget.select
word.selection.rows.headingformat = true


word.activedocument.saveas "FileName" => 'd:\\moneylog\\public\\isms\\group4.doc'
word.quit WdSaveChanges
