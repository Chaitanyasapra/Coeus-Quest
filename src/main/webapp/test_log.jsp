<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession test_log_session = request.getSession(false);
    if (test_log_session == null || !"admin".equals(test_log_session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<String[]> logList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestBox", "root", "1234");
        stmt = con.createStatement();

        // Fetching logs from testlog table including start_time and end_time
        String logQuery = "SELECT test_ids, username, total_marks, marks_obtained, start_time, end_time FROM testlog";
        rs = stmt.executeQuery(logQuery);
        while (rs.next()) {
            String testId = rs.getString("test_ids");
            String username = rs.getString("username");
            String totalMarks = rs.getString("total_marks");
            String marksObtained = rs.getString("marks_obtained");
            String startTime = rs.getString("start_time");
            String endTime = rs.getString("end_time");
            logList.add(new String[]{testId, username, totalMarks, marksObtained, startTime, endTime});
        }

        // Sort the logList by start time and end time (latest first)
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Collections.sort(logList, new Comparator<String[]>() {
            public int compare(String[] log1, String[] log2) {
                try {
                    long startTime1 = dateFormat.parse(log1[4]).getTime();
                    long startTime2 = dateFormat.parse(log2[4]).getTime();
                    if (startTime1 != startTime2) {
                        return Long.compare(startTime2, startTime1);
                    }
                    long endTime1 = dateFormat.parse(log1[5]).getTime();
                    long endTime2 = dateFormat.parse(log2[5]).getTime();
                    return Long.compare(endTime2, endTime1);
                } catch (Exception e) {
                    e.printStackTrace();
                    return 0;
                }
            }
        });

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
    <title>Test Logs - CoeusQuest</title>
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
            width: 70%;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-height: 80vh;
            display: flex;
            flex-direction: column;
            margin-top: 80px; /* Space for the top bar */
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
            background-color: #ffffff; /* Light orange for header */
        }

        .button-group {
            margin-top: 10px;
            text-align: left;
        }

        .back-button, .add-test-button {
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
        
        .add-test-button {
            background-color: #ff6600;
        }

        .add-test-button:hover {
            background-color: #ff8800;
        }
        
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Test Logs</h1>
        
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Test ID</th>
                        <th>Username</th>
                        <th>Total Marks</th>
                        <th>Marks Obtained</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] log : logList) {
                    %>
                    <tr>
                        <td><%= log[0] %></td>
                        <td><%= log[1] %></td>
                        <td><%= log[2] %></td>
                        <td><%= log[3] %></td>
                        <td><%= log[4] %></td>
                        <td><%= log[5] %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="button-group">
            <button class="back-button" onclick="window.location.href='test_table.jsp'"><b>Back</b></button>
        </div>
    </div>
    
</body>
</html>
