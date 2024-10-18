<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        
        String batch = request.getParameter("batch");

        if (batch != null) {
            Connection con = null;
            PreparedStatement ps = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/usermanagement", "root", "1234");

                
                String query = "DELETE FROM test_assigned WHERE batch_name = ?;";
                ps = con.prepareStatement(query);
                ps.setString(1, batch);

                int updateCount = ps.executeUpdate();
                if (updateCount > 0) {
                    message = "Batch deleted successfully.";
                } else {
                    message = "Failed to delete batch.";
                }
            } catch (Exception e) {
                message = "Error occurred: " + e.getMessage();
            } finally {
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (con != null) try { con.close(); } catch (SQLException ignored) {}
            }
        } else {
            message = "Batch name are required.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Batch</title>
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
            margin: 0;
            flex-direction: column;
            overflow: hidden; /* Hide scroll bar */
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
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5);
            text-align: center;
            transition: box-shadow 0.55s ease-in-out;
        }

        .container:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1);
        }

        h1 {
            color: #ff6600;
            font-size: 24px;
            margin-bottom: 10px;
        }

        label {
            font-size: 14px;
            color: #666;
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 2px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.5);
            color: black;
        }

        input[type="text"]:focus {
            border-color: #ff6600;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 102, 0, 0.5);
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #ff8800;
        }

        .message {
            margin-top: 10px;
            color: #ff6600;
            font-size: 14px;
            font-weight: bold;
        }

        .back-button {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Delete Batch</h1>
        <form method="post">
            <label for="batch"><b>Batch</b></label>
            <input type="text" name="batch" placeholder="Enter Batch name" required>
            
            <button type="submit">Delete</button>
        </form>
        <p class="message"><%= message %></p>
        <button class="back-button" onclick="location.href='managebatch.jsp'">Back</button>
    </div>
</body>
</html>
