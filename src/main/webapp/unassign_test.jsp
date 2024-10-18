<%@ page import="java.sql.*" %>

<%
    String testId = request.getParameter("testId");
    String batch = request.getParameter("batch");
    String message = "";

    if (testId != null && batch != null) {
        String dbUrl = "jdbc:mysql://localhost:3306/usermanagement";
        String dbUser = "root";
        String dbPassword = "1234";

        Connection userManagementConn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            userManagementConn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            String selectQuery = "SELECT test_ids FROM test_assigned WHERE batch_name = ?";
            pstmt = userManagementConn.prepareStatement(selectQuery);
            pstmt.setString(1, batch);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String testIds = rs.getString("test_ids");

                if (testIds != null && !testIds.isEmpty()) {
                    String[] testArray = testIds.split(",");
                    StringBuilder newTestIds = new StringBuilder();
                    boolean removed = false;

                    for (String existingTestId : testArray) {
                        if (!existingTestId.trim().equals(testId)) {
                            if (newTestIds.length() > 0) {
                                newTestIds.append(",");
                            }
                            newTestIds.append(existingTestId.trim());
                        } else {
                            removed = true;
                        }
                    }

                    if (removed) {
                        String updateTestIdsQuery = "UPDATE test_assigned SET test_ids = ? WHERE batch_name = ?";
                        pstmt = userManagementConn.prepareStatement(updateTestIdsQuery);
                        pstmt.setString(1, newTestIds.toString());
                        pstmt.setString(2, batch);
                        int rowsAffected = pstmt.executeUpdate();

                        if (rowsAffected > 0) {
                            message = "Test unassigned successfully!";
                        } else {
                            message = "Error: Failed to update batch.";
                        }
                    } else {
                        message = "Test ID " + testId + " is not assigned to this batch.";
                    }
                } else {
                    message = "No tests assigned to this batch.";
                }
            } else {
                message = "Error: Batch not found.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error unassigning test.";
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (userManagementConn != null) try { userManagementConn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unassign Test from Batch - CoeusQuest</title>
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

        .container {
            width: 100%;
            max-width: 400px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5); /* Light glow */
            text-align: center;
            position: relative;
            transition: box-shadow 0.55s ease-in-out;
        }
        
        .container:hover {
    		box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1); /* Enhanced glow */
		}

        h1 {
            color: #ff6600;
            font-size: 36px;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        label {
            font-size: 18px;
            margin-bottom: 8px;
            color: #666;
        }

        input[type="text"] {
            padding: 15px;
            border-radius: 8px;
            border: 2px solid #ddd;
            margin-bottom: 20px;
            font-size: 16px;
        }

        input[type="text"]:focus {
            border-color: #ff6600;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 102, 0, 0.5);
        }

        input[type="submit"], .back-button button {
            background-color: #ff6600;
            color: white;
            padding: 15px;
            font-size: 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
             max-width: 200px; /* Added max-width to limit button width */
    		margin: 0 auto; /* Added margin to center the button */
        }

        input[type="submit"]:hover, .back-button button:hover {
            background-color: #ff8800;
        }

        .message {
            margin-top: 20px;
            color: #ff6600;
            font-size: 16px;
            font-weight: bold;
        }

        .back-button {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Unassign Test</h1>

        <form method="get" action="unassign_test.jsp">
            <label for="testId">Test ID</label>
            <input type="text" id="testId" name="testId" required>

            <label for="batch">Batch</label>
            <input type="text" id="batch" name="batch" required>

            <input type="submit" value="Unassign">
        </form>

        <div class="message">
            <%= message %>
        </div>

        <div class="back-button">
            <button onclick="window.location.href='assigned_test.jsp'">Back</button>
        </div>
    </div>

</body>
</html>