Attribute VB_Name = "fhopecc"
Sub Print2AndCloseWord()
Attribute Print2AndCloseWord.VB_Description = "巨集錄製於 2008/3/3，錄製者 ccl00695"
Attribute Print2AndCloseWord.VB_ProcData.VB_Invoke_Func = "Normal.NewMacros.closeword"
'
' closeword 巨集
' 巨集錄製於 2008/3/3，錄製者 ccl00695
'
  ActiveWindow.ActivePane.View.SeekView = wdSeekCurrentPageFooter
  Selection.EndKey Unit:=wdLine, Extend:=wdExtend
  Selection.Delete Unit:=wdCharacter, Count:=1
  
  Selection.Font.NameFarEast = "標楷體"
  Selection.Font.NameAscii = "Times New Roman"
  
  Selection.TypeText Text:="承辦人                         股長                               科長"
  ActiveWindow.ActivePane.View.SeekView = wdSeekMainDocument
    
  Application.ActiveDocument.PrintOut Background:=False, Copies:=2
  
  Application.Quit SaveChanges:=wdDoNotSaveChanges

End Sub

Sub PrintAndCloseWord()
'
' closeword 巨集
' 巨集錄製於 2008/3/3，錄製者 ccl00695
'
  Application.ActiveDocument.PrintOut Background:=False, Copies:=1
  
  Application.Quit SaveChanges:=wdDoNotSaveChanges

End Sub
