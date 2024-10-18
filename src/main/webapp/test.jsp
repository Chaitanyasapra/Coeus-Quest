<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %>

<%
    String testId = request.getParameter("testId");
    String currentIndexParam = request.getParameter("currentIndex");
    String action = request.getParameter("action");

    int currentIndex = (currentIndexParam != null) ? Integer.parseInt(currentIndexParam) : 0;

    if (testId == null || testId.isEmpty()) {
        out.println("<h2>No test selected. Please go back and choose a test.</h2>");
        return;
    }

    HttpSession T_session = request.getSession();
    
    if (T_session.getAttribute("startTime") == null) {
        T_session.setAttribute("startTime", new java.util.Date());
    }

    String newAttempt = request.getParameter("newAttempt");
    if ("true".equals(newAttempt)) {
        T_session.removeAttribute("userAnswers");
        T_session.removeAttribute("markedQuestions");
    }

    Map<Integer, String> userAnswers = (Map<Integer, String>) T_session.getAttribute("userAnswers");
    if (userAnswers == null) {
        userAnswers = new HashMap<>();
    }

    String selectedAnswer = request.getParameter("q" + currentIndex);
    if (selectedAnswer != null) {
        userAnswers.put(currentIndex, selectedAnswer);
        T_session.setAttribute("userAnswers", userAnswers);
    }
	
    
    Set<Integer> markedQuestions = (Set<Integer>) T_session.getAttribute("markedQuestions");
    if (markedQuestions == null) {
        markedQuestions = new HashSet<>();
    }

    // Handle "Mark for review" action
    if ("Mark for review".equals(action)) {
        markedQuestions.add(currentIndex);
        T_session.setAttribute("markedQuestions", markedQuestions);
    }

    if ("Unmark".equals(action)) {
        markedQuestions.remove(currentIndex);
        T_session.setAttribute("markedQuestions", markedQuestions);
    }
    
    String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
    String dbUser = "root";
    String dbPassword = "1234";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        String query = "SELECT question_number, question_content, question_options FROM " + testId + " ORDER BY question_number";
        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        List<String[]> questions = new ArrayList<>();
        while (rs.next()) {
            String[] question = new String[3];
            question[0] = rs.getString("question_number");
            question[1] = rs.getString("question_content");
            question[2] = rs.getString("question_options");
            questions.add(question);
        }

        if (questions.isEmpty()) {
            out.println("<h2>No questions found for the selected test.</h2>");
        } else {
            if ("next".equals(action) && currentIndex < questions.size() - 1) {
                currentIndex++;
            } else if ("previous".equals(action) && currentIndex > 0) {
                currentIndex--;
            }

            String[] currentQuestion = questions.get(currentIndex);
            String questionNumber = currentQuestion[0];
            String questionContent = currentQuestion[1];
            String questionOptions = currentQuestion[2];
%>

<!DOCTYPE html>
<html>
<head>
    <title>Test: <%= testId %></title>
    <link rel="icon" href="favi.ico" type="image/x-icon">
    <style>
        body {
            font-family: Arial, sans-serif;
            overflow: hidden;
            margin: 0;
            padding: 0;
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
            display: block;
        }
        .top-bar nav {
            display: flex;
        }
        .main-content {
            display: flex;
            height: calc(100vh - 60px); /* Full height minus top bar */
            padding-top: 60px; /* Adjust padding for top bar */
            margin-left: 60px;
        }
        .question-side, .options-side {
            flex: 1; /* Equal width for both sides */
            display: flex;
            flex-direction: column;
        }
        .question-side {
            background-color: #ffffff;
            padding: 20px;
        }
        .options-side {
            background-color: #f5f5f5;
            padding: 20px;
        }
        .options label {
            display: block;
            margin-bottom: 10px;
            cursor: pointer;
        }
        .navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .save-button {
            margin-top: 20px;
            background-color: #ff6600;
            padding: 10px 10px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }
        .save-button:hover {
            background-color: #ff8800;
        }
        
        .nav-button {
            margin-top: 10px;
            background-color: #ff6600;
            padding: 10px 10px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }
        .nav-button:hover {
            background-color: #ff8800;
        }
        
        
        .submit-btn {
            background-color: #ff6600;
            padding: 10px 20px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            margin-right: 100px;
            border: none;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #ff8800;
        }
        hr.vertical {
            border-left: 1px solid black;
            height: 100%;
            position: absolute;
            left: 50%;
            margin-left: -1px;
        }
        .sidebar {
            position: fixed;
            top: 60px;
            left: 0;
            width: 60px;
            height: calc(100vh - 60px);
            overflow-y: scroll;
            
            border-right: 2px solid black;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar::-webkit-scrollbar {
            width: 10px;
            display: none;
            
        }

        .sidebar::-webkit-scrollbar-thumb {
            background-color: black;
            min-height: 5px;
            max-height: 10px;
            border-radius: 0;
        }

        .sidebar::-webkit-scrollbar-track {
            background-color: white;
        }
        .sidebar a {
            display: block;
            padding: 10px;
            text-align: center;
            color: #000;
            text-decoration: none;
            border-bottom: 2px solid black;
            font-weight: bold;
            
        }
        .sidebar a.active {
            background-color: #ff6600;
            color: #fff;
        }
        .sidebar a.marked {
		    background-color: purple;
		    color: white;
		}
        
    </style>
</head>
<body>

    <!-- Top bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
        <nav>
            <form action="submitTest.jsp" method="post" onsubmit="return confirmSubmit();">
                <input type="hidden" name="testId" value="<%= testId %>">
                <button type="submit" class="submit-btn">Submit Test</button>
            </form>
        </nav>
    </div>
	
	<div class="sidebar" id="questionSidebar">
	    <% for (int i = 0; i < questions.size(); i++) { 
	        String linkClass = "";
	        if (i == currentIndex) {
	            linkClass += "active ";
	        }
	        if (markedQuestions.contains(i)) {
	            linkClass += "marked";
	        }
	    %>
	    <a href="test.jsp?testId=<%= testId %>&currentIndex=<%= i %>" class="<%= linkClass.trim() %>">
	        <%= i + 1 %>
	    </a>
	    <% } %>
	</div>
	
	
    <!-- Main content area -->
    <div class="main-content">
        <!-- Left side for the question -->
        <div class="question-side">
            <h2>Question <%= questionNumber %></h2>
            <p><%= questionContent %></p>
        </div>

        <!-- Right side for the options -->
        <div class="options-side">
            <form action="test.jsp" method="post">
                <input type="hidden" name="testId" value="<%= testId %>">
                <input type="hidden" name="currentIndex" value="<%= currentIndex %>">
                <div class="options">
                    <%
                        String[] options = questionOptions.split(",");
                        // Get the previously selected answer for the current question
                        String previouslySelectedAnswer = userAnswers.get(currentIndex);
                        for (int i = 0; i < options.length; i++) {
                            String option = options[i].trim();
                            char optionChar = (char) ('A' + i);
                    %>
                        <label>
                            <input type="radio" name="q<%= currentIndex %>" value="<%= optionChar %>"
                                <%= (previouslySelectedAnswer != null && previouslySelectedAnswer.equals(String.valueOf(optionChar))) ? "checked" : "" %> >
                            <%= option %>
                        </label>
                    <%
                        }
                    %>
                </div>
                <button type="submit" class="save-button">Save Answer</button>
                
                <button class="nav-button" type="submit" name="action" value="<%= markedQuestions.contains(currentIndex) ? "Unmark" : "Mark for review" %>">
				    <%= markedQuestions.contains(currentIndex) ? "Unmark" : "Mark" %>
				</button>
				
            </form>
            <div class="navigation">
                <form action="test.jsp" method="post">
				    <input type="hidden" name="testId" value="<%= testId %>">
				    <input type="hidden" name="currentIndex" value="<%= currentIndex %>">
				    <button class="nav-button" type="submit" name="action" value="previous" <%= (currentIndex == 0) ? "disabled" : "" %>>Last Question</button>
				    <button class="nav-button" type="submit" name="action" value="next" <%= (currentIndex == questions.size() - 1) ? "disabled" : "" %>>Next Question</button>
				    
				</form>
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
   
    	function confirmSubmit() {
            return confirm("Are you sure you want to submit the test?");
        }
        
        function scrollSidebarToCurrentQuestion() {
            var sidebar = document.getElementById('questionSidebar');
            var activeQuestion = sidebar.querySelector('.active');
            
            if (activeQuestion) {
                var sidebarRect = sidebar.getBoundingClientRect();
                var activeRect = activeQuestion.getBoundingClientRect();
                
                if (activeRect.top < sidebarRect.top || activeRect.bottom > sidebarRect.bottom) {
                    sidebar.scrollTop = activeQuestion.offsetTop - sidebar.offsetTop - (sidebar.clientHeight / 2) + (activeQuestion.clientHeight / 2);
                }
            }
        }

        // Call this function when the page loads
        window.onload = scrollSidebarToCurrentQuestion;

    </script>
</body>
</html>

<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error retrieving questions.</h2>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
