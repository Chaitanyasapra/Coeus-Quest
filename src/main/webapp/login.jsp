<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
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
            display: flex;
            height: 100vh;
        }

        .container {
            display: flex;
            width: 100%;
        }

        /* Left Side - Logo and Tagline */
        .left-section {
            width: 50%;
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            /* background-image: url('coeusquest_logo_png_2.png');  Optional: add flame-inspired patterns */
            background-size: cover;
        }

        .left-section img {
            width: auto;
            height: auto;
            margin-bottom: 20px;
        }

        .left-section h1 {
            font-size: 48px;
            font-weight: bold;
            color: #ff6600;
            margin-bottom: 10px;
        }

        .left-section p {
            font-size: 20px;
            color: #8e24aa;
            letter-spacing: 1.5px;
        }

        /* Right Side - Login Form */
        .right-section {
            width: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            background-color: #f5f5f5;
        }

        .login-container {
            width: 100%;
            max-width: 400px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .login-container h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 30px;
            color: #ff6600;
        }

        label {
            display: block;
            text-align: left;
            font-size: 16px;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #ff6600;
            outline: none;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #ff6600;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #ff8800;
        }

        .create-account {
            display: block;
            margin-top: 20px;
            font-size: 14px;
            color: #8e24aa;
        }

        .create-account a {
            color: #ff6600;
            text-decoration: none;
        }

        .create-account a:hover {
            text-decoration: underline;
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
            text-decoration: none;
            
        }

        .top-bar nav a::after {
            content: '';
            display: block;
            width: 0;
            height: 2px;
            background: #fff;
            transition: width 0.3s;
        }

        .top-bar nav a:hover::after {
            width: 100%; /* Expand underline effect */
        }
        .show-password {
            color: #ff6600;
            text-align: left;
            margin-bottom: 10px;
        }
        

    </style>
</head>
<body>

    <!-- Top Bar -->
    <div class="top-bar">
        <h3>CoeusQuest</h3>
        <nav>
            <a href="Welcome.jsp">Home</a>
        </nav>
    </div>

    <div class="container">
        <!-- Left Section - Logo & Tagline -->
        <div class="left-section">
            <img src="coeusquest_logo.jpg" alt="CoeusQuest Logo">
        </div>

        <!-- Right Section - Login Form -->
        <div class="right-section">
            <div class="login-container">
                <h2>Login to Your Account</h2>
                <form action="LoginServlet" method="post">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>

                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                    
                    <label class="show-password">
                    	<input type="checkbox" onclick="togglePasswordVisibility()"> Show Password
                	</label>

                    <input type="submit" value="Login">
                </form>

                <div class="create-account">
                    Don't have an account? <a href="SelfAdd.jsp">Create Account</a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function togglePasswordVisibility() {
            var passwordInput = document.getElementById("password");
            passwordInput.type = (passwordInput.type === "password") ? "text" : "password";
        }
    </script>

</body>
</html>
