<%@ page import="java.sql.*" %>

<%
String testId = request.getParameter("testId");
String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
String dbUser = "root";
String dbPassword = "1234";
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String teacherName = "", batch = "", availableFrom = "", availableUntil = "";
StringBuilder questionsHtml = new StringBuilder();
String updateMessage = ""; // Variable to store update message

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

    // Check if form has been submitted to update test details
    if (request.getMethod().equalsIgnoreCase("POST")) {
        if (request.getParameter("action") != null && request.getParameter("action").equals("addQuestion")) {
            // Add new question
            String questionContent = request.getParameter("questionContent");
            String questionOptions = request.getParameter("questionOptions");
            String correctOption = request.getParameter("correctOption");

            // Get the next question number
            String maxQuestionQuery = "SELECT MAX(question_number) as max_num FROM " + testId;
            stmt = conn.prepareStatement(maxQuestionQuery);
            rs = stmt.executeQuery();
            int nextQuestionNumber = 1;
            if (rs.next()) {
                nextQuestionNumber = rs.getInt("max_num") + 1;
            }

            // Insert new question
            String insertQuery = "INSERT INTO " + testId + " (question_number, question_content, question_options, correct_option) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, nextQuestionNumber);
            stmt.setString(2, questionContent);
            stmt.setString(3, questionOptions);
            stmt.setString(4, correctOption);
            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                updateMessage = "New question added successfully!";
            } else {
                updateMessage = "Failed to add new question.";
            }
        } else {
            // Update test details
            teacherName = request.getParameter("teacherName");
            batch = request.getParameter("batch");
            availableFrom = request.getParameter("availableFrom");
            availableUntil = request.getParameter("availableUntil");

            String updateQuery = "UPDATE testids SET teacher_name = ?, batch = ?, available_from = ?, available_until = ? WHERE test_ids = ?";
            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, teacherName);
            stmt.setString(2, batch);
            stmt.setString(3, availableFrom);
            stmt.setString(4, availableUntil);
            stmt.setString(5, testId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                updateMessage = "Test details updated successfully!";
            } else {
                updateMessage = "Failed to update test details.";
            }
        }
    }

    // Fetch updated test details
    String query = "SELECT * FROM testids WHERE test_ids = ?";
    stmt = conn.prepareStatement(query);
    stmt.setString(1, testId);
    rs = stmt.executeQuery();

    if (rs.next()) {
        teacherName = rs.getString("teacher_name");
        batch = rs.getString("batch");
        availableFrom = rs.getString("available_from");
        availableUntil = rs.getString("available_until");
    }

    // Fetch questions from the test-specific table
    query = "SELECT * FROM " + testId + " ORDER BY question_number";
    stmt = conn.prepareStatement(query);
    rs = stmt.executeQuery();

    while (rs.next()) {
    	int questionNumber = rs.getInt("question_number");
        String questionContent = rs.getString("question_content");
        String correctOption = rs.getString("correct_option"); // Fetch correct option

        questionsHtml.append("<tr>");
        questionsHtml.append("<td>" + questionNumber + "</td>");
        questionsHtml.append("<td>" + questionContent + "</td>");
        questionsHtml.append("<td>" + correctOption + "</td>"); // Add correct option to the table
        questionsHtml.append("<td>");
        questionsHtml.append("<a href='editQuestion.jsp?testId=" + testId + "&questionNumber=" + questionNumber + "'>Edit</a><br><br> ");
        questionsHtml.append("<a href='deleteQuestion.jsp?testId=" + testId + "&questionNumber=" + questionNumber + "' onclick='return confirm(\"Are you sure you want to delete this question?\");'>Delete</a>");
        questionsHtml.append("</td>");
        questionsHtml.append("</tr>");
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
    <title>Edit Test - CoeusQuest</title>
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
        
        a{
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
		
		.back-button:hover {
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

        .message {
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
        }

        input[type="text"],
        input[type="datetime-local"],
        textarea {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        textarea {
            resize: none;
        }

        input[type="submit"] {
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #ff8800;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 2px solid black;
        }

        th {
            background-color: white;
            font-weight: bold;
            color: #333;
        }

        td {
            background-color: white;
        }

        .back-button {
		    margin-top: 10px;
		    margin-right: 10px;
		    padding: 5px 10px; /* Adjust padding for better spacing */
		    background-color: #ff6600;
		    color: white;
		    border: none;
		    border-radius: 5px;
		    cursor: pointer;
		    font-size: 14px;
		    font-weight: bold;
		    text-decoration: none;
		    transition: background-color 0.3s;
		    line-height: normal; /* Ensure line-height is normal for proper vertical alignment */
		}

		.back-button a {
		    text-decoration: none;
		}
		
		.back-button:hover {
		    background-color: #ff8800;
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
        <h1>Edit Test: <%= testId %></h1>
        
        <% if (!updateMessage.isEmpty()) { %>
            <div class="message"><%= updateMessage %></div>
        <% } %>
        
        
		<div style="text-align: right;">
	        <button class="back-button"  style="padding: 10px;" onclick="window.location.href='AdminTestManagement.jsp'" >Back</button>		
		</div>
		
		
        <form action="editTest.jsp?testId=<%= testId %>" method="post">
            <input type="hidden" name="testId" value="<%= testId %>">

            <label>Teacher Name:</label>
            <input type="text" name="teacherName" value="<%= teacherName %>" required>

            <label>Batch:</label>
            <input type="text" name="batch" value="<%= batch %>" required>

            <label>Available From:</label>
            <input type="datetime-local" name="availableFrom" value="<%= availableFrom.replace(" ", "T") %>" required>

            <label>Available Until:</label>
            <input type="datetime-local" name="availableUntil" value="<%= availableUntil.replace(" ", "T") %>" required>

            <input type="submit" value="Update Test">
        </form>

        <h2>Questions</h2>
        <table>
            <tr>
                <th>Question Number</th>
                <th>Question Content</th>
                <th>Correct Option</th>
                <th>Action</th>
            </tr>
            <%= questionsHtml.toString() %>
        </table>

        <h2>Add New Question</h2>
        <form action="editTest.jsp?testId=<%= testId %>" method="post">
            <input type="hidden" name="action" value="addQuestion">
            <input type="hidden" name="testId" value="<%= testId %>">

            <label>Question Content:</label>
            <textarea name="questionContent" rows="4" required></textarea>

            <label>Question Options (comma-separated):</label>
            <input type="text" name="questionOptions" value="A) , B) , C) , D)" required>

            <label>Correct Option:</label>
            <input type="text" name="correctOption" required>

            <input type="submit" value="Add Question">
        </form>

    </div>
</body>
</html>
