<%@ page language="java" contentType="text/html;charset=Big5"%>
<%@ page import="java.sql.*" %>
<html>
<head>
<title>test access</title>
</head>
<body bgcolor="#FFFFFF">
<h1>講師清單</h1>
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
<p>如果看到講師清單，表示已<strong>成功</strong>利用 JDBC 連到 Access 資料檔，
讀出資料。</p>
</body>
</html>
