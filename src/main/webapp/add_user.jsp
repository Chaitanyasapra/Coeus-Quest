<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User</title>
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
            background-color: #ffffff; /* Set to white for uniformity with user.jsp */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            flex-direction: column;
            overflow: hidden; /* Hide scroll bar */
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

        .container {
            width: 100%;
            max-width: 300px; /* Reduced max width for the form */
            padding: 20px; /* Reduced padding for the form */
            background-color: rgba(255, 255, 255, 0.9); /* Slightly translucent white background */
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5); /* Light glow */
            text-align: center;
            position: relative;
            transition: box-shadow 0.55s ease-in-out; /* Added margin-top to position below the top bar */
        }
        
        .container:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1); /* Enhanced glow */
        }

        h1 {
            color: #ff6600; /* Consistent header color */
            font-size: 24px; /* Reduced font size for the heading */
            margin-bottom: 10px; /* Reduced margin */
        }

        label {
            font-size: 14px; /* Reduced label font size */
            color: #666; /* Lighter text color for labels */
            display: block; /* Ensure labels are block elements */
            margin-bottom: 5px; /* Reduce spacing below labels */
        }

        .radio-group {
            display: flex; /* Display radio buttons in a row */
            justify-content: center; /* Center them */
            margin-bottom: 15px; /* Spacing below radio buttons */
        }

        .radio-group input[type="radio"] {
            margin-right: 5px; /* Space to the right of each radio button */
        }

        .space {
            margin-right: 20px; /* Space after the User radio button */
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px; /* Reduced padding for consistency */
            margin-bottom: 10px; /* Reduced margin bottom */
            border: 2px solid #ddd; /* Match border style with user.jsp */
            border-radius: 8px;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.5); /* Slightly translucent input background */
            color: black; /* Text color inside the inputs */
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #ff6600; /* Change border color on focus */
            outline: none;
            box-shadow: 0 0 5px rgba(255, 102, 0, 0.5); /* Light glow effect on focus */
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px; /* Reduced padding */
            background-color: #ff6600; /* Match the button color */
            color: white;
            border: none;
            border-radius: 5px; /* Rounded button */
            cursor: pointer;
            font-size: 14px; /* Reduced font size */
            transition: background-color 0.3s; /* Smooth background color transition */
        }

        input[type="submit"]:hover {
            background-color: #ff8800; /* Match hover color */
        }

        .message {
            margin-top: 10px; /* Reduced spacing */
            color: #ff6600; /* Match message color */
            font-size: 14px; /* Reduced font size */
            font-weight: bold;
        }

        .back-button {
            margin-top: 10px; /* Reduced spacing */
        }

    </style>
    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            passwordField.type = passwordField.type === "password" ? "text" : "password"; // Toggling password visibility
        }
    </script>
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Add User</h1>
        <form action="addUser" method="post">
            <label><b>Role</b></label>
            <div class="radio-group">
                <input type="radio" id="user" name="role" value="user" checked>
                <label for="user" class="space"><b><i>User</i></b></label>
                <input type="radio" id="admin" name="role" value="admin">
                <label for="admin"><b><i>Admin</i></b></label>
            </div>

            <label><b>Username</b></label>
            <input type="text" name="username" required/>

            <label><b>Batch</b></label> <!-- New field for batch -->
            <input type="text" name="batch" required/>

            <label><b>Password</b></label>
            <input type="password" id="password" name="password" required/>
            <label class="show-password">
                <input type="checkbox" onclick="togglePasswordVisibility()"> Show Password
            </label>
            <br>

            <input type="submit" value="Add User"/>
        </form>

        <%
            if (request.getParameter("success") != null) {
                out.println("<p class='message'><i>User added successfully!</i></p>");
            } else if (request.getParameter("error") != null) {
                out.println("<p class='message'><i>Error adding user. Please try again</i></p>");
            }
        %>
        <br/>
        <form action="user_table.jsp" method="get">
            <input type="submit" value="Back" />
        </form>
    </div>
</body>
</html>
