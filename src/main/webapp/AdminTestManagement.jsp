<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Test Management - CoeusQuest</title>
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

        .button {
            padding: 10px 15px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #ff8800;
        }

        .back-button {
            text-align: left;
            margin-top: 10px;
        }

        .add-test-button {
            text-align: right;
            margin-bottom: 10px;
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
    <script>
        function confirmDelete() {
            return confirm("Are you sure you want to delete this test? This action cannot be undone.");
        }
    </script>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Manage Tests</h1>
        
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Test ID</th>
                        <th>Teacher Name</th>
                        <th>Date Added</th>
                        <th>Available From</th>
                        <th>Available Until</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
                        String dbUser = "root";
                        String dbPassword = "1234";
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                            String query = "SELECT * FROM testids";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                String testId = rs.getString("test_ids");
                                String teacherName = rs.getString("teacher_name");
                                String dateAdded = rs.getString("date_added");
                                String availableFrom = rs.getString("available_from");
                                String availableUntil = rs.getString("available_until");
                    %>
                    <tr>
                        <td><%= testId %></td>
                        <td><%= teacherName %></td>
                        <td><%= dateAdded %></td>
                        <td><%= availableFrom %></td>
                        <td><%= availableUntil %></td>
                        <td>
                            <a href="editTest.jsp?testId=<%= testId %>" class="button">Edit</a>
                            <a href="deleteTest.jsp?testId=<%= testId %>" class="button" style="background-color: red;" onclick="return confirmDelete();">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="button-group">
            <button class="add-test-button" onclick="location.href='addTest.jsp'"><b>Add New Test</b></button>
            <button class="back-button" onclick="window.location.href='test_table.jsp'"><b>Back</b></button>
        </div>
    </div>
    
</body>
</html>
