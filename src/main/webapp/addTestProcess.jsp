<%@ page import="java.sql.*" %>

<%
    String testId = request.getParameter("testId");
    String teacherName = request.getParameter("teacherName");
    String batch = request.getParameter("batch");
    String availableFrom = request.getParameter("availableFrom");
    String availableUntil = request.getParameter("availableUntil");

    String[] questionContent = request.getParameterValues("questionContent[]");
    String[] optionA = request.getParameterValues("optionA[]");
    String[] optionB = request.getParameterValues("optionB[]");
    String[] optionC = request.getParameterValues("optionC[]");
    String[] optionD = request.getParameterValues("optionD[]");
    String[] correctOption = request.getParameterValues("correctOption[]");

    String testBoxDbUrl = "jdbc:mysql://localhost:3306/TestBox";
    String userManagementDbUrl = "jdbc:mysql://localhost:3306/usermanagement";
    String dbUser = "root";
    String dbPassword = "1234";

    boolean validInput = true;
    String invalidOptionMessage = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Validate correct option input
        for (int i = 0; i < correctOption.length; i++) {
            String correctAns = correctOption[i].toUpperCase();

            // Only allow A, B, C, D as valid options
            if (!correctAns.matches("[A-D]")) {
                validInput = false;
                invalidOptionMessage = "Invalid correct option for question " + (i + 1) + ". Only A, B, C, or D are allowed.";
                break;
            }

            // Update the correct option array with the validated uppercase value
            correctOption[i] = correctAns;
        }

        if (validInput) {
            // Proceed if input is valid

            // Connect to TestBox database
            Connection testBoxConn = DriverManager.getConnection(testBoxDbUrl, dbUser, dbPassword);

            // Insert test details into testids table
            String insertTest = "INSERT INTO testids (test_ids, teacher_name, batch, available_from, available_until) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = testBoxConn.prepareStatement(insertTest);
            pstmt.setString(1, testId);
            pstmt.setString(2, teacherName);
            pstmt.setString(3, batch);
            pstmt.setString(4, availableFrom);
            pstmt.setString(5, availableUntil);
            pstmt.executeUpdate();

            // Create the test table for questions
            String createTestTable = "CREATE TABLE " + testId + " (" +
                                     "question_number INT AUTO_INCREMENT PRIMARY KEY, " +
                                     "question_content TEXT, " +
                                     "question_options TEXT, " +
                                     "correct_option VARCHAR(1))";
            Statement stmt = testBoxConn.createStatement();
            stmt.executeUpdate(createTestTable);

            // Insert questions into the test-specific table
            for (int i = 0; i < questionContent.length; i++) {
                String question = questionContent[i];
                String options = "A) " + optionA[i] + ", B) " + optionB[i] + ", C) " + optionC[i] + ", D) " + optionD[i];
                String correctAns = correctOption[i];  // Now uppercase and validated

                String insertQuestion = "INSERT INTO " + testId + " (question_content, question_options, correct_option) VALUES (?, ?, ?)";
                pstmt = testBoxConn.prepareStatement(insertQuestion);
                pstmt.setString(1, question);
                pstmt.setString(2, options);
                pstmt.setString(3, correctAns);
                pstmt.executeUpdate();
            }

            // Now connect to the usermanagement database
            Connection userManagementConn = DriverManager.getConnection(userManagementDbUrl, dbUser, dbPassword);

            // Update the test_assigned table for the given batch to add the testId to test_ids column
            String getTestIdsQuery = "SELECT test_ids FROM test_assigned WHERE batch_name = ?";
            pstmt = userManagementConn.prepareStatement(getTestIdsQuery);
            pstmt.setString(1, batch);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String testIds = rs.getString("test_ids");
                if (testIds == null || testIds.isEmpty()) {
                    testIds = testId;
                } else {
                    testIds += "," + testId;
                }

                String updateTestIdsQuery = "UPDATE test_assigned SET test_ids = ? WHERE batch_name = ?";
                pstmt = userManagementConn.prepareStatement(updateTestIdsQuery);
                pstmt.setString(1, testIds);
                pstmt.setString(2, batch);
                pstmt.executeUpdate();
            }

            // Close connections
            testBoxConn.close();
            userManagementConn.close();

            // Redirect to AdminTestManagement.jsp after successful processing
            response.sendRedirect("AdminTestManagement.jsp");
            return; // Ensure no further processing occurs after redirect

        } else {
            // If input is invalid, display the error message
            out.println("<h2>" + invalidOptionMessage + "</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Add a back button to redirect to test_table.jsp -->
<br><br>
<a href="test_table.jsp">Go back to Test Management</a>
