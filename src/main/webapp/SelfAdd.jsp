<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="javax.mail.*, javax.mail.internet.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Random" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String batchName = request.getParameter("batch");
    String email = request.getParameter("email");
    String inputCode = request.getParameter("verificationCode"); // Code entered by the user
    String message = null;
    boolean userExists = false;
    boolean isVerificationStage = false;
    boolean isVerified = false;
    int sentVerificationCode = 0; // Store generated code

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    if (session.getAttribute("verificationCode") != null) {
        sentVerificationCode = (int) session.getAttribute("verificationCode");
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/usermanagement", "root", "1234");

        if (inputCode != null) {
            // Check if the input code matches the generated verification code
            if (Integer.parseInt(inputCode) == sentVerificationCode) {
                isVerified = true;
                // After successful verification, insert the user into the database
                String insertUserQuery = "INSERT INTO users (username, password, role, batch) VALUES (?, ?, 'user', ?)";
                pst = conn.prepareStatement(insertUserQuery);
                pst.setString(1, (String) session.getAttribute("username"));
                pst.setString(2, (String) session.getAttribute("password"));
                pst.setString(3, (String) session.getAttribute("batch"));
                pst.executeUpdate();
                message = "Registration Successful!";
                session.removeAttribute("verificationCode"); // Clear the session data
            } else {
                message = "Incorrect verification code. Please try again.";
                isVerificationStage = true;
            }
        } else if (username != null && password != null) {
            // Check if the username already exists
            String checkUserQuery = "SELECT * FROM users WHERE username = ?";
            pst = conn.prepareStatement(checkUserQuery);
            pst.setString(1, username);
            rs = pst.executeQuery();

            if (rs.next()) {
                userExists = true;
                message = "User with the same username already exists!";
            } else {
                // Generate a random 6-digit verification code
                Random rand = new Random();
                sentVerificationCode = 100000 + rand.nextInt(900000);

                // Store the user's details in session attributes
                session.setAttribute("username", username);
                session.setAttribute("password", password);
                session.setAttribute("batch", batchName);
                session.setAttribute("verificationCode", sentVerificationCode);

                // Send the verification email
                sendVerificationEmail(email, username, sentVerificationCode);

                message = "A verification code has been sent to your email.";
                isVerificationStage = true; // Move to verification stage
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "An error occurred during registration.";
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>

<%!
    // Function to send a verification email with a 6-digit code
    private void sendVerificationEmail(String recipientEmail, String username, int verificationCode) {
        String subject = "Your Verification Code";
        String body = "Hello " + username + ",\n\nYour verification code is: " + verificationCode + "\n\nBest regards,\nYour Team";

        // Set up mail server properties
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // Use your SMTP server
        props.put("mail.smtp.port", "587"); // Use the appropriate port for TLS
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Enable TLS
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // Force TLSv1.2 for compatibility

        // Create a session with an authenticator
        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("coeusquest@gmail.com", "ewto reou aoll uatf"); // App-specific password
            }
        });

        try {
            // Create a message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("coeusquest@gmail.com")); // Change to your email
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(body);

            // Send the message
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CoeusQuest</title>
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
            padding-top: 80px; /* Ensures content starts below the top bar */
            overflow: hidden; /* Prevents default scrollbar */
        }

        /* Hide Scrollbar */
        body::-webkit-scrollbar {
            width: 0;
            height: 0;
        }

        .container {
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

        .container:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1); /* Brighter glow on hover */
        }

        h1 {
            color: #ff6600;
            font-size: 36px;
            margin-bottom: 20px;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.5);
            color: black;
            font-size: 16px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px; /* Reduced padding */
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 16px; /* Smaller font size */
            cursor: pointer;
            margin-top: 5px;
            transition: background-color 0.3s;
            font-weight: bold;
        }

        input[type="submit"]:hover {
            background-color: #ff8800;
        }

        .back-button {
            width: 100%;
            padding: 10px; /* Reduced padding */
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 16px; /* Smaller font size */
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s;
            font-weight: bold;
        }

        .back-button:hover {
            background-color: #cc0000;
        }

        .show-password {
            color: #ff6600;
            text-align: left;
            margin-bottom: 10px;
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

    <!-- Registration Form -->
    <div class="container">
        <h1>Register</h1>

        <% if (isVerified) { %>
            <p>Registration Successful!</p>
        <% } else if (isVerificationStage) { %>
            <p>A verification code has been sent to your email. Please enter it below:</p>
            <form action="SelfAdd.jsp" method="post">
                <input type="hidden" name="username" value="<%= session.getAttribute("username") %>"/>
                <input type="hidden" name="batch" value="<%= session.getAttribute("batch") %>"/>
                <input type="hidden" name="email" value="<%= email %>"/>
                <input type="hidden" name="password" value="<%= session.getAttribute("password") %>"/>
                
                <label>Verification Code</label><br/>
                <input type="text" name="verificationCode" required/><br/>
                <input type="submit" value="Submit Code"/>
            </form>
        <% } else { %>
            <form action="SelfAdd.jsp" method="post">
                <label><b>Username</b></label><br/>
                <input type="text" name="username" required/><br/>

                <label><b>Batch Name</b></label><br/>
                <input type="text" name="batch" required/><br/>

                <label><b>Email</b></label><br/>
                <input type="email" name="email" required/><br/>

                <label><b>Password</b></label><br/>
                <input type="password" id="password" name="password" required/><br/>

                <label class="show-password">
                    <input type="checkbox" onclick="togglePasswordVisibility()"> Show Password
                </label>

                <input type="submit" value="Register"/>
            </form>
        <% } %>

        <% if (message != null) { %>
            <p><%= message %></p>
        <% } %>

        <button class="back-button" onclick="window.location.href='login.jsp'">Back</button>
    </div>

    <script>
        function togglePasswordVisibility() {
            var passwordInput = document.getElementById("password");
            passwordInput.type = (passwordInput.type === "password") ? "text" : "password";
        }
    </script>

</body>
</html>



