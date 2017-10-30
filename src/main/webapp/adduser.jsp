<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="com.group2.banking.controller.*" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%
response.setHeader( "Pragma", "no-cache" );
response.setHeader( "Cache-Control", "no-cache" );
response.setDateHeader( "Expires", 0 );
%>

<!DOCTYPE html>
<html lang="en">
<head>

<script language="javascript">

	function valueChanged1(c1) {
		if (document.myform.c1.checked)
			document.myform.Q1.style.visibility = 'visible';
		else
			document.myform.Q1.style.visibility = 'hidden';
	}

	function valueChanged2(c2) {
		if (document.myform.c2.checked)
			document.myform.Q2.style.visibility = 'visible';
		else
			document.myform.Q2.style.visibility = 'hidden';
	}

	function valueChanged3(c3) {
		if (document.myform.c3.checked)
			document.myform.Q3.style.visibility = 'visible';
		else
			document.myform.Q3.style.visibility = 'hidden';
	}

	function valueChanged4(c4) {
		if (document.myform.c4.checked)
			document.myform.Q4.style.visibility = 'visible';
		else
			document.myform.Q4.style.visibility = 'hidden';
	}

	function valueChanged5(c5) {
		if (document.myform.c5.checked)
			document.myform.Q5.style.visibility = 'visible';
		else
			document.myform.Q6.style.visibility = 'hidden';
	}

	function valueChanged6(c6) {
		if (document.myform.c6.checked)
			document.myform.Q6.style.visibility = 'visible';
		else
			document.myform.Q6.style.visibility = 'hidden';
	}

	function validate() {
		var a = document.myform.username.value;
		var b = document.myform.firstname.value;
		var c = document.myform.lastname.value;

		var d = document.myform.password.value;
		var p = document.myform.password2.value;

		var e = document.myform.Email.value;
		var f = document.myform.Address.value;
		var g = document.myform.Phone.value;

 		var q1 = document.myform.c1.checked;
		var a1 = document.myform.Q1.value;
		var q2 = document.myform.c2.checked;
		var a2 = document.myform.Q2.value;
		var q3 = document.myform.c3.checked;
		var a3 = document.myform.Q3.value;
		var q4 = document.myform.c4.checked;
		var a4 = document.myform.Q4.value;
		var q5 = document.myform.c5.checked;
		var a5 = document.myform.Q5.value;
		var q6 = document.myform.c6.checked;
		var a6 = document.myform.Q6.value;

		var passw = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
		if (!d.match(passw)) {
			alert("Password should have 6 to 20 characters in which at least one numeric digit, one uppercase and one lowercase letter");
			return false;
		}

		if (a.length > 20) {
			alert("Username can not have more than 20 characters");
			return false;
		} else if (b.length > 20) {
			alert("Firstname can not have more than 20 characters");
			return false;
		} else if (c.length > 20) {
			alert("Lastname can not have more than 20 characters");
			return false;
		} else if (p != d) {
			alert("Password and Re-entered password should be same");
			return false;
		} else if (p.length > 20) {
			alert("Password can not have more than 20 characters");
			return false;
		}
		   else if(g<0)
           {  
               alert("Phone number cannot be negative");
               return false; 
           }
		else if (e.length > 40) {
			alert("Email can not have more than 40 characters");
			return false;
			if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(e.value)))  
			  {  
				alert("You have entered an invalid email address!");
				return false;
			  }  
		} else if (f.length > 40) {
			alert("Address can not have more than  40 characters");
			return false;
		}

		else if (g.length > 12) {
			alert("Phone can not have more than 12 digits");
			return false;
		}
		
		var counter = 0;
		if (q1) {
			if (a1 == "" || a1.length == 0 || a1 == null) {
				alert("Q1 must have an answer!");
				return false;
			}
			if(a1.length>99){
				alert("Q1 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}
		if (q2) {
			if (a2 == "" || a2.length == 0 || a2 == null) {
				alert("Q2 must have an answer!");
			}
			if(a2.length>99){
				alert("Q2 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}
		if (q3) {
			if (a3 == "" || a3.length == 0 || a3 == null) {
				alert("Q3 must have an answer!");
			}
			if(a3.length>99){
				alert("Q3 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}
		if (q4) {
			if (a4 == "" || a4.length == 0 || a4 == null) {
				alert("Q4 must have an answer!");
			}
			if(a4.length>99){
				alert("Q4 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}
		if (q5) {
			if (a5 == "" || a5.length == 0 || a5 == null) {
				alert("Q5 must have an answer!");
			}
			if(a5.length>99){
				alert("Q5 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}
		if (q6) {
			if (a6 == "" || a6.length == 0 || a6 == null) {
				alert("Q6 must have an answer!");
			}
			if(a6.length>99){
				alert("Q6 cannot have more than 100 characters");
				return false;
			}
			counter++;
		}

		
		if (counter < 3) {
			alert("You have to select at least three questions");
			return false;
		}
	};
</script>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">

<title>GoSwiss</title>

<link href="/bank/resources/css/bootstrap.min.css" rel="stylesheet">
<link href="/bank/resources/css/common.css" rel="stylesheet">

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body >

	<div class="container"></div>
	<h1>
		<center>USER REGISTRATION FORM</center>
	</h1>
	<br>
	<br>
	<div class="userform">
		<form method="POST" name="myform" action="${contextPath}/adduser"
			onsubmit="return validate();" class="form-signin">
			<fieldset>
				<span>${message}</span> <span>${message1}</span>
				<h2>
					<legend>
						<strong>User information:</strong>
					</legend>
				</h2>
				<strong>First name:</strong><br> <input type="text"
					name="firstname" required> <br>
				<br> <strong>Last name:</strong><br> <input type="text"
					name="lastname" required><br>
				<br> <strong>User name:</strong><br> <input type="text"
					name="username" required><br> <br> <strong>Password:</strong><br>
				<input type="password" name="password" required><br> <br>

				<strong>Re-enter Password:</strong><br> <input type="password"
					name="password2" required><br> <br> <strong>E-mail:</strong><br>
				<input type="text" name="Email" required><br> <br>
				<strong>Address:</strong><br> <input type="text" name="Address"
					required><br> <br> <strong>Phone:</strong><br>
				<input type="number" name="Phone" required><br> <br>

				<strong>Roles:</strong><br> <select name="Role">
					<option value="4">Individual User</option>
					<option value="5">Merchant</option>




				</select> <br> <br> <strong>Type 3 Security Questions and
					Answers:</strong><br>
				<br> <input type="checkbox" name="c1" value="1"
					onchange="valueChanged1(this)"> What was your childhood nickname? <input type="text"
					name="Q1" style="visibility: hidden"><br> <br>

				<input type="checkbox" name="c2" value="2"
					onchange="valueChanged2(this)">What is the name of your favorite childhood friend? <input type="text"
					name="Q2" style="visibility: hidden"d><br> <br>

				<input type="checkbox" name="c3" value="3"
					onchange="valueChanged3(this)">What school did you attend for sixth grade? <input type="text"
					name="Q3" style="visibility: hidden"><br> <br>

				<input type="checkbox" name="c4" value="4"
					onchange="valueChanged4(this)">What was your favorite food as a child? <input type="text"
					name="Q4" style="visibility: hidden"><br> <br>

				<input type="checkbox" name="c5" value="5"
					onchange="valueChanged5(this)">What is your favorite team? <input type="text"
					name="Q5" style="visibility: hidden"><br> <br>

				<input type="checkbox" name="c6" value="6"
					onchange="valueChanged6(this)">What was the name of the hospital where you were born? <input type="text"
					name="Q6" style="visibility: hidden">


				<!--  <strong>Question 1:</strong><input type="text" name="Question1"><br>
 <strong>Answer 1:</strong><input type="text" name="Answer1"><br><br>
 <strong>Question 2:</strong><input type="text" name="Question2"><br>
 <strong>Answer 2:</strong><input type="text" name="Answer2"><br><br>
 <strong>Question 3:</strong><input type="text" name="Question3"><br>
 <strong>Answer 3:</strong><input type="text" name="Answer3"><br><br> -->


				<br> <br>
				<br>
				<button class="button">
					<b>Submit</b>
				</button>

			</fieldset>
		</form>
	</div>


</body>
</html>