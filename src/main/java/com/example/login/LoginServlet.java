package com.example.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String jdbcURL = "jdbc:mysql://localhost:3306/usermanagement";
        String dbUser = "root";
        String dbPassword = "1234";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String role = resultSet.getString("role");
                
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                if ("admin".equals(role)) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("user.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}





// code before preventing easy change of url
/**
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/usermanagement";
        String dbUser = "root";
        String dbPassword = "1234";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Prepare SQL query
            String sql = "SELECT role FROM users WHERE username = ? AND password = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);

            // Execute the query
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                // Get the role of the user trying to sign in
            	String role = resultSet.getString("role");
            	
            	// Store username in session
            	HttpSession session = request.getSession();
                session.setAttribute("username", username);
            	
            	if("admin".equalsIgnoreCase(role)){
            		response.sendRedirect("admin.jsp");
            		
            	}else if("user".equalsIgnoreCase(role)){
            		response.sendRedirect("user.jsp");
            		
            	}else {
            		response.sendRedirect("success.jsp");
            	}
            		
            } else {
                // Authentication failed, redirect to error.jsp
                response.sendRedirect("error.jsp");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            // Handle any errors by redirecting to an error page or logging
            response.sendRedirect("error.jsp");
        } finally {
            try {
                // Clean up resources
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

**/

// OG Code

/**
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


//Servlet implementation class LoginServlet;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "password123".equals(password)) {
            response.sendRedirect("success.jsp");
        } else {
            response.sendRedirect("error.jsp");
        }
    }
	

}

**/



// claude 



/**



import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/usermanagement";
        String dbUser = "root";
        String dbPassword = "1234";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // Load MySQL JDBC Driver
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                System.out.println("JDBC Driver loaded successfully");
            } catch (ClassNotFoundException e) {
                System.out.println("Error loading JDBC driver: " + e.getMessage());
                e.printStackTrace();
                throw new ServletException("Error loading JDBC driver", e);
            }

            // Establish the connection
            try {
                connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                System.out.println("Database connected successfully");
            } catch (SQLException e) {
                System.out.println("Error connecting to database: " + e.getMessage());
                e.printStackTrace();
                throw new ServletException("Error connecting to database", e);
            }

            // Prepare SQL query
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            
            System.out.println("Executing query: " + statement.toString());

            // Execute the query
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                System.out.println("Login successful for user: " + username);
                response.sendRedirect("success.jsp");
            } else {
                System.out.println("Login failed for user: " + username);
                response.sendRedirect("error.jsp");
            }

        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
**/