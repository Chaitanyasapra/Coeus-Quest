<%@ page import="java.sql.*" %>

<%
String testId = request.getParameter("testId");
String questionNumber = request.getParameter("questionNumber");
String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
String dbUser = "root";
String dbPassword = "1234";
Connection conn = null;
PreparedStatement stmt = null;
String deleteMessage = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

    // Step 1: Delete the question based on question_number
    String deleteQuery = "DELETE FROM " + testId + " WHERE question_number = ?";
    stmt = conn.prepareStatement(deleteQuery);
    stmt.setInt(1, Integer.parseInt(questionNumber));
    int rowsDeleted = stmt.executeUpdate();

    if (rowsDeleted > 0) {
        deleteMessage = "Question deleted successfully!";

        // Step 2: Update question numbers for subsequent questions
        String updateQuery = "UPDATE " + testId + " SET question_number = question_number - 1 WHERE question_number > ?";
        stmt = conn.prepareStatement(updateQuery);
        stmt.setInt(1, Integer.parseInt(questionNumber));
        stmt.executeUpdate();
    } else {
        deleteMessage = "Failed to delete the question.";
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
}

response.sendRedirect("editTest.jsp?testId=" + testId + "&deleteMessage=" + deleteMessage);
%>
