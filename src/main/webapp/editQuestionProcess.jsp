<%@ page import="java.sql.*" %>

<%
String testId = request.getParameter("testId");
int questionNumber = Integer.parseInt(request.getParameter("questionNumber"));
String questionContent = request.getParameter("questionContent");
String questionOptions = request.getParameter("questionOptions");
String correctOption = request.getParameter("correctOption");

String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
String dbUser = "root";
String dbPassword = "1234";
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

    String updateQuery = "UPDATE " + testId + " SET question_content = ?, question_options = ?, correct_option = ? WHERE question_number = ?";
    pstmt = conn.prepareStatement(updateQuery);
    pstmt.setString(1, questionContent);
    pstmt.setString(2, questionOptions);
    pstmt.setString(3, correctOption);
    pstmt.setInt(4, questionNumber);

    int rowsAffected = pstmt.executeUpdate();

    // Redirect to editTest.jsp regardless of success or failure
    if (rowsAffected > 0) {
        // Successful update, redirect to the test edit page
        response.sendRedirect("editTest.jsp?testId=" + testId);
    } else {
        // If update failed, still redirect to editTest.jsp (you can add a failure message parameter if needed)
        response.sendRedirect("editTest.jsp?testId=" + testId + "&error=updateFailed");
    }
} catch (Exception e) {
    e.printStackTrace();
    // Redirect with an error message if an exception occurs
    response.sendRedirect("editTest.jsp?testId=" + testId + "&error=exceptionOccurred");
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>
