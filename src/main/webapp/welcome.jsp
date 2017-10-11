<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
String driver = "com.mysql.jdbc.Driver";
String connectionUrl = "jdbc:mysql://localhost:3306/";
String database = "bank";
String userid = "root";
String password ="abhisana@1993";
try {
Class.forName(driver);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
ResultSet resultSet = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>GoSwiss</title>
  <link rel="stylesheet" type="text/css" href="IUP-1.css">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<nav class="navbar navbar-inverse" >
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">GoSwiss</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="#">Home</a></li>
      <li><a href="#">Page 1</a></li>
      <li><a href="#">Page 2</a></li>
      <li><a href="#">Page 3</a></li>
    </ul>
  </div>
</nav>
  
<div class="container">
  
</div>
<h1><center>LIST OF USERS</center></h1>
<br><br>
<h4 class="text-center"><a href="adduser.jsp"><input type="button" value="Add user" name="Add User"/></a></h4>


<table border="1">
<tr>
<td>Task</td>td>
<td>first name</td>
<td>last name</td>
<td>User name</td>
<td>Password</td>
<td>Password</td>
<td>Email</td>
<td>Address</td>
<td>Phone</td>
<td>Role</td>
<td>Edit</td>
<td>Delete</td>

</tr>
<%
try{
int count=0;
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
statement=connection.createStatement();
String sql ="select * from users ORDER BY username";
resultSet = statement.executeQuery(sql);
while(resultSet.next()){
String taskId = resultSet.getString("username");
%>

<form method="POST" action="Edituser.jsp" class="form-signin">
<tr>
<td><input type="text" style="height:45px;" id="input1" disabled size="10"  name="firstname" value= <%=taskId%> required > </td>
<td><input type="text" style="height:45px;" id="input1" disabled size="10"  name="firstname" value= <%=resultSet.getString("firstname") %> required > </td>
<td><input type="text" style="height:45px;" id="input2" disabled size="10"  name="firstname" value= <%=resultSet.getString("lastname") %> required > </td>
<td><input type="text" style="height:45px;" id="input3" disabled size="10"  name="firstname" value= <%=resultSet.getString("username") %> required > </td>
<td><input type="text" style="height:45px;" id="input4" disabled size="10" name="firstname" value= <%=resultSet.getString("password") %> required > </td>
<td><input type="text" style="height:45px;" id="input5" disabled size="10" name="firstname" value= <%=resultSet.getString("password") %> required > </td>
<td><input type="text" style="height:45px;" id="input6" disabled size="10"  name="firstname" value= <%=resultSet.getString("email") %> required > </td>
<td><input type="text" style="height:45px;" id="input7" disabled size="10"  name="firstname" value= <%=resultSet.getString("address") %> required > </td>
<td><input type="text" style="height:45px;" id="input8" disabled size="10" name="firstname" value= <%=resultSet.getString("phone") %> required > </td>
<td><input type="text" style="height:45px;" id="input8" disabled size="10" name="firstname" value= Admin required > </td>

 <td>
 <a href="Edituser.jsp"> <input type="button" class="btn btn-lg btn-primary btn-block" id="submit" onclick="getTaskId();"  value="Edit" /></a>
    <input type="hidden" id="<%=taskId%>" onclick="getTaskId();" value="<%=taskId%>" />
    </td>
      <td> <button class="btn btn-lg btn-primary btn-block" type="button">Delete</button>
    </td>
</tr>
</form>





  


<script type="text/javascript">
    function getTaskId(){
        var name;
        name = document.getElementById('<%=taskId%>').value;
    }
</script>

<% 
}
connection.close();
} catch (Exception e) {
e.printStackTrace();
}
%>
</table>

</body>
</html>