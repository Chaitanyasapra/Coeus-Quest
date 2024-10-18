<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CoeusQuest</title>
    <link rel="icon" href="favi.ico" type="image/x-icon">
    <style>
    
    	html {
        	scroll-behavior: smooth; /* Enable smooth scrolling for the entire page */
    	}
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden; /* Prevent body scroll */
        }

        /* Top Bar */
        .top-bar {
            position: fixed;
            cursor: pointer;
            top: 0;
            width: 100%;
            height: 60px;
            background: linear-gradient(to right, #ff6600, #ffcc33);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
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
            position: relative; /* For hover effect */
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

        /* Main Content */
        .container2 {
            margin-top: 60px; /* Adjust for the fixed top bar */
            padding: 0 20px;
            overflow-y: auto; /* Enable scroll inside the container */
            height: calc(100vh - 60px); /* Take the remaining viewport height after top bar */
            padding-bottom: 20px; /* Add some space for the footer */
        }

        .container2::-webkit-scrollbar {
            width: 10px;
        }

        .container2::-webkit-scrollbar-thumb {
            background-color: #ff6600;
        }

        .container2::-webkit-scrollbar-track {
            background-color: white;
        }

        section {
            padding: 20px;
            margin: 20px 0;
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2 {
            color: #ff6600;
            margin-bottom: 10px;
        }

        footer {
            text-align: center;
            padding: 10px 0;
            background: linear-gradient(to right, #ff6600, #ffcc33);
            color: white;
            width: 100%; /* Full width */
        }

        #home {
            background-image: url('background1.jpg');
            background-size: cover;
            background-position: center;
            border-radius: 20px;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            padding: 0 20px;
            
        }

        #home h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }

        #home p {
            max-width: 800px;
            font-size: 1.2em;
        }
        
        #about {
		    background-image: url('up2.jpg');
		    filter: contrast(1);
		    background-size: cover;
		    background-position: center;
		    border-radius: 20px;
		    height: 90vh;
		    display: flex;
		    flex-direction: column;
		    justify-content: flex-start; /* Aligns content to the top */
		    align-items: flex-start; /* Aligns content to the left */
		    text-align: left; /* Left-aligns text */
		    padding: 30px; /* Add padding for spacing */
		}
		
		.about-content {
		    background-color: rgba(0, 0, 0, 0.3); /* Translucent black background */
		    padding: 30px;
		    border-radius: 20px;
		    color: white;
		    max-width: 900px;
		    margin-top: 20px;
		}
		
		#about h1 {
		    font-size: 2.5em;
		    margin-bottom: 20px;
		}
		
		#about p {
		    max-width: 800px;
		    font-size: 1.2em;
		    margin-bottom: 20px;
		}
		
		#about ul {
		    margin-bottom: 30px;
		    padding-left: 20px;
		}
		
		#about ul li {
		    margin-bottom: 10px;
		    font-size: 1.1em;
		}


        #faq h1 {
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 30px;
        }

        #faq p {
            font-size: 1.2em;
            line-height: 1.6;
        }

        #faq h3 {
            font-size: 1.6em;
            margin-bottom: 10px;
        }

        /* Contact Us Section */
        #contact h1 {
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 20px;
        }

        #contact p {
            font-size: 1.2em;
            line-height: 1.6;
            text-align: center;
            margin-bottom: 15px;
        }

        #contact a {
            color: #ff6600;
            font-weight: bold;
            text-decoration: none;
        }

        #contact a:hover {
            text-decoration: underline;
        }
        
        
       .faq-item {
        margin: 10px 0;
        border-bottom: 1px solid #ddd;
    }

    .faq-question {
        font-size: 1.5em;
        font-weight: 600;
        padding: 10px;
        cursor: pointer;
        position: relative;
    }

    .faq-answer {
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s ease;
        font-size: 1.2em;
        padding: 0 10px;
        line-height: 1.6;
    }

    .faq-item.open .faq-answer {
        max-height: 200px; /* Adjust based on content length */
        padding: 10px;
    }

    .faq-item.open .faq-question::after {
        content: "↓"; /* Down arrow */
        font-size: 1.5em;
        position: absolute;
        right: 10px;
        top: 10px;
    }

    .faq-question::after {
        content: "→"; /* Right arrow */
        font-size: 1.5em;
        position: absolute;
        right: 10px;
        top: 10px;
    }
    
    .indent{
    	text-indent: 50px;
    }
    .indent ul {
	    list-style-position: inside; /* Ensures bullets are aligned with the text */
	}
	
	.indent ul li {
	    margin-left: 20px; /* Extra margin for bullets and text to be indented */
	}
        
    </style>
</head>
<body>
    <div class="top-bar">
        <h3>CoeusQuest</h3>
        <nav>
            <a href="#about">About</a>
            <a href="#faq">FAQ</a>
            <a href="#contact">Contact Us</a>
            <a onclick="window.location.href='login.jsp'">Login</a>
        </nav>
    </div>

    <div class="container2">
        <div class="container">
            <section id="home">
                <h1>Welcome to CoeusQuest</h1>
                <p>
                    Unleash your potential, one challenge at a time
                </p>
            </section>

           <section id="about">
    <div class="about-content">
        <i>
            <b><h1>Who are we?</h1></b>
            <p style="text-align: justify;">
                We are innovators in education, dedicated to making learning an exciting journey.<br>
                Our approach combines:
            </p>
            <div class="indent">
	            <ul>
	                <li>Innovation and creativity in every step.</li>
	                <li>Empowering students to unlock their potential.</li>
	                <li>A belief in curiosity as the key to growth.</li>
	            </ul>
            </div>

            <b><h1>What are our goals?</h1></b>
            <p style="text-align: justify;">
                We aim to transform learners into tech-savvy professionals by:
            </p>
            <div class="indent">
	            <ul>
	                <li>Providing hands-on projects that simulate real-world challenges.</li>
	                <li>Ensuring continuous feedback and mentorship.</li>
	                <li>Building problem-solving skills for long-term success.</li>
	            </ul>
            </div>
        </i>
    </div>
</section>


			
			
			<section id="faq">
			    <h1>FAQ</h1>
			
			
			    <div class="faq-item">
			        <div class="faq-question">How can I access the resources?</div>
			        <div class="faq-answer">
			            <p>Simply create an account on our website, and you will gain access to a variety of tools and materials tailored to enhance your learning journey.</p>
			        </div>
			    </div>
			
			    <div class="faq-item">
			        <div class="faq-question">Do you offer support for different learning levels?</div>
			        <div class="faq-answer">
			            <p>Absolutely! Our resources are designed to cater to all academic levels, ensuring everyone can find something suited to their needs.</p>
			        </div>
			    </div>
			
			    <div class="faq-item">
			        <div class="faq-question">Can I track my progress?</div>
			        <div class="faq-answer">
			            <p>Yes! Our adaptive assessments allow you to monitor your growth and adjust your learning path as you progress.</p>
			        </div>
			    </div>
			
			    <div class="faq-item">
			        <div class="faq-question">How can I get in touch with CoeusQuest?</div>
			        <div class="faq-answer">
			            <p>You can reach us through the contact information below. We are always happy to help!</p>
			        </div>
			    </div>
			</section>
            
            <!-- Contact Us Section -->
            <section id="contact">
                <h1>Contact Us</h1>
                <p>We would love to hear from you! For any questions, feedback, or support, feel free to reach out:</p>
                <p>Phone: (555) 123-4567</p>
                <p>Email: <a href="mailto:coeusquest@gmail.com">coeusquest@gmail.com</a></p>
                <p>Address: 123 Learning Lane, Suite 100, Cityville, ST 12345</p>
            </section>
        </div>
        <footer>
        	<p>&copy; 2024 CoeusQuest. All rights reserved.</p>
    	</footer>
    </div>
	
	
	<script>
		document.querySelectorAll('.top-bar nav a').forEach(anchor => {
	        anchor.addEventListener('click', function(e) {
	            e.preventDefault(); // Prevent default anchor click behavior
	            const targetSection = document.querySelector(this.getAttribute('href'));
	            targetSection.scrollIntoView({
	                behavior: 'smooth', // Smooth scrolling effect
	                block: 'start' // Align the section to the top of the viewport
	            });
	        });
	    });
	
		document.querySelectorAll('.faq-question').forEach(question => {
		    question.addEventListener('click', () => {
		        const faqItem = question.parentElement;
		        const faqAnswer = faqItem.querySelector('.faq-answer');
	
		        // Toggle the open class for expand/collapse
		        faqItem.classList.toggle('open');
	
		        // Smooth scroll to the FAQ item after toggling
		        //faqItem.scrollIntoView({ behavior: 'smooth', block: 'start' });
		    });
		});
    </script>
    
</body>
</html>