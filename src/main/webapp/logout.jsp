<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // Prevent caching of this page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // HttpSession session = request.getSession(false);
    if (session != null) {
        session.invalidate(); // Invalidate the session to log out the user
    }
    response.sendRedirect("login.jsp"); // Redirect to the login page
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <link rel="icon" href="favi.ico" type="image/x-icon">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url("background.jpg");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            height: 100vh;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }
    </style>
</head>
<body>
    <h1>You have been logged out.</h1>
    <p>Redirecting to the login page...</p>
</body>
</html>
