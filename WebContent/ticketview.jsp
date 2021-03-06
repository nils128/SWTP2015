<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="issuetracking.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>

<% 
DBManager DBManager1 = DBManager.getInstance();
	if (!DBManager1.checkLogin((String) request.getSession()
					.getAttribute("user"), (String) request.getSession()
					.getAttribute("password"))) {
				request.getRequestDispatcher("login.jsp").forward(request,
						response);
			}
%>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script>
window.onload = function(){
	//prepare "Type"-inputfield and display
	if('${t1.type}' == "feature"){
		setchecked('type_selection',"feature");
	    document.getElementById('estimated_time_display_span').style.display = "inline";
	    document.getElementById('estimated_time_change_span').style.display = "inline"}
	else  {document.getElementById('estimated_time_display_span').style.display = "none";
	document.getElementById('estimated_time_change_span').style.display = "none";}
	if('${t1.type}' == "bug"){
		setchecked('type_selection',"bug");;
	}
	//prepare "Responsible User"-inputfield
	setchecked('responsible_user_selection',"${t1.responsible_user}");
	//prepare "State"-inputfield
	setchecked('state_selection',"${t1.state}");
};
function showSpan(elem){
   if(elem.value == "feature")
      document.getElementById('estimated_time_change_span').style.display = "inline";
   else document.getElementById('estimated_time_change_span').style.display = "none";
}
function setchecked(selectid,valuewert)
{
  optionen=document.getElementById(selectid).options;
  for(i=0;i<optionen.length;i++)
  {
    if(optionen[i].value==valuewert)
	{
	  optionen[i].setAttribute('selected','selected');
	}
  }
}
</script>
</head>
<body>

		User:
	<a href=${'Controller?action=preparePage&pageName=userpage.jsp&user_id='.concat(sessionScope.user)}>
		${sessionScope.user}</a>
	<a href="Controller?action=logout"> logout </a>&nbsp;
	<a href="Controller?action=preparePage&pageName=sprints.jsp"> back to
		sprints </a>


	<h1>The ticket:</h1>
	ID:${t1.id}<br> 
	Title:${t1.title}<br> 
	Description:<br>
	<pre style="display:inline">${t1.description}</pre><br> 
	Date:${t1.date}<br> 
	Author:${t1.author}<br>
	Responsible User:${t1.responsible_user}<br>
	Type:${t1.type}<br> 
	State:${t1.state}<br>
	<span id="estimated_time_display_span">
	Estimated_Time:${t1.estimated_time}</span><br>
	Components: <br>
	<c:forEach items="${ticket_compids}" var="compid1">
			${compid1.compid}<br>
	</c:forEach>

	<h1>Comments:</h1>
	<c:forEach items="${ticket_comments}" var="comment1">
	        comment from:${comment1.author}  &nbsp;&nbsp;&nbsp; posted at:${comment1.dateAsString} &nbsp;&nbsp;&nbsp;${comment1.author == sessionScope.user ? '<a href="Controller?action=preparePage&pageName=commentview.jsp&comment_id='.concat(comment1.cid).concat('"> bearbeiten </a>') : ''}<br>
			${comment1.message} <br> <br>
	</c:forEach>

	<h1>New Comment</h1>
		<form action="Controller" method="post">
		<input type="hidden" name="action" value="addComment" /> 
		<input type="hidden" name="ticket_id" value="${t1.id}" />
		<input type="hidden" name="date" value="${date2}" /> 
		<input type="hidden" name="author" value="${sessionScope.user}" /> 
		Message:<br><textarea name="message" cols="65" rows="5" wrap="off" style="overflow-y: auto; overflow-x: auto;;font-size:70%"></textarea> ${errorMsgs.message}<br /> 
		<input type="submit" value="add comment">
	</form>


	<h1>Change the ticket</h1>
	<form action="Controller" method="post">
		<input type="hidden" name="ticket_id" value="${t1.id}" /> 
		<input type="hidden" name="action" value="changeTicket" /> 
		Title:<input name="title" type="text" value="${t1.title}">${errorMsgs.title}<br> 
		Description:<br>
		<textarea name="description" cols="80" rows="7" wrap="off" style="overflow-y: auto; overflow-x: auto;font-size:70%">${t1.description}</textarea> ${errorMsgs.description}<br /> 
		<input type="hidden" name="date" value="${date1}" /> ${errorMsgs.date} 
		<input type="hidden" name="author" value="${sessionScope.user}" />
		Responsible user:
		<select name="responsible_user" id="responsible_user_selection">
			<c:forEach items="${users}" var="user1">
				<option value="${user1.userid}">${user1.userid}</option>
			</c:forEach>
		</select> ${errorMsgs.responsible_user}<br /> 
		Type:
		<select name="type" onchange="showSpan(this)" id="type_selection">
			<option value="bug">bug</option>
			<option value="feature">feature</option>
		</select> ${errorMsgs.type}<br /> 
		State:
		<select name="state"  id="state_selection">
			<option value="open">open</option>
			<option value="closed">closed</option>
			<option value="in progress">in progress</option>
			<option value="test">test</option>
		</select><br> 
		<span id="estimated_time_change_span" style="display: none;">
		Estimated time:<input name="estimated_time" value="${t1.estimated_time}" type="text" />hours  ${errorMsgs.estimated_time}</span><br /> 
		Components <a href="Controller?action=preparePage&pageName=components.jsp">(addComponents)</a>:<br>
		<c:forEach items="${compids}" var="compid1">
			<input type="checkbox" name="compid" value="${compid1.compid}">${compid1.compid}
			<br>
		</c:forEach>
		<input type="submit" value="change the ticket">
	</form>

	<form action="Controller" method="post">
		<input type="hidden" name="ticket_id" value="${t1.id}" /> 
		<input type="hidden" name="action" value="deleteTicket" /> 
		<input type="submit" value="delete the ticket">
	</form>
	
<!-- development -->
<br>
<br>
<br>
<br>
<br>
<hr>

<b>Session attributes:</b><br>
<% 
for (Enumeration<String> e = session.getAttributeNames(); e.hasMoreElements(); ) {     
    String attribName = (String) e.nextElement();
    Object attribValue = session.getAttribute(attribName);
	%>
	<%= attribName %> = <%= attribValue %><br>
	<%
}
%>

<b>Parameters:</b>  <br>
<%
for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ) {     
	String attribName = e.nextElement();
	String[] attribValues = request.getParameterValues(attribName);
	String allValues="";
	for(String s:attribValues){
		allValues=allValues+" "+s;
	}
	%>
	<%=attribName%> = <%=allValues%><br />
	<%
};
%>
		
<b>Cookies (Request):</b><br>
<%
Cookie[] cookies=request.getCookies();
if(cookies!=null)
	for(Cookie c1 : cookies) {
		%>
		<%=c1.getName()%> = <%=c1.getValue()%><br />
		<%
	};
%>

</body>
</html>