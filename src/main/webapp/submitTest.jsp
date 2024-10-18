<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %>

<%
    String testId = request.getParameter("testId");
    HttpSession T_session = request.getSession();
    String username = (String) T_session.getAttribute("username");  // Assuming username is stored in the session

    if (testId == null || testId.isEmpty()) {
        out.println("<h2>No test selected. Please go back and choose a test.</h2>");
        return;
    }

    // Get start time from session
    java.util.Date startTime = (java.util.Date) T_session.getAttribute("startTime");
    java.util.Date endTime = new java.util.Date(); // Capture end time when test is submitted

    Map<Integer, String> userAnswers = (Map<Integer, String>) T_session.getAttribute("userAnswers");

    if (userAnswers == null) {
        userAnswers = new HashMap<>();
    }
    
    T_session.removeAttribute("markedQuestions");
    
    String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
    String dbUser = "root";
    String dbPassword = "1234";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int totalQuestions = 0;
    int correctAnswers = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Fetch all questions and correct answers for the test
        String query = "SELECT question_number, correct_option FROM " + testId;
        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        while (rs.next()) {
            int questionNumber = rs.getInt("question_number");
            String correctOption = rs.getString("correct_option");

            totalQuestions++;  // Increment total questions

            String userAnswer = userAnswers.get(questionNumber - 1);  // Get the user's answer

            if (userAnswer != null && userAnswer.equals(correctOption)) {
                correctAnswers++;  // Increment correct answers
            }
        }

        // Calculate the score percentage
        int score = (totalQuestions > 0) ? (int) ((double) correctAnswers / totalQuestions * 100) : 0;

        // Insert test log into `testlog` table with total_marks and marks_obtained
        String logQuery = "INSERT INTO testlog (test_ids, username, start_time, end_time, total_marks, marks_obtained) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement logStmt = conn.prepareStatement(logQuery);
        logStmt.setString(1, testId);
        logStmt.setString(2, username);
        logStmt.setTimestamp(3, new java.sql.Timestamp(startTime.getTime()));
        logStmt.setTimestamp(4, new java.sql.Timestamp(endTime.getTime()));
        logStmt.setInt(5, totalQuestions);  // Total marks equal to total number of questions
        logStmt.setInt(6, correctAnswers);  // Marks obtained is the number of correct answers

        logStmt.executeUpdate();

        // Clear session data after test submission
        T_session.removeAttribute("userAnswers");
        T_session.removeAttribute("startTime");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Results - CoeusQuest</title>
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

        .result-box {
            width: 100%;
            max-width: 400px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5); /* Light glow */
            text-align: center;
            position: relative;
            transition: box-shadow 0.55s ease-in-out; /* Slower transition for glow */
        }

        .result-box:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1); /* Brighter glow on hover */
        }

        h1 {
            color: #ff6600;
            font-size: 36px;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .back-button {
            display: inline-block;
            width: 100%;
            padding: 15px;
            background-color: #ff6600;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s;
            font-weight: bold;
            font-style: italic;
        }

        .back-button:hover {
            background-color: #ff8800;
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

    </style>
</head>
<body>

    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <!-- Test Results Section -->
    <div class="result-box">
        <h1>Test Results</h1>
        <p>Total Questions: <%= totalQuestions %></p>
        <p>Correct Answers: <%= correctAnswers %></p>
        <p>Your Score: <%= score %>%</p>

        <a href="user.jsp" class="back-button">Back to Dashboard</a>
    </div>

</body>
</html>


<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error processing the test.</h2>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
