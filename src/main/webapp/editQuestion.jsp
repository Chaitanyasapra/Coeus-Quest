<%@ page import="java.sql.*" %>

<%
String testId = request.getParameter("testId");
int questionNumber = Integer.parseInt(request.getParameter("questionNumber"));
String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
String dbUser = "root";
String dbPassword = "1234";
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String questionContent = "";
String questionOptions = "";
String correctOption = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

    String query = "SELECT * FROM " + testId + " WHERE question_number = ?";
    stmt = conn.prepareStatement(query);
    stmt.setInt(1, questionNumber);
    rs = stmt.executeQuery();

    if (rs.next()) {
        questionContent = rs.getString("question_content");
        questionOptions = rs.getString("question_options");
        correctOption = rs.getString("correct_option");
    }
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
    <title>Edit Question - CoeusQuest</title>
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

        a {
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

        a:hover {
            background-color: #ff8800;
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
            margin-top: 80px; /* Space for the top bar */
            overflow-y: auto; /* Enables scrolling */
        }

        h1 {
            text-align: center;
            color: #ff6600;
            font-weight: bold;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
        }

        textarea,
        input[type="text"] {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        textarea {
            resize: none;
        }

        button {
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #ff8800;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-align: right;
        }

        .back-link a {
            padding: 10px;
        }

        /* Custom scrollbar styles */
        .container::-webkit-scrollbar {
            width: 10px;
        }

        .container::-webkit-scrollbar-thumb {
            background-color: #ff6600;
            border-radius: 5px;
        }

        .container::-webkit-scrollbar-track {
            background-color: white;
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Edit Question <%= questionNumber %> for Test <%= testId %></h1>

        <form action="editQuestionProcess.jsp" method="post">
            <input type="hidden" name="testId" value="<%= testId %>">
            <input type="hidden" name="questionNumber" value="<%= questionNumber %>">

            <label>Question Content:</label>
            <textarea name="questionContent" rows="4" required><%= questionContent %></textarea>

            <label>Question Options (comma separated):</label>
            <input type="text" name="questionOptions" value="<%= questionOptions %>" required>

            <label>Correct Option (A, B, C, or D):</label>
            <input type="text" name="correctOption" value="<%= correctOption %>" maxlength="1" required>

            <button type="submit">Update Question</button>
        </form>

        <div class="back-link">
            <button onclick="window.history.back()">Back</button> 
        </div>
    </div>
</body>
</html>
