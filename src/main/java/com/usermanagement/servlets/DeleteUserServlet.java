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

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "DELETE FROM users WHERE username = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, username);

            int rowsDeleted = statement.executeUpdate();
            if (rowsDeleted > 0) {
                // Redirect to delete_user.jsp with success message
                response.sendRedirect("delete_user.jsp?success=1");
            } else {
                // Redirect to delete_user.jsp with error message
                response.sendRedirect("delete_user.jsp?error=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Redirect to delete_user.jsp with error message containing SQL error details
            response.sendRedirect("delete_user.jsp?error=1");
        }
    }
}
