# MySQL + Flask Real Estate Database Project

##Project Description
For this project, I designed a database to be utilized by a real estate team to manage their daily tasks 
and responsibilities. As a starting point, I had three primary users in mind - a prospective buyer, an agent, 
and a brokerage owner. The Flask application currently supports the following actions for each user: 
<br> 
<br>
Prospective Buyer:
- view the schedule and specifics of the user logged in
- view all the agents and sort by name and years of experience 
- view all the active listings for sale and filter by attribute 
- view all the favorite listings of the user logged in 

Agent: 
- register a new buyer into the database 
- register a new active listing in the database 
- view all the listings associated with agent user logged in 
- view all the prospective buyers in the system 
- view all the prospective buyer clients of the user logged in 
- search for a specific buyer and view their details 
- view the appointments of the user logged in 


##Project Inspiration
One of my personal interests is real estate. I love looking at homes for sale and 
apartments for rent in my free time, and I have always been intrigued by the work 
real estate agents do on a daily basis, as well as the interactions they have with 
their clients, co-workers, and upper-level management. I figured that designing a 
real estate management database product would be an interesting and relevant application 
of concepts from the CS3200 course that would simultaneously allow me to explore 
the essential activities of a real estate firm. 

##Future Expansion
To further build upon this project, I would implement more routes for 
each persona to better capture all the interactions within a real 
estate firm. For instance, I would add a route to the buyer that would 
allow them to update their buyer specifics and I would add a route to 
the broker that would allow them to calculate the net sales of each agent 
in the brokerage. Doing so would increase the applicability of the product. 


##Prerequisites 
Python <br>
MySQL <br>
Flask <br>
Docker Desktop <br> 
ngrok <br>


##Setup and Run 
1. Clone this repository. 
2. Open Docker Desktop 
3. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file. 
4. Build the images with `docker compose build`. 
5. Start the containers with `docker compose up`. 
6. With the containers running, navigate to another terminal or command prompt. Navigate to the ngrok executable. 
7. Start an ngrok session with `ngrok http 8001`.
8. Copy the "Forwarding" URL and update the URL in the "RealEstateNgrok" datasource in AppSmith.
9. Deploy the "Agent View" AppSmith application for a mock UI of what an agent would see, and 
deploy the "Buyer View" application for a mock UI of what a buyer would see. 

##File Structure 
`real_estate_bootstrap.sql`
- contains SQL queries for creating the database, user, and tables
- contains queries inserting sample data into the tables 

`agents.py`
- contains initialization of agent blueprint
- contains routes associated with agent persona

`brokers.py`
- contains initialization of broker blueprint
- contains routes associated with broker persona

`buyers.py`
- contains initialization of buyer blueprint
- contains routes associated with prospective buyer persona

`__init__.py`
- contains setup and configuration of the Flask application 
- blueprints are registered and url prefixes are specified here

`requirements.txt`
- contains requirements for running the application 

`app.py`
- contains creation of application object 

`Dockerfile`
- contains instructions and specifications for building the container image 

`docker-compose.yml`
- contains information to configure containers 