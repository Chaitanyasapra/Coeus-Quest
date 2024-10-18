<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Test - CoeusQuest</title>
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
        }

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

        a {
            padding: 10px 15px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #ff8800;
        }

        .top-bar h3 {
            color: #fff;
            font-size: 20px;
            font-weight: 700;
        }

        .container {
            width: 70%;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-height: 80vh;
            margin-top: 80px;
            overflow-y: auto;
        }

        h1 {
            text-align: center;
            color: #ff6600;
            font-weight: bold;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
        }

        input[type="text"],
        input[type="datetime-local"],
        textarea {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        textarea {
            resize: none;
        }

        input[type="submit"],
        button[type="button"] {
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover,
        button[type="button"]:hover {
            background-color: #ff8800;
        }

        .back-button {
            padding: 5px 10px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #ff8800;
        }

        /* Custom scrollbar */
        .container::-webkit-scrollbar {
            width: 10px;
        }

        .container::-webkit-scrollbar-thumb {
            background-color: #ff6600;
            border-radius: 5px;
        }

        .container::-webkit-scrollbar-track {
            background-color: white;
        }

        .button-box {
            display: flex;
            justify-content: flex-end; /* Align button to the right */
            margin-top: 10px;
        }
    </style>
    <script>
        function addQuestion() {
            var questionContainer = document.getElementById('questionsContainer');
            var questionNumber = document.getElementsByClassName('questionBlock').length + 1;

            var questionBlock = document.createElement('div');
            questionBlock.className = 'questionBlock';
            questionBlock.innerHTML = `
                <h3>Question ` + questionNumber + `</h3>
                <label>Question Content:</label><br>
                <textarea name="questionContent[]" rows="4" required>Default question content</textarea><br><br>
                
                <label>Option A:</label>
                <input type="text" name="optionA[]" value="Default Option A" required><br>
                
                <label>Option B:</label>
                <input type="text" name="optionB[]" value="Default Option B" required><br>
                
                <label>Option C:</label>
                <input type="text" name="optionC[]" value="Default Option C" required><br>
                
                <label>Option D:</label>
                <input type="text" name="optionD[]" value="Default Option D" required><br><br>
                
                <label>Correct Option (A/B/C/D):</label>
                <input type="text" name="correctOption[]" maxlength="1" value="A" pattern="[A-Da-d]" required><br><br>

                <button type="button" onclick="removeQuestion(this)">Remove Question</button><br><br>
            `;
            questionContainer.appendChild(questionBlock);
        }

        function removeQuestion(button) {
            var questionBlock = button.parentNode;
            questionBlock.remove();
            renumberQuestions();
        }

        function renumberQuestions() {
            var questionBlocks = document.getElementsByClassName('questionBlock');
            for (var i = 0; i < questionBlocks.length; i++) {
                questionBlocks[i].getElementsByTagName('h3')[0].innerText = 'Question ' + (i + 1);
            }
        }
        
        function confirmBack() {
            if (confirm('The test will not be added, are you sure you want to go back?')) {
                location.href = 'AdminTestManagement.jsp';
            }
        }
        
    </script>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
    </div>

    <div class="container">
        <h1>Add a New Test</h1>
        
        <div class="button-box">
            <button class="back-button" onclick="confirmBack()">Back</button>
        </div>

        <form action="addTestProcess.jsp" method="post">
            <label>Test ID:</label>
            <input type="text" name="testId" required><br><br>

            <label>Teacher Name:</label>
            <input type="text" name="teacherName" required><br><br>

            <label>Batch:</label>
            <input type="text" name="batch" required><br><br>

            <label>Available From:</label>
            <input type="datetime-local" name="availableFrom" required><br><br>

            <label>Available Until:</label>
            <input type="datetime-local" name="availableUntil" required><br><br>

            <h2>Add Questions</h2>
            <div id="questionsContainer">
                <!-- Dynamically added questions will appear here -->
            </div>

            <button type="button" onclick="addQuestion()">Add Question</button><br><br>

            <input type="submit" value="Add Test">
        </form>
    </div>
</body>
</html>
