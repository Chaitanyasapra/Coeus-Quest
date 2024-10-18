<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.util.*" %>
<%
    String inputCode = request.getParameter("verificationCode");
    HttpSession SelfAddSession = request.getSession();
    
    // Retrieve the stored verification code from the session
    int sessionCode = (int) SelfAddSession.getAttribute("verificationCode");

    String username = (String) SelfAddSession.getAttribute("username");
    String password = (String) SelfAddSession.getAttribute("password");
    String batchName = (String) SelfAddSession.getAttribute("batch");

    Connection conn = null;
    PreparedStatement pst = null;

    if (inputCode != null && inputCode.equals(String.valueOf(sessionCode))) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/usermanagement", "root", "1234");

            // Insert the new user into the database
            String insertUserQuery = "INSERT INTO users (username, password, role, batch) VALUES (?, ?, 'user', ?)";
            pst = conn.prepareStatement(insertUserQuery);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, batchName);
            pst.executeUpdate();

            SelfAddSession.invalidate(); // Invalidate the session after successful registration
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }
    } else {
        out.println("<script>alert('Invalid verification code. Please try again.');</script>");
        response.sendRedirect("confirm_pass.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Verification</title>
    <style>
        /* Styles omitted for brevity */
    </style>
</head>
<body>
    <div class="container">
        <h1>Enter Verification Code</h1>
        <form action="confirm_pass.jsp" method="post">
            <label><b>Verification Code</b></label><br/>
            <input type="text" name="verificationCode" required/><br/>
            <input type="submit" value="Verify"/>
        </form>
    </div>
</body>
</html>
