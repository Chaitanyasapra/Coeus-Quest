package com.usermanagement.servlets;

import com.usermanagement.util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;  // Add this line to remove the warning

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String batch = request.getParameter("batch"); // Capture the batch parameter

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO users (username, password, role, batch) VALUES (?, ?, ?, ?)"; // Include batch in the SQL
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            statement.setString(3, role);
            statement.setString(4, batch); // Set the batch value
            statement.executeUpdate();
            
            // Redirect or show a success message
            response.sendRedirect("add_user.jsp?success=1");
        } catch (SQLException e) {
            e.printStackTrace();
            // Redirect or show an error message
            response.sendRedirect("add_user.jsp?error=1");
        }
    }
}
