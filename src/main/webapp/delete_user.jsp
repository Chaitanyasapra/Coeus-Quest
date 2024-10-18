<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User</title>
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
            max-width: 300px;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 102, 0, 0.5);
            text-align: center;
            transition: box-shadow 0.55s ease-in-out;
        }

        .container:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1), 0 0 25px rgba(255, 102, 0, 1);
        }

        h1 {
            color: #ff6600;
            font-size: 24px;
            margin-bottom: 10px;
        }

        label {
            font-size: 14px;
            color: #666;
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 2px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.5);
            color: black;
        }

        input[type="text"]:focus {
            border-color: #ff6600;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 102, 0, 0.5);
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #ff8800;
        }

        .message {
            margin-top: 10px;
            color: #ff6600;
            font-size: 14px;
            font-weight: bold;
        }

        .back-button {
            margin-top: 10px;
        }

    </style>
    <script>
        function confirmDeletion() {
            return confirm("Are you sure you want to delete this user?");
        }
    </script>
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Delete User</h1>
        <form action="deleteUser" method="post" onsubmit="return confirmDeletion();">
            <label><b>Username</b></label>
            <input type="text" name="username" placeholder="Username" required/><br/>
            <input type="submit" value="Delete User"/>
        </form>

        <!-- Display success or error message after form submission -->
        <%
            if (request.getParameter("success") != null) {
                out.println("<p class='message'><i>User deleted successfully!</i></p>");
            } else if (request.getParameter("error") != null) {
                out.println("<p class='message'><i>Error deleting user. Please try again</i></p>");
            }
        %>
        <br/>
        <form action="user_table.jsp" method="get">
            <input type="submit" value="Back" />
        </form>
    </div>
</body>
</html>
