<%@ page language="java" contentType="text/html;charset=Big5"%>
<%@ page import="java.sql.*" %>
<html>
<head>
<title>test access</title>
</head>
<body bgcolor="#FFFFFF">
<h1>���v�M��</h1>
<table border="1">
<%
Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
String str="jdbc:odbc:DRIVER=Microsoft Access Driver (*.mdb);DBQ=c:/test.mdb"; 
Connection con=DriverManager.getConnection(str,"","");
String sql =  "select * from instructor";
PreparedStatement SQL=con.prepareStatement(sql);
ResultSet rs=SQL.executeQuery();
while(rs.next()) {
%>
<tr>
<td><%=rs.getString("id")%></td>
<td><%=rs.getString("name")%></td>
</tr>
<%
}
con.close();
%>
</table>
<p>�p�G�ݨ����v�M��A��ܤw<strong>���\</strong>�Q�� JDBC �s�� Access ����ɡA
Ū�X��ơC</p>
</body>
</html>
