<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<String[]> adminList = new ArrayList<>();
    List<String[]> userList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/usermanagement", "root", "1234");
        stmt = con.createStatement();
        
        // Fetching admins
        String adminQuery = "SELECT * FROM users WHERE role = 'admin'";
        rs = stmt.executeQuery(adminQuery);
        while (rs.next()) {
            String id = rs.getString("id");
            String usernameDb = rs.getString("username");
            String password = rs.getString("password");
            String role = rs.getString("role");
            adminList.add(new String[]{id, usernameDb, password, role});
        }

        // Fetching normal users
        String userQuery = "SELECT * FROM users WHERE role = 'user'";
        rs = stmt.executeQuery(userQuery);
        while (rs.next()) {
            String id = rs.getString("id");
            String usernameDb = rs.getString("username");
            String password = rs.getString("password");
            String role = rs.getString("role");
            String batch = rs.getString("batch"); // Fetching batch
            userList.add(new String[]{id, usernameDb, password, role, batch}); // Adding batch to user list
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        if (con != null) try { con.close(); } catch (SQLException ignored) {}
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Table - CoeusQuest</title>
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
            flex-direction: column;
            justify-content: flex-start; /* Align items at the start */
            position: relative; /* For button positioning */
        }
        
        .container::-webkit-scrollbar {
            width: 10px;
        }

        .container::-webkit-scrollbar-thumb {
            background-color: #ff6600;
            border-radius: 0;
        }

        .container::-webkit-scrollbar-track {
            background-color: white;
        }
        
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

        .button-group {
            margin: 70px 30px 20px; /* Adjusted left margin to 30px for a slight shift to the right */
            display: flex; /* Use flexbox to align buttons in a line */
            justify-content: center; /* Center the buttons */
            gap: 10px; /* Space between buttons */
        }

        .container {
            width: 90%; /* Set container width to 90% */
            padding: 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            overflow-y: auto; /* Enable vertical scrolling */
            height: calc(100vh - 160px); /* Height for container to avoid scrolling */
            margin: 0 auto; /* Center the container */
        }

        h1 {
            text-align: center;
            color: #ff6600;
            font-weight: bold;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-color: black;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 2px solid; /*#fff;*/
            padding: 10px;
            text-align: center;
            font-weight: bold;
            color: black;
        }

        th {
            background-color: #ffffff; /* Light orange for header */
        }

        .button {
            padding: 10px 20px;
            background-color: #ff6600;
            color: white;
            font-weight: bold;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .button:hover {
            background-color: #ff8800;
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="button-group">
        <button class="button" onclick="location.href='add_user.jsp'"><b>Add User</b></button> <!-- Add User button -->
        <button class="button" onclick="location.href='delete_user.jsp'"><b>Delete User</b></button> <!-- Delete User button -->
        <button class="button" onclick="location.href='managebatch.jsp'"><b>Manage Batches</b></button> <!-- Manage button -->
        <button class="button" onclick="location.href='admin.jsp'"><b>Back</b></button> <!-- Back button positioned here -->
    </div>

    <div class="container">
        <h1>Admins List</h1>
        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Password</th>
                <th>Role</th>
            </tr>
            <%
                for (String[] admin : adminList) {
            %>
                <tr>
                    <td><%= admin[0] %></td>
                    <td><%= admin[1] %></td>
                    <td><%= admin[2] %></td>
                    <td><%= admin[3] %></td>
                </tr>
            <%
                }
            %>
        </table>
		
		<br>
		
        <h1>Users List</h1>
        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Batch</th>
                <th>Role</th>
                <th>Password</th>
            </tr>
            <%
                for (String[] user : userList) {
            %>
                <tr>
                    <td><%= user[0] %></td>
                    <td><%= user[1] %></td>
                    <td><%= user[4] %></td>
                    <td><%= user[3] %></td>
                    <td><%= user[2] %></td>
                </tr>
            <%
                }
            %>
        </table>
    </div>
</body>
</html>
