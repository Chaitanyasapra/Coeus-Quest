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
    List<String[]> assignedTestList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/usermanagement", "root", "1234");
        stmt = con.createStatement();
        
        // Fetching assigned tests from test_assigned table in usermanagement database
        String testQuery = "SELECT batch_name, test_ids FROM test_assigned";
        rs = stmt.executeQuery(testQuery);
        while (rs.next()) {
            String batchName = rs.getString("batch_name");
            String testIds = rs.getString("test_ids");
            assignedTestList.add(new String[]{batchName, testIds});
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
    <title>Assigned Test List - CoeusQuest</title>
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
            border: 2px solid;
            padding: 10px;
            text-align: center;
            font-weight: bold;
            color: black;
        }

        th {
            background-color: #ffffff;
        }

        .button-group {
        margin-top: 10px;
        text-align: left;
    }

    .back-button, .unassign-button {
        padding: 10px 20px;
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

    .back-button {
        background-color: #ff6600;
    }

    .back-button:hover {
        background-color: #ff8800;
    }

    .unassign-button {
        background-color: #ff6600;
    }

    .unassign-button:hover {
        background-color: #ff8800;
    }
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Assigned Test List</h1>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Batch Name</th>
                        <th>Test IDs</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] test : assignedTestList) {
                    %>
                    <tr>
                        <td><%= test[0] %></td>
                        <td><%= test[1] %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="button-group">
		    <button class="unassign-button" onclick="location.href='unassign_test.jsp'"><b>Unassign</b></button>
		    <button class="back-button" onclick="window.location.href='test_table.jsp'"><b>Back</b></button>
		</div>
    </div>
</body>
</html>
