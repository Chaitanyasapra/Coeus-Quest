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
    List<String[]> testList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestBox", "root", "1234");
        stmt = con.createStatement();
        
        // Fetching tests from testids table in TestBox database
        String testQuery = "SELECT * FROM testids";
        rs = stmt.executeQuery(testQuery);
        while (rs.next()) {
            String testId = rs.getString("test_ids");
            String teacherName = rs.getString("teacher_name");
            String batch = rs.getString("batch");
            String dateAdded = rs.getString("date_added");
            String availableFrom = rs.getString("available_from");
            String availableUntil = rs.getString("available_until");
            testList.add(new String[]{testId, teacherName, batch, dateAdded, availableFrom, availableUntil});
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
    <title>Test Table - CoeusQuest</title>
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

        .container {
            width: 90%;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-height: 80vh;
            display: flex;
            flex-direction: column;
            margin-top: 80px; /* Space for the top bar */
            overflow-y: auto;
        }

        h1 {
            text-align: center;
            color: #ff6600;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .table-wrapper {
            overflow-y: auto;
            max-height: 50vh;
            margin-top: 20px;
            border-radius: 8px;
            background-color: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 10px;
        }

        /* Custom scrollbar */
        .table-wrapper::-webkit-scrollbar {
            width: 10px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background-color: #ff6600;
            border-radius: 0;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background-color: white;
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

        .button-group {
            margin-top: 10px;
            text-align: left;
        }

        .start-button, .back-button, .assigned-test-button, .manage-test-button, .view-log-button, .assign-button {
            padding: 10px 20px;
            background-color: #ff6600;
            color: white;
            font-weight: bold;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px 5px;
            transition: background-color 0.3s ease;
            display: inline-block;
            text-align: center;
            border: none;
            cursor: pointer;
        }

        .start-button:hover, .back-button:hover, .assigned-test-button:hover, .manage-test-button:hover, .view-log-button:hover, .assign-button:hover {
            background-color: #ff8800;
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Test List</h1>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Test ID</th>
                        <th>Teacher Name</th>
                        <th>Date Added</th>
                        <th>Available From</th>
                        <th>Available Until</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] test : testList) {
                    %>
                    <tr>
                        <td><%= test[0] %></td>
                        <td><%= test[1] %></td>
                        <td><%= test[3] %></td>
                        <td><%= test[4] %></td>
                        <td><%= test[5] %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="button-group">
            <button class="assigned-test-button" onclick="location.href='assigned_test.jsp'"><b>Assigned Test</b></button>
            <button class="manage-test-button" onclick="location.href='AdminTestManagement.jsp'"><b>Manage Tests</b></button>
            <button class="view-log-button" onclick="location.href='test_log.jsp'"><b>View Logs</b></button>
            <button class="assign-button" onclick="location.href='assign.jsp'"><b>Assign</b></button>
            <button class="back-button" onclick="location.href='admin.jsp'"><b>Back</b></button>
        </div>
    </div>
</body>
</html>

