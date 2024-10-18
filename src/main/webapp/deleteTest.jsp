<%@ page import="java.sql.*" %>

<%
    String testId = request.getParameter("testId");

    String dbUrl = "jdbc:mysql://localhost:3306/TestBox";
    String dbUser = "root";
    String dbPassword = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Delete the test from testids table
        String deleteTest = "DELETE FROM testids WHERE test_ids = ?";
        PreparedStatement pstmt = conn.prepareStatement(deleteTest);
        pstmt.setString(1, testId);
        pstmt.executeUpdate();

        // Drop the corresponding test table
        String dropTable = "DROP TABLE IF EXISTS " + testId;
        Statement stmt = conn.createStatement();
        stmt.executeUpdate(dropTable);

        // Close the connection
        conn.close();

        // Redirect to AdminTestManagement.jsp after successful deletion
        response.sendRedirect("AdminTestManagement.jsp");
        return; // Ensure no further processing happens
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- In case of an error, you can show a message -->
<br><br>
<a href="test_table.jsp">Go back to Test Management</a>
