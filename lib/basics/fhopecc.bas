Attribute VB_Name = "fhopecc"
Sub Print2AndCloseWord()
Attribute Print2AndCloseWord.VB_Description = "�������s�� 2008/3/3�A���s�� ccl00695"
Attribute Print2AndCloseWord.VB_ProcData.VB_Invoke_Func = "Normal.NewMacros.closeword"
'
' closeword ����
' �������s�� 2008/3/3�A���s�� ccl00695
'
  ActiveWindow.ActivePane.View.SeekView = wdSeekCurrentPageFooter
  Selection.EndKey Unit:=wdLine, Extend:=wdExtend
  Selection.Delete Unit:=wdCharacter, Count:=1
  
  Selection.Font.NameFarEast = "�з���"
  Selection.Font.NameAscii = "Times New Roman"
  
  Selection.TypeText Text:="�ӿ�H                         �Ѫ�                               ���"
  ActiveWindow.ActivePane.View.SeekView = wdSeekMainDocument
    
  Application.ActiveDocument.PrintOut Background:=False, Copies:=2
  
  Application.Quit SaveChanges:=wdDoNotSaveChanges

End Sub

Sub PrintAndCloseWord()
'
' closeword ����
' �������s�� 2008/3/3�A���s�� ccl00695
'
  Application.ActiveDocument.PrintOut Background:=False, Copies:=1
  
  Application.Quit SaveChanges:=wdDoNotSaveChanges

End Sub
