<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    if (username != null && !username.isEmpty()) {
        username = username.substring(0, 1).toUpperCase() + username.substring(1); // Capitalize first letter
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CoeusQuest</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="icon" href="favi.ico" type="image/x-icon">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #ffffff;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            padding-top: 80px; /* Ensures content starts below the top bar */
        }

        .container {
            width: 100%;
            max-width: 400px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5); /* Light glow */
            text-align: center;
            position: relative;
            transition: box-shadow 0.55s ease-in-out; /* Slower transition for glow */
        }

        .container:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1); /* Brighter glow on hover */
        }

        h1 {
            color: #ff6600;
            font-size: 36px;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            color: #333;
            margin-bottom: 30px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
            margin-bottom: 20px;
            transition: background-color 0.3s;
            font-weight: bold;
        }

        button:hover {
            background-color: #ff8800;
        }

        /* Top Bar */
        .top-bar {
            position: fixed;
            top: 0;
            width: 100%;
            height: 60px;
            background: linear-gradient(to right, #ff6600, #ffcc33);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }

        .top-bar h3 {
            color: #fff;
            font-size: 20px;
            font-weight: 700;
        }

        .top-bar nav {
            display: flex;
        }

        .top-bar nav a {
            color: #fff;
            margin-left: 20px;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
        }

        .top-bar nav a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <!-- Admin Dashboard -->
    <div class="container">
        <h1>Welcome <%= username != null ? username : "Admin" %></h1>
        <p><b><i>You have successfully logged in as an admin.</i></b></p>

        <form action="user_table.jsp" method="get">
            <button type="submit"><b>Manage Users</b></button>
        </form>

        <form action="test_table.jsp" method="get">
            <button type="submit"><b>Manage Tests</b></button>
        </form>

        <form action="logout.jsp" method="get">
            <button type="submit"><b>Logout</b></button>
        </form>
    </div>

</body>
</html>
