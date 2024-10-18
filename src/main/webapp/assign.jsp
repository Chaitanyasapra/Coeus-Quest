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
                    boolean alreadyAssigned = false;

                    for (String existingTestId : testArray) {
                        if (existingTestId.trim().equals(testId)) {
                            alreadyAssigned = true;
                            break;
                        }
                    }

                    if (alreadyAssigned) {
                        message = "Test ID " + testId + " is already assigned to this batch.";
                    } else {
                        testIds += "," + testId;
                    }
                } else {
                    testIds = testId;
                }

                if (!message.contains("already assigned")) {
                    String updateTestIdsQuery = "UPDATE test_assigned SET test_ids = ? WHERE batch_name = ?";
                    pstmt = userManagementConn.prepareStatement(updateTestIdsQuery);
                    pstmt.setString(1, testIds);
                    pstmt.setString(2, batch);
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        message = "Test assigned successfully!";
                    } else {
                        message = "Error: Batch not found.";
                    }
                }
            } else {
                message = "Error: Batch not found.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error assigning test.";
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
    <title>Assign Test to Batch - CoeusQuest</title>
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
            padding: 15px 20px; /* Added padding to the left and right for a consistent look */
            font-size: 18px;
            border: none;
            border-radius: 5px; /* Rounded button */
            cursor: pointer;
            transition: background-color 0.3s;
            max-width: 200px; /* Set a max-width for the buttons */
            margin: 0 auto; /* Center the button */
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

    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Assign Test</h1>

        <form method="get" action="assign.jsp">
            <label for="testId">Test ID</label>
            <input type="text" id="testId" name="testId" required>

            <label for="batch">Batch</label>
            <input type="text" id="batch" name="batch" required>

            <input type="submit" value="Assign">
        </form>

        <div class="message">
            <%= message %>
        </div>

        <div class="back-button">
            <button onclick="window.location.href='test_table.jsp'">Back</button>
        </div>
    </div>

</body>
</html>