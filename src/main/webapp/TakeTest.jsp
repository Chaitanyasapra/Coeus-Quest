<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String capitalizedUsername = username.substring(0, 1).toUpperCase() + username.substring(1);

    String dbUrlUser = "jdbc:mysql://localhost:3306/usermanagement";
    String dbUrlTestBox = "jdbc:mysql://localhost:3306/TestBox";
    String dbUser = "root";
    String dbPassword = "1234";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String userBatch = "";
    String testIds = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrlUser, dbUser, dbPassword);

        // Get the batch of the user
        String getBatchSQL = "SELECT Batch FROM users WHERE username = ?";
        stmt = conn.prepareStatement(getBatchSQL);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (rs.next()) {
            userBatch = rs.getString("Batch");
        }

        rs.close();

        // Get the tests assigned to the batch
        String getTestsSQL = "SELECT test_ids FROM test_assigned WHERE batch_name = ?";
        stmt = conn.prepareStatement(getTestsSQL);
        stmt.setString(1, userBatch);
        rs = stmt.executeQuery();

        if (rs.next()) {
            testIds = rs.getString("test_ids");
        }

        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Tests - CoeusQuest</title>
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
            border: 2px solid; /*#fff;*/
            padding: 10px;
            text-align: center;
            font-weight: bold;
            color: black;
        }

        th {
            background-color: #ffffff; /* Light orange for header */
        }

        .start-button, .back-button {
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

        .start-button:hover, .back-button:hover {
            background-color: #ff8800;
        }

        /* Modal Styles */
        .modal {
            display: none; /* Hidden by default */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }

        .modal-buttons {
            display: flex;
            justify-content: space-around;
        }
    </style>
    <script>
        function checkAvailability(testId, availableUntil) {
            var currentDate = new Date();
            var testEndDate = new Date(availableUntil);
            
            if (currentDate > testEndDate) {
                alert("This test is no longer available.");
                location.reload(); // Reload the page
            } else {
                showModal(testId);
            }
        }

        function showModal(testId) {
            document.getElementById('modal').style.display = 'block';
            document.getElementById('confirmStartButton').onclick = function() {
                window.location.href = "test.jsp?testId=" + testId;
            }
        }

        function closeModal() {
            document.getElementById('modal').style.display = 'none';
        }
    </script>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Tests Assigned To Your Batch</h1>

        <%
            if (testIds != null && !testIds.trim().isEmpty()) {
                String[] testsArray = testIds.split(",");
                Arrays.sort(testsArray);
                Connection connTestBox = null;
                PreparedStatement stmtTestBox = null;
                ResultSet rsTestBox = null;

                try {
                    connTestBox = DriverManager.getConnection(dbUrlTestBox, dbUser, dbPassword);
                    String getTestDetailsSQL = "SELECT * FROM testids WHERE test_ids = ?";
                    stmtTestBox = connTestBox.prepareStatement(getTestDetailsSQL);
        %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Test ID</th>
                                <th>Teacher Name</th>
                                <th>Available From</th>
                                <th>Available Until</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (String testId : testsArray) {
                                    stmtTestBox.setString(1, testId.trim());
                                    rsTestBox = stmtTestBox.executeQuery();
                                    if (rsTestBox.next()) {
                                        String teacherName = rsTestBox.getString("teacher_name");
                                        String availableFrom = rsTestBox.getString("available_from");
                                        String availableUntil = rsTestBox.getString("available_until");
                            %>
                            <tr>
                                <td><%= testId.trim() %></td>
                                <td><%= teacherName %></td>
                                <td><%= availableFrom %></td>
                                <td><%= availableUntil %></td>
                                <td><button class="start-button" onclick="checkAvailability('<%= testId.trim() %>', '<%= availableUntil %>')">Start</button></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rsTestBox != null) try { rsTestBox.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmtTestBox != null) try { stmtTestBox.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (connTestBox != null) try { connTestBox.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            } else {
        %>
            <p>No tests assigned to your batch.</p>
        <%
            }
        %>

        <div style="text-align: left; margin-top: 10px;">
       		<button class="back-button" onclick="window.history.back();">Back</button>
    	</div>
    </div>

    <!-- Modal -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Start Test</h2>
            </div>
            <p style="text-align: center;">Are you sure you want to start this test?</p>
            <div class="modal-buttons">
                <button id="confirmStartButton" class="start-button">Yes</button>
                <button class="back-button" onclick="closeModal()">No</button>
            </div>
        </div>
    </div>
</body>
</html>
