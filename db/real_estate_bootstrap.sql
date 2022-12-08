CREATE DATABASE real_estate_db;
-- CREATE USER 'webapp'@'%' IDENTIFIED BY 'aeh7627*nu';
GRANT ALL PRIVILEGES ON real_estate_db.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

USE real_estate_db;

CREATE TABLE broker (
    brokerID INT AUTO_INCREMENT NOT NULL,
    yearsOfExperience INT(4) NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY(brokerID)
);

CREATE TABLE agent (
    agentID INT AUTO_INCREMENT NOT NULL,
    yearsOfExperience INT(2) NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    officeStreet VARCHAR(50) NOT NULL,
    officeCity VARCHAR(50) NOT NULL,
    officeState VARCHAR(2) NOT NULL,
    officeZip VARCHAR(10) NOT NULL,
    brokerID INT NOT NULL,
    PRIMARY KEY (agentID, brokerID),
    CONSTRAINT fk_14 FOREIGN KEY (brokerID) REFERENCES broker (brokerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE prospectiveBuyer (
    buyerID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (buyerID),
    CONSTRAINT fk_21 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE buyerSpecifics (
    budget DECIMAL NOT NULL,
    beds INT(2),
    baths INT(2),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    buyerID INT NOT NULL,
    PRIMARY KEY (buyerID),
    CONSTRAINT fk_1 FOREIGN KEY (buyerID) REFERENCES prospectiveBuyer (buyerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE featuresWishList (
    buyerID INT NOT NULL,
    featuresWishList VARCHAR(255) NOT NULL,
    PRIMARY KEY (buyerID, featuresWishList),
    CONSTRAINT fk_2 FOREIGN KEY (buyerID) REFERENCES buyerSpecifics (buyerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE neighborhood (
    buyerID INT NOT NULL,
    neighborhood VARCHAR(255) NOT NULL,
    PRIMARY KEY(buyerID, neighborhood),
    CONSTRAINT fk_3 FOREIGN KEY (buyerID) REFERENCES buyerSpecifics (buyerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE propertyType (
    buyerID INT NOT NULL,
    propertyType ENUM('house', 'apartment', 'condo', 'townhome') NOT NULL,
    PRIMARY KEY (buyerID, propertyType),
    CONSTRAINT fk_4 FOREIGN KEY (buyerID) REFERENCES buyerSpecifics (buyerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE activeListing (
    listingID INT AUTO_INCREMENT NOT NULL,
    status ENUM('Active', 'Under Contract', 'Contingent', 'Pending') NOT NULL,
    askingPrice DECIMAL NOT NULL,
    daysOnMarket INT NOT NULL,
    listingDate DATE NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (listingID),
    CONSTRAINT fk_22 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE propertyOwner (
    ownerID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    listingID INT NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (ownerID, listingID, agentID),
    CONSTRAINT fk_5 FOREIGN KEY (listingID) REFERENCES activeListing (listingID) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_6 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE soldListing (
    soldID INT AUTO_INCREMENT NOT NULL,
    sellDate DATE NOT NULL,
    commission INT(2) NOT NULL,
    sellPrice DECIMAL NOT NULL,
    daysOnMarket INT NOT NULL,
    buyerID INT NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (soldID, buyerID, agentID),
    CONSTRAINT fk_7 FOREIGN KEY (buyerID) REFERENCES propertyOwner (ownerID) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_8 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE favoriteListing (
    listingID INT NOT NULL,
    buyerID INT NOT NULL,
    PRIMARY KEY (listingID, buyerID),
    CONSTRAINT fk_9 FOREIGN KEY (listingID) REFERENCES activeListing (listingID) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_10 FOREIGN KEY (buyerID) REFERENCES prospectiveBuyer (buyerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE areaOfExpertise (
    agentID INT NOT NULL,
    areaOfExpertise VARCHAR(255) NOT NULL,
    PRIMARY KEY (agentID, areaOfExpertise) ,
    CONSTRAINT fk_11 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE propertyDetails (
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    beds INT(2),
    baths INT(2) NOT NULL,
    yearBuilt INT(4) NOT NULL,
    squareFootage INT(4) NOT NULL,
    listingID INT NOT NULL,
    PRIMARY KEY (street, city, state, zip, listingID),
    CONSTRAINT fk_12 FOREIGN KEY (listingID) REFERENCES activeListing (listingID) ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE showingAppt (
    apptID INT AUTO_INCREMENT NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    buyerID INT NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (apptID, buyerID, agentID),
    CONSTRAINT fk_15 FOREIGN KEY (buyerID) REFERENCES prospectiveBuyer (buyerID) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_16 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);


CREATE TABLE clientTestimonial (
    testimonialID INT AUTO_INCREMENT NOT NULL,
    stars ENUM('One Star', 'Two Stars', 'Three Stars', 'Four Stars', 'Five Stars') NOT NULL,
    description VARCHAR(255) NOT NULL,
    firstName VARCHAR(20),
    yearCreated INT NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (testimonialID, agentID),
    CONSTRAINT fk_17 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE brokerage (
    brokerageID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    yearFounded INT(4) NOT NULL,
    totalSales INT,
    brokerageStreet VARCHAR(50) NOT NULL,
    brokerageCity VARCHAR(50) NOT NULL,
    brokerageState VARCHAR(2) NOT NULL,
    brokerageZip VARCHAR(10) NOT NULL,
    brokerID INT NOT NULL,
    PRIMARY KEY (brokerageID, brokerID),
    CONSTRAINT fk_18 FOREIGN KEY (brokerID) REFERENCES broker (brokerID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE inspection (
    inspID INT AUTO_INCREMENT NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    inspFirstName VARCHAR(20) NOT NULL,
    inspLastName VARCHAR(20) NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (inspID, agentID),
    CONSTRAINT fk_19 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE openHouse (
    ohID INT AUTO_INCREMENT NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    agentID INT NOT NULL,
    PRIMARY KEY (ohID, agentID),
    CONSTRAINT fk_20 FOREIGN KEY (agentID) REFERENCES agent (agentID) ON UPDATE cascade ON DELETE restrict
);

insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (1, 9, 'Yance', 'Placstone', 'yplacstone0@hubpages.com', '527-897-3860');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (2, 10, 'Lu', 'Zienkiewicz', 'lzienkiewicz1@creativecommons.org', '835-213-2701');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (3, 5, 'Berton', 'Dammarell', 'bdammarell2@artisteer.com', '884-107-3043');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (4, 30, 'Jodee', 'Tattersdill', 'jtattersdill3@cloudflare.com', '317-100-8230');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (5, 58, 'Jess', 'Kielty', 'jkielty4@bloglovin.com', '512-291-6604');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (6, 37, 'Zelma', 'Derkes', 'zderkes5@oaic.gov.au', '448-168-4129');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (7, 38, 'Mellicent', 'Bovis', 'mbovis6@amazon.com', '545-674-8681');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (8, 10, 'Rania', 'Thorndycraft', 'rthorndycraft7@virginia.edu', '734-565-3880');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (9, 44, 'Maryjo', 'Johnigan', 'mjohnigan8@smh.com.au', '423-956-7768');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (10, 42, 'Kali', 'Gyde', 'kgyde9@wisc.edu', '896-298-0512');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (11, 7, 'Izzy', 'Loughlan', 'iloughlana@privacy.gov.au', '942-518-2674');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (12, 56, 'Frans', 'Zaniolo', 'fzaniolob@cisco.com', '867-347-3184');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (13, 10, 'Velma', 'Stollen', 'vstollenc@marriott.com', '248-484-4382');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (14, 25, 'Zuzana', 'Betty', 'zbettyd@msn.com', '216-869-0540');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (15, 32, 'Jean', 'Glenwright', 'jglenwrighte@is.gd', '857-762-8269');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (16, 8, 'Marinna', 'Lunnon', 'mlunnonf@slashdot.org', '464-252-0616');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (17, 50, 'Leigh', 'Timson', 'ltimsong@spotify.com', '781-484-3767');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (18, 37, 'Adlai', 'Jilkes', 'ajilkesh@deviantart.com', '396-404-7406');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (19, 18, 'Lock', 'Rounce', 'lrouncei@apple.com', '544-554-4769');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (20, 13, 'Wendell', 'Turnpenny', 'wturnpennyj@cnbc.com', '659-557-1127');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (21, 56, 'Lisha', 'Matisoff', 'lmatisoff0@uol.com.br', '832-783-3886');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (22, 14, 'Cherry', 'Bicker', 'cbicker1@ed.gov', '420-700-5903');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (23, 40, 'Rhianna', 'McDaid', 'rmcdaid2@pbs.org', '515-971-7170');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (24, 48, 'Worthington', 'Hagger', 'whagger3@scientificamerican.com', '733-761-3893');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (25, 45, 'Milzie', 'Tash', 'mtash4@gov.uk', '389-329-5064');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (26, 23, 'Roderick', 'Riddell', 'rriddell5@cbc.ca', '977-592-3315');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (27, 26, 'Rakel', 'Twelves', 'rtwelves6@usa.gov', '320-750-7347');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (28, 1, 'Cornelia', 'Suddell', 'csuddell7@upenn.edu', '766-707-9703');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (29, 22, 'Shandee', 'Dilworth', 'sdilworth8@oaic.gov.au', '935-606-6102');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (30, 6, 'Isacco', 'MacCarroll', 'imaccarroll9@gravatar.com', '407-695-4127');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (31, 44, 'Lorianna', 'Greet', 'lgreeta@imdb.com', '392-233-7148');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (32, 37, 'Raleigh', 'Blyth', 'rblythb@mlb.com', '639-912-9319');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (33, 21, 'Konstantine', 'Giron', 'kgironc@symantec.com', '758-323-7281');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (34, 37, 'Genevieve', 'Bilton', 'gbiltond@globo.com', '743-480-9502');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (35, 4, 'Sonia', 'Edwicker', 'sedwickere@patch.com', '152-879-9913');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (36, 23, 'Leif', 'Gravenall', 'lgravenallf@linkedin.com', '165-936-7773');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (37, 60, 'Zacharia', 'Hurling', 'zhurlingg@clickbank.net', '938-287-3735');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (38, 37, 'Fidel', 'Matasov', 'fmatasovh@issuu.com', '567-105-3701');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (39, 53, 'Mandi', 'Fairn', 'mfairni@miibeian.gov.cn', '816-901-0209');
insert into broker (brokerID, yearsOfExperience, firstName, lastName, email, phoneNumber) values (40, 48, 'Glenn', 'Dadge', 'gdadgej@nytimes.com', '490-670-5950');

insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (1, 'Dionysus', 'Alldis', 'dalldis0@w3.org', '757-771-1119', 46, '6 Rusk Road', 'Norfolk', 'VA', '23509', '8');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (2, 'Lancelot', 'Doveston', 'ldoveston1@google.com.hk', '404-537-7643', 18, '706 Karstens Circle', 'Atlanta', 'GA', '31106', '20');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (3, 'Elroy', 'Cubbino', 'ecubbino2@etsy.com', '612-314-0456', 43, '3470 Manufacturers Way', 'Minneapolis', 'MN', '55441', '17');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (4, 'Aguistin', 'Goodbar', 'agoodbar3@indiegogo.com', '862-691-3317', 13, '88592 Lien Point', 'Newark', 'NJ', '07188', '7');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (5, 'Jennifer', 'Pestell', 'jpestell4@wsj.com', '727-588-3265', 27, '4 Daystar Way', 'Saint Petersburg', 'FL', '33742', '11');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (6, 'Shayna', 'Boate', 'sboate5@senate.gov', '510-502-4844', 8, '7730 Butternut Point', 'Oakland', 'CA', '94622', '13');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (7, 'Reinhold', 'Runciman', 'rrunciman6@youku.com', '915-916-4597', 18, '56 Armistice Crossing', 'El Paso', 'TX', '79928', '6');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (8, 'Riley', 'Basler', 'rbasler7@smugmug.com', '775-660-1110', 19, '8 Crownhardt Park', 'Reno', 'NV', '89510', '18');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (9, 'Lira', 'Chiswell', 'lchiswell8@reuters.com', '214-271-2065', 26, '43651 Helena Park', 'Dallas', 'TX', '75397', '10');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (10, 'Jandy', 'Skottle', 'jskottle9@icq.com', '814-678-3196', 54, '0631 Monica Place', 'Erie', 'PA', '16565', '12');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (11, 'Ulises', 'Melluish', 'umelluisha@youku.com', '209-738-9205', 1, '72 Sloan Way', 'Fresno', 'CA', '93715', '1');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (12, 'Carlynne', 'Latus', 'clatusb@google.pl', '419-644-0714', 3, '420 Talmadge Terrace', 'Toledo', 'OH', '43699', '9');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (13, 'Leoine', 'Steger', 'lstegerc@zimbio.com', '610-517-8355', 56, '8692 Bowman Lane', 'Reading', 'PA', '19605', '2');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (14, 'Stesha', 'Fuzzens', 'sfuzzensd@state.gov', '480-918-9130', 3, '72863 Roxbury Pass', 'Chandler', 'AZ', '85246', '16');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (15, 'Jean', 'Castanyer', 'jcastanyere@dion.ne.jp', '414-950-2869', 25, '24 Hooker Hill', 'Milwaukee', 'WI', '53220', '3');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (16, 'Pearce', 'Cuzen', 'pcuzenf@forbes.com', '480-489-2787', 10, '4 Dawn Terrace', 'Tempe', 'AZ', '85284', '19');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (17, 'Clint', 'Aitcheson', 'caitchesong@hostgator.com', '801-373-6934', 26, '7 Oriole Lane', 'Salt Lake City', 'UT', '84199', '4');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (18, 'Danette', 'Davern', 'ddavernh@ask.com', '314-372-6412', 55, '894 Meadow Vale Place', 'Saint Louis', 'MO', '63150', '5');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (19, 'Louie', 'Symmons', 'lsymmonsi@behance.net', '516-740-5285', 32, '7 Mcguire Hill', 'Port Washington', 'NY', '11054', '14');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (20, 'Brantley', 'Klaesson', 'bklaessonj@newyorker.com', '970-666-6112', 23, '8916 Kipling Parkway', 'Fort Collins', 'CO', '80525', '15');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (21, 'Zechariah', 'Meffin', 'zmeffin0@ibm.com', '805-621-7333', 54, '1 Harper Circle', 'San Mateo', 'CA', '94405', '10');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (22, 'Ryan', 'Dayborne', 'rdayborne1@wikispaces.com', '914-826-9492', 41, '0 Clove Point', 'White Plains', 'NY', '10606', '18');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (23, 'Verna', 'Cordet', 'vcordet2@rediff.com', '503-961-0515', 39, '103 Birchwood Crossing', 'Salem', 'OR', '97306', '24');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (24, 'Adele', 'Ballchin', 'aballchin3@cafepress.com', '415-999-4120', 46, '907 Lakewood Gardens Street', 'San Francisco', 'CA', '94142', '40');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (25, 'Licha', 'Got', 'lgot4@ox.ac.uk', '212-717-7512', 33, '838 Del Sol Hill', 'New York City', 'NY', '10275', '29');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (26, 'Guilbert', 'Frewer', 'gfrewer5@cpanel.net', '605-893-6254', 2, '95 Sachs Drive', 'Sioux Falls', 'SD', '57188', '1');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (27, 'Gabie', 'Clench', 'gclench6@webnode.com', '941-707-0551', 8, '3 Grasskamp Drive', 'Port Charlotte', 'FL', '33954', '12');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (28, 'Corbett', 'Harral', 'charral7@moonfruit.com', '202-379-6665', 23, '3837 Manley Plaza', 'Washington', 'DC', '20022', '30');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (29, 'Bobbe', 'Lattie', 'blattie8@mozilla.org', '216-397-6167', 3, '8982 Mockingbird Lane', 'Cleveland', 'OH', '44197', '25');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (30, 'Anabella', 'Dennison', 'adennison9@lulu.com', '702-598-3593', 0, '6 Westport Plaza', 'North Las Vegas', 'NV', '89036', '31');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (31, 'Martita', 'MacNulty', 'mmacnultya@sciencedaily.com', '406-441-3986', 0, '4 Mayfield Park', 'Missoula', 'MT', '59806', '15');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (32, 'Lexy', 'Schapero', 'lschaperob@geocities.com', '205-969-5710', 46, '8 Becker Park', 'Birmingham', 'AL', '35295', '27');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (33, 'Charmain', 'Gauden', 'cgaudenc@cbsnews.com', '213-530-8140', 23, '3047 Clyde Gallagher Lane', 'Van Nuys', 'CA', '91499', '12');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (34, 'Emilio', 'Coniff', 'econiffd@tripadvisor.com', '817-993-1098', 59, '92272 Union Center', 'Fort Worth', 'TX', '76129', '16');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (35, 'Jamie', 'Erik', 'jerike@hc360.com', '512-980-2625', 18, '552 Sachtjen Pass', 'Austin', 'TX', '78732', '7');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (36, 'Dante', 'Branthwaite', 'dbranthwaitef@sciencedaily.com', '937-780-5449', 4, '45361 Haas Park', 'Dayton', 'OH', '45432', '14');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (37, 'Trstram', 'Ballach', 'tballachg@nydailynews.com', '702-804-9069', 44, '02 Vahlen Way', 'Las Vegas', 'NV', '89178', '8');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (38, 'Estele', 'Maruska', 'emaruskah@bandcamp.com', '661-635-6741', 31, '3 Westerfield Hill', 'Burbank', 'CA', '91520', '36');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (39, 'Cord', 'Langer', 'clangeri@google.co.uk', '304-218-0234', 33, '57070 Daystar Circle', 'Charleston', 'WV', '25336', '29');
insert into agent (agentID, firstName, lastName, email, phoneNumber, yearsOfExperience, officeStreet, officeCity, officeState, officeZip, brokerID) values (40, 'Colline', 'Stainson', 'cstainsonj@xinhuanet.com', '626-774-8883', 7, '79756 Ruskin Trail', 'Pasadena', 'CA', '91186', '33');


insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (1, 'Dollie', 'McGaraghan', 'dmcgaraghan0@pcworld.com', '860-812-5672', '180 New Castle Drive', 'Hartford', 'CT', '06152', 1);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (2, 'Polly', 'Lusk', 'plusk1@ted.com', '212-835-8435', '6 Portage Hill', 'New York City', 'NY', '10115', 2);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (3, 'Cordula', 'Eckley', 'ceckley2@deliciousdays.com', '318-487-3718', '3728 Darwin Place', 'Boston', 'MA', '02104', 3);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (4, 'Olav', 'Ryland', 'oryland3@illinois.edu', '636-484-6216', '00021 Artisan Park', 'Saint Louis', 'MO', '63126', 10);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (5, 'Richart', 'Beminster', 'rbeminster4@dot.gov', '814-118-6507', '39 Grasskamp Trail', 'Erie', 'PA', '16534', 1);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (6, 'Liesa', 'Eversfield', 'leversfield5@nydailynews.com', '202-910-1287', '22 Ronald Regan Alley', 'Washington', 'DC', '20520', 8);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (7, 'Welby', 'Corston', 'wcorston6@miibeian.gov.cn', '904-860-1839', '718 Holy Cross Hill', 'Saint Augustine', 'FL', '32092', 8);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (8, 'Meghann', 'Rivitt', 'mrivitt7@ehow.com', '937-755-0360', '1 Sauthoff Alley', 'Hamilton', 'OH', '45020', 12);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (9, 'Ashia', 'Estoile', 'aestoile8@bloglovin.com', '816-606-3292', '9 Haas Way', 'Shawnee Mission', 'KS', '66210', 19);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (10, 'Natala', 'Ballard', 'nballard9@oracle.com', '772-730-8850', '9 Arrowood Terrace', 'Fort Pierce', 'FL', '34949', 1);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (11, 'Koenraad', 'Sparrowhawk', 'ksparrowhawka@weibo.com', '314-772-6101', '889 Forest Way', 'Saint Louis', 'MO', '63158', 18);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (12, 'Budd', 'Gogan', 'bgoganb@ucla.edu', '862-561-8272', '54179 Vermont Avenue', 'Newark', 'NJ', '07188', 14);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (13, 'Kimberly', 'Flett', 'kflettc@gnu.org', '253-666-3255', '025 Daystar Crossing', 'Tacoma', 'WA', '98424', 17);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (14, 'Marv', 'Elsmore', 'melsmored@unc.edu', '225-180-4314', '44 Caliangt Court', 'Baton Rouge', 'LA', '70883', 1);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (15, 'Adora', 'MacCorley', 'amaccorleye@fema.gov', '651-565-7843', '70 Blue Bill Park Junction', 'Saint Paul', 'MN', '55188', 15);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (16, 'Sonnie', 'Durning', 'sdurningf@networksolutions.com', '517-800-4284', '89228 Brentwood Parkway', 'Lansing', 'MI', '48912', 2);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (17, 'Bettina', 'Axton', 'baxtong@studiopress.com', '413-532-5128', '9 Fairfield Hill', 'Springfield', 'MA', '01105', 4);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (18, 'Carmela', 'Coning', 'cconingh@who.int', '401-909-2107', '69810 Meadow Vale Crossing', 'Providence', 'RI', '02912', 1);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (19, 'Cece', 'Huddart', 'chuddarti@360.cn', '405-300-9206', '74 Derek Pass', 'Oklahoma City', 'OK', '73152', 7);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (20, 'Maynord', 'Leyshon', 'mleyshonj@dagondesign.com', '318-513-1509', '31 Norway Maple Lane', 'Monroe', 'LA', '71208', 16);
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (21, 'Roseline', 'Petruska', 'rpetruska0@utexas.edu', '509-783-6522', '59093 Florence Hill', 'Spokane', 'WA', '99205', '11');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (22, 'Fonz', 'Northover', 'fnorthover1@mysql.com', '323-783-4958', '883 Center Street', 'Los Angeles', 'CA', '90076', '16');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (23, 'Wileen', 'Ghiron', 'wghiron2@soundcloud.com', '916-990-0922', '07582 Oak Junction', 'Sacramento', 'CA', '94263', '18');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (24, 'Waite', 'Rable', 'wrable3@sphinn.com', '254-338-9844', '6020 Westport Street', 'Killeen', 'TX', '76544', '4');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (25, 'Ugo', 'Jesson', 'ujesson4@tumblr.com', '301-439-2153', '788 Talmadge Drive', 'Annapolis', 'MD', '21405', '20');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (26, 'Ab', 'Easen', 'aeasen5@i2i.jp', '770-746-7590', '2 Talisman Terrace', 'Atlanta', 'GA', '31119', '14');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (27, 'Emlynn', 'Barnes', 'ebarnes6@miibeian.gov.cn', '317-929-2111', '78192 Mosinee Drive', 'Indianapolis', 'IN', '46216', '2');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (28, 'Glenden', 'Kerr', 'gkerr7@example.com', '508-881-7973', '641 Pine View Terrace', 'Boston', 'MA', '02119', '3');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (29, 'Stormie', 'Corradengo', 'scorradengo8@nps.gov', '281-810-1017', '5511 Novick Center', 'Houston', 'TX', '77025', '1');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (30, 'Amber', 'Booton', 'abooton9@t-online.de', '828-607-2362', '4856 Linden Drive', 'Asheville', 'NC', '28805', '5');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (31, 'Cornela', 'Jost', 'cjosta@sbwire.com', '330-476-1923', '196 Clyde Gallagher Road', 'Canton', 'OH', '44705', '12');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (32, 'Emilie', 'Moulin', 'emoulinb@illinois.edu', '318-114-2572', '94961 Hansons Place', 'Shreveport', 'LA', '71151', '7');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (33, 'Lois', 'Venditti', 'lvendittic@constantcontact.com', '303-529-9515', '69 Burrows Terrace', 'Denver', 'CO', '80228', '6');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (34, 'Maurene', 'Ludwig', 'mludwigd@xinhuanet.com', '530-671-7811', '8 Norway Maple Alley', 'Chico', 'CA', '95973', '9');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (35, 'Brenna', 'Moffet', 'bmoffete@umn.edu', '716-680-4283', '8 Algoma Parkway', 'Buffalo', 'NY', '14276', '19');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (36, 'Guillermo', 'Howlin', 'ghowlinf@prweb.com', '516-181-5605', '5532 North Junction', 'Great Neck', 'NY', '11024', '17');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (37, 'Jackie', 'Werendell', 'jwerendellg@qq.com', '563-380-2233', '9 Marcy Park', 'Davenport', 'IA', '52809', '15');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (38, 'Clifford', 'Pyrton', 'cpyrtonh@webeden.co.uk', '713-603-8913', '24160 Longview Parkway', 'Houston', 'TX', '77245', '8');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (39, 'Pattin', 'Lepick', 'plepicki@surveymonkey.com', '970-520-0169', '007 Sunnyside Hill', 'Grand Junction', 'CO', '81505', '13');
insert into prospectiveBuyer (buyerID, firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) values (40, 'Gerik', 'Timms', 'gtimmsj@studiopress.com', '347-893-6354', '283 Acker Junction', 'Bronx', 'NY', '10469', '10');

insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1311037, 14, 4, 'Huntington', 'WV', '12');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (474910, 1, 9, 'Modesto', 'CA', '11');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1090851, 5, 3, 'Wilmington', 'NC', '6');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1728491, 11, 8, 'Houston', 'TX', '7');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (869596, 1, 8, 'San Antonio', 'TX', '3');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (264648, 1, 0, 'Valley Forge', 'PA', '1');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (403351, 7, 9, 'New York City', 'NY', '18');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (957226, 12, 4, 'Lancaster', 'PA', '13');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1144607, 10, 10, 'Yonkers', 'NY', '20');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (748926, 2, 9, 'Fresno', 'CA', '19');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (115030, 15, 2, 'Winston Salem', 'NC', '10');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1338953, 7, 7, 'Detroit', 'MI', '14');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1332202, 11, 3, 'Knoxville', 'TN', '15');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (784701, 13, 9, 'Bloomington', 'IN', '9');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1541363, 15, 5, 'Peoria', 'IL', '2');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1127212, 6, 2, 'Glendale', 'AZ', '5');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1380149, 7, 9, 'Grand Junction', 'CO', '17');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1063544, 10, 3, 'Terre Haute', 'IN', '16');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (827355, 9, 5, 'Minneapolis', 'MN', '8');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (912243, 11, 9, 'New York City', 'NY', '4');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1006216, 11, 1, 'Washington', 'DC', '21');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1812933, 5, 8, 'El Paso', 'TX', '22');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (196350, 10, 1, 'Bryan', 'TX', '23');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (735042, 6, 9, 'Bozeman', 'MT', '24');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (820448, 7, 7, 'Odessa', 'TX', '25');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (367626, 3, 2, 'Lynchburg', 'VA', '26');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (240085, 0, 1, 'Torrance', 'CA', '27');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1522828, 3, 3, 'Columbus', 'OH', '28');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1879708, 0, 2, 'Tulsa', 'OK', '29');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (220669, 15, 1, 'Dallas', 'TX', '30');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (589986, 4, 9, 'San Francisco', 'CA', '31');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1495921, 11, 8, 'Philadelphia', 'PA', '32');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (668006, 10, 3, 'Detroit', 'MI', '33');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1288325, 5, 8, 'Wichita Falls', 'TX', '34');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1090105, 14, 4, 'Austin', 'TX', '35');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (12531, 12, 5, 'Greensboro', 'NC', '36');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (486448, 7, 9, 'Alexandria', 'LA', '37');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (163902, 1, 3, 'San Jose', 'CA', '38');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1091947, 1, 10, 'Washington', 'DC', '39');
insert into buyerSpecifics (budget , beds, baths, city, state, buyerID) values (1140547, 7, 3, 'Ogden', 'UT', '40');

insert into featuresWishList (buyerID, featuresWishList) values ('2', 'eu est congue elementum in hac habitasse platea dictumst');
insert into featuresWishList (buyerID, featuresWishList) values ('4', 'habitasse platea dictumst maecenas ut');
insert into featuresWishList (buyerID, featuresWishList) values ('16', 'est donec odio');
insert into featuresWishList (buyerID, featuresWishList) values ('1', 'dolor sit amet consectetuer adipiscing elit proin interdum mauris non');
insert into featuresWishList (buyerID, featuresWishList) values ('7', 'ornare imperdiet sapien');
insert into featuresWishList (buyerID, featuresWishList) values ('13', 'ut ultrices');
insert into featuresWishList (buyerID, featuresWishList) values ('19', 'hendrerit at vulputate vitae');
insert into featuresWishList (buyerID, featuresWishList) values ('20', '2 car garage, hardwood floors');
insert into featuresWishList (buyerID, featuresWishList) values ('15', 'semper porta volutpat quam pede lobortis ligula');
insert into featuresWishList (buyerID, featuresWishList) values ('11', 'lectus aliquam sit');
insert into featuresWishList (buyerID, featuresWishList) values ('3', 'metus aenean fermentum');
insert into featuresWishList (buyerID, featuresWishList) values ('5', 'at ipsum ac tellus semper');
insert into featuresWishList (buyerID, featuresWishList) values ('8', 'varius nulla facilisi cras non velit nec');
insert into featuresWishList (buyerID, featuresWishList) values ('14', 'duis bibendum');
insert into featuresWishList (buyerID, featuresWishList) values ('12', 'vitae quam suspendisse potenti nullam porttitor lacus at turpis donec');
insert into featuresWishList (buyerID, featuresWishList) values ('17', 'integer ac');
insert into featuresWishList (buyerID, featuresWishList) values ('10', 'enim blandit mi in porttitor pede justo eu massa');
insert into featuresWishList (buyerID, featuresWishList) values ('6', 'aenean sit');
insert into featuresWishList (buyerID, featuresWishList) values ('9', 'updated kitchen, patio');
insert into featuresWishList (buyerID, featuresWishList) values ('18', 'lobortis ligula sit amet');
insert into featuresWishList (buyerID, featuresWishList) values ('21', 'varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus');
insert into featuresWishList (buyerID, featuresWishList) values ('22', 'sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst');
insert into featuresWishList (buyerID, featuresWishList) values ('23', 'lectus in quam fringilla rhoncus mauris enim leo');
insert into featuresWishList (buyerID, featuresWishList) values ('24', 'rhoncus aliquam lacus morbi quis');
insert into featuresWishList (buyerID, featuresWishList) values ('25', 'neque duis bibendum morbi non quam nec dui luctus');
insert into featuresWishList (buyerID, featuresWishList) values ('26', 'sed accumsan felis ut at');
insert into featuresWishList (buyerID, featuresWishList) values ('27', 'ut erat id mauris vulputate elementum nullam');
insert into featuresWishList (buyerID, featuresWishList) values ('28', 'turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit');
insert into featuresWishList (buyerID, featuresWishList) values ('29', 'erat volutpat in congue');
insert into featuresWishList (buyerID, featuresWishList) values ('30', 'augue vel accumsan tellus nisi eu orci mauris lacinia sapien');
insert into featuresWishList (buyerID, featuresWishList) values ('31', 'quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin');
insert into featuresWishList (buyerID, featuresWishList) values ('32', 'eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum');
insert into featuresWishList (buyerID, featuresWishList) values ('33', 'iaculis diam erat fermentum justo nec');
insert into featuresWishList (buyerID, featuresWishList) values ('34', 'turpis integer aliquet massa id');
insert into featuresWishList (buyerID, featuresWishList) values ('35', 'id');
insert into featuresWishList (buyerID, featuresWishList) values ('36', 'convallis tortor risus dapibus augue vel accumsan tellus nisi');
insert into featuresWishList (buyerID, featuresWishList) values ('37', 'a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt');
insert into featuresWishList (buyerID, featuresWishList) values ('38', 'justo');
insert into featuresWishList (buyerID, featuresWishList) values ('39', 'ridiculus mus vivamus vestibulum');
insert into featuresWishList (buyerID, featuresWishList) values ('40', 'amet nulla quisque arcu');

insert into neighborhood (buyerID, neighborhood) values ('1', 'amet consectetuer adipiscing elit');
insert into neighborhood (buyerID, neighborhood) values ('2', 'rhoncus');
insert into neighborhood (buyerID, neighborhood) values ('3', 'augue vel accumsan');
insert into neighborhood (buyerID, neighborhood) values ('4', 'dolor sit amet consectetuer');
insert into neighborhood (buyerID, neighborhood) values ('5', 'ligula vehicula');
insert into neighborhood (buyerID, neighborhood) values ('6', 'dui');
insert into neighborhood (buyerID, neighborhood) values ('7', 'praesent blandit nam nulla');
insert into neighborhood (buyerID, neighborhood) values ('8', 'montes nascetur');
insert into neighborhood (buyerID, neighborhood) values ('10', 'ipsum');
insert into neighborhood (buyerID, neighborhood) values ('9', 'Nottingham Forest');
insert into neighborhood (buyerID, neighborhood) values ('10', 'purus sit amet');
insert into neighborhood (buyerID, neighborhood) values ('11', 'rhoncus');
insert into neighborhood (buyerID, neighborhood) values ('12', 'sit amet turpis');
insert into neighborhood (buyerID, neighborhood) values ('13', 'interdum venenatis');
insert into neighborhood (buyerID, neighborhood) values ('14', 'turpis integer');
insert into neighborhood (buyerID, neighborhood) values ('15', 'adipiscing molestie hendrerit at');
insert into neighborhood (buyerID, neighborhood) values ('16', 'nullam');
insert into neighborhood (buyerID, neighborhood) values ('17', 'turpis');
insert into neighborhood (buyerID, neighborhood) values ('18', 'pede');
insert into neighborhood (buyerID, neighborhood) values ('19', 'porttitor id consequat');
insert into neighborhood (buyerID, neighborhood) values ('20', 'Blue Hills');
insert into neighborhood (buyerID, neighborhood) values ('22', 'id justo');
insert into neighborhood (buyerID, neighborhood) values ('23', 'lectus suspendisse');
insert into neighborhood (buyerID, neighborhood) values ('24', 'posuere cubilia curae nulla');
insert into neighborhood (buyerID, neighborhood) values ('25', 'eget');
insert into neighborhood (buyerID, neighborhood) values ('26', 'luctus et ultrices posuere');
insert into neighborhood (buyerID, neighborhood) values ('27', 'commodo');
insert into neighborhood (buyerID, neighborhood) values ('28', 'eleifend pede libero');
insert into neighborhood (buyerID, neighborhood) values ('29', 'bibendum morbi');
insert into neighborhood (buyerID, neighborhood) values ('30', 'varius nulla facilisi');
insert into neighborhood (buyerID, neighborhood) values ('31', 'nascetur ridiculus mus');
insert into neighborhood (buyerID, neighborhood) values ('32', 'sit');
insert into neighborhood (buyerID, neighborhood) values ('33', 'praesent blandit');
insert into neighborhood (buyerID, neighborhood) values ('34', 'accumsan tortor quis');
insert into neighborhood (buyerID, neighborhood) values ('35', 'nullam');
insert into neighborhood (buyerID, neighborhood) values ('36', 'faucibus');
insert into neighborhood (buyerID, neighborhood) values ('37', 'platea dictumst');
insert into neighborhood (buyerID, neighborhood) values ('38', 'dis parturient montes nascetur');
insert into neighborhood (buyerID, neighborhood) values ('39', 'non pretium');
insert into neighborhood (buyerID, neighborhood) values ('40', 'nec sem');

insert into propertyType (buyerID, propertyType) values ('1', 'townhome');
insert into propertyType (buyerID, propertyType) values ('2', 'apartment');
insert into propertyType (buyerID, propertyType) values ('3', 'townhome');
insert into propertyType (buyerID, propertyType) values ('4', 'townhome');
insert into propertyType (buyerID, propertyType) values ('5', 'apartment');
insert into propertyType (buyerID, propertyType) values ('6', 'apartment');
insert into propertyType (buyerID, propertyType) values ('7', 'condo');
insert into propertyType (buyerID, propertyType) values ('8', 'house');
insert into propertyType (buyerID, propertyType) values ('9', 'house');
insert into propertyType (buyerID, propertyType) values ('10', 'condo');
insert into propertyType (buyerID, propertyType) values ('11', 'condo');
insert into propertyType (buyerID, propertyType) values ('12', 'townhome');
insert into propertyType (buyerID, propertyType) values ('13', 'condo');
insert into propertyType (buyerID, propertyType) values ('14', 'house');
insert into propertyType (buyerID, propertyType) values ('15', 'townhome');
insert into propertyType (buyerID, propertyType) values ('16', 'apartment');
insert into propertyType (buyerID, propertyType) values ('17', 'condo');
insert into propertyType (buyerID, propertyType) values ('18', 'apartment');
insert into propertyType (buyerID, propertyType) values ('19', 'apartment');
insert into propertyType (buyerID, propertyType) values ('20', 'apartment');
insert into propertyType (buyerID, propertyType) values ('21', 'condo');
insert into propertyType (buyerID, propertyType) values ('22', 'apartment');
insert into propertyType (buyerID, propertyType) values ('23', 'house');
insert into propertyType (buyerID, propertyType) values ('24', 'townhome');
insert into propertyType (buyerID, propertyType) values ('25', 'townhome');
insert into propertyType (buyerID, propertyType) values ('26', 'house');
insert into propertyType (buyerID, propertyType) values ('27', 'apartment');
insert into propertyType (buyerID, propertyType) values ('28', 'house');
insert into propertyType (buyerID, propertyType) values ('29', 'apartment');
insert into propertyType (buyerID, propertyType) values ('30', 'house');
insert into propertyType (buyerID, propertyType) values ('31', 'house');
insert into propertyType (buyerID, propertyType) values ('32', 'apartment');
insert into propertyType (buyerID, propertyType) values ('33', 'condo');
insert into propertyType (buyerID, propertyType) values ('34', 'house');
insert into propertyType (buyerID, propertyType) values ('35', 'condo');
insert into propertyType (buyerID, propertyType) values ('36', 'house');
insert into propertyType (buyerID, propertyType) values ('37', 'condo');
insert into propertyType (buyerID, propertyType) values ('38', 'apartment');
insert into propertyType (buyerID, propertyType) values ('39', 'apartment');
insert into propertyType (buyerID, propertyType) values ('40', 'apartment');

insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (1, 'Active', 535220, 620, '2020-04-04', 1);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (2, 'Pending', 212196, 307, '2020-06-13', 2);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (3, 'Contingent', 287977, 636, '2021-08-26', 5);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (4, 'Contingent', 659686, 672, '2021-10-21', 7);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (5, 'Contingent', 157620, 525, '2021-10-11', 19);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (6, 'Contingent', 332596, 501, '2021-08-22', 13);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (7, 'Under Contract', 776036, 993, '2021-11-15', 20);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (8, 'Active', 146374, 818, '2021-03-30', 1);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (9, 'Under Contract', 302665, 386, '2021-06-19', 11);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (10, 'Active', 531551, 313, '2022-01-17', 4);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (11, 'Pending', 622082, 968, '2020-05-08', 3);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (12, 'Contingent', 373018, 749, '2020-09-09', 1);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (13, 'Under Contract', 532339, 49, '2021-11-28', 11);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (14, 'Contingent', 627609, 167, '2022-02-03', 9);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (15, 'Pending', 51875, 820, '2020-10-23', 10);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (16, 'Active', 731854, 233, '2022-11-19', 1);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (17, 'Active', 800777, 142, '2020-09-07', 18);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (18, 'Pending', 96532, 610, '2022-02-10', 16);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (19, 'Under Contract', 917712, 31, '2022-03-20', 17);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (20, 'Pending', 943176, 754, '2022-03-08', 2);
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (21, 'Under Contract', 98534, 504, '2022-06-24', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (22, 'Under Contract', 184780, 572, '2021-12-18', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (23, 'Active', 19704, 659, '2021-06-11', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (24, 'Pending', 277371, 373, '2021-09-29', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (25, 'Active', 54471, 331, '2022-06-05', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (26, 'Under Contract', 605597, 396, '2022-10-31', '18');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (27, 'Pending', 658656, 654, '2020-12-03', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (28, 'Under Contract', 824436, 300, '2020-11-06', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (29, 'Under Contract', 288531, 141, '2022-03-25', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (30, 'Under Contract', 428419, 41, '2020-03-17', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (31, 'Active', 279392, 303, '2022-05-06', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (32, 'Contingent', 279020, 435, '2022-11-17', '31');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (33, 'Under Contract', 51284, 630, '2020-03-31', '22');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (34, 'Pending', 798467, 71, '2020-10-29', '40');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (35, 'Contingent', 289749, 825, '2020-11-25', '36');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (36, 'Pending', 463029, 278, '2020-10-16', '31');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (37, 'Pending', 617867, 787, '2022-04-04', '27');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (38, 'Pending', 141747, 552, '2022-01-11', '18');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (39, 'Contingent', 698241, 984, '2022-06-15', '29');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (40, 'Contingent', 190084, 885, '2022-02-09', '30');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (41, 'Under Contract', 761935, 621, '2020-11-11', '15');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (42, 'Pending', 290123, 932, '2022-06-30', '19');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (43, 'Contingent', 487620, 538, '2022-10-12', '5');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (44, 'Pending', 187532, 777, '2022-01-07', '12');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (45, 'Contingent', 88456, 69, '2020-04-20', '3');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (46, 'Under Contract', 605989, 183, '2021-01-18', '11');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (47, 'Pending', 760005, 39, '2021-11-15', '6');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (48, 'Under Contract', 92879, 242, '2020-04-24', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (49, 'Pending', 170687, 622, '2020-03-13', '20');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (50, 'Contingent', 510287, 378, '2021-02-22', '7');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (51, 'Pending', 459312, 558, '2021-12-21', '18');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (52, 'Under Contract', 931594, 142, '2022-09-11', '10');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (53, 'Under Contract', 488644, 214, '2021-03-12', '13');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (54, 'Pending', 603486, 117, '2022-01-10', '14');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (55, 'Under Contract', 464904, 433, '2021-04-05', '4');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (56, 'Contingent', 187140, 348, '2020-08-23', '38');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (57, 'Active', 855097, 958, '2022-08-09', '37');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (58, 'Contingent', 287931, 997, '2020-09-21', '26');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (59, 'Contingent', 490432, 495, '2022-11-01', '32');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (60, 'Contingent', 458549, 747, '2022-09-18', '39');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (61, 'Under Contract', 603701, 675, '2022-09-22', '29');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (62, 'Active', 631624, 617, '2022-02-13', '3');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (63, 'Active', 876465, 667, '2021-10-17', '15');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (64, 'Active', 692791, 238, '2022-06-09', '7');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (65, 'Active', 747642, 160, '2020-10-23', '18');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (66, 'Pending', 810945, 456, '2020-10-14', '17');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (67, 'Active', 562911, 767, '2022-03-15', '12');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (68, 'Contingent', 726993, 187, '2022-07-13', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (69, 'Contingent', 200168, 800, '2022-06-03', '6');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (70, 'Active', 506171, 831, '2020-05-05', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (71, 'Pending', 304850, 116, '2020-12-14', '16');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (72, 'Contingent', 748684, 74, '2022-11-12', '5');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (73, 'Contingent', 741822, 840, '2022-06-21', '4');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (74, 'Active', 332167, 212, '2020-03-29', '11');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (75, 'Active', 421248, 63, '2021-04-07', '20');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (76, 'Contingent', 501551, 983, '2022-05-16', '10');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (77, 'Contingent', 699253, 370, '2022-03-04', '13');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (78, 'Contingent', 751320, 54, '2021-05-13', '2');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (79, 'Active', 751015, 964, '2021-07-10', '14');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (80, 'Active', 872017, 347, '2021-12-14', '9');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (81, 'Under Contract', 644640, 477, '2020-08-07', '11');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (82, 'Pending', 532982, 604, '2020-11-14', '2');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (83, 'Contingent', 843619, 760, '2021-04-04', '1');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (84, 'Active', 881806, 221, '2020-06-20', '6');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (85, 'Active', 430912, 482, '2022-07-22', '16');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (86, 'Under Contract', 970651, 221, '2020-11-09', '10');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (87, 'Pending', 377701, 433, '2021-09-14', '4');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (88, 'Under Contract', 937497, 994, '2022-04-02', '13');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (89, 'Under Contract', 648156, 629, '2022-02-28', '7');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (90, 'Active', 647693, 20, '2021-08-09', '12');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (91, 'Active', 929294, 701, '2021-12-06', '20');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (92, 'Pending', 824458, 877, '2021-05-07', '5');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (93, 'Active', 842443, 279, '2022-03-16', '14');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (94, 'Pending', 868660, 647, '2022-02-02', '17');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (95, 'Under Contract', 820280, 815, '2022-01-14', '18');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (96, 'Under Contract', 841868, 580, '2020-07-14', '8');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (97, 'Pending', 836091, 80, '2021-03-27', '3');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (98, 'Contingent', 49489, 126, '2021-08-15', '9');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (99, 'Pending', 460108, 486, '2021-02-06', '15');
insert into activeListing (listingID, status, askingPrice, daysOnMarket, listingDate, agentID) values (100, 'Active', 537143, 456, '2021-07-12', '19');

insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (1, 'Andy', 'Ivatt', 'aivatt0@dagondesign.com', '463-498-9319', '1', '14');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (2, 'Ivie', 'Elderbrant', 'ielderbrant1@utexas.edu', '274-344-5021', '12', '8');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (3, 'Griffith', 'Mapstone', 'gmapstone2@mlb.com', '462-474-4061', '18', '3');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (4, 'Leslie', 'Peal', 'lpeal3@qq.com', '225-570-1060', '16', '18');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (5, 'Oliver', 'Giacoboni', 'ogiacoboni4@comcast.net', '983-271-4837', '7', '5');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (6, 'Norina', 'Lezemore', 'nlezemore5@fastcompany.com', '515-202-8993', '20', '13');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (7, 'Carey', 'Patkin', 'cpatkin6@mayoclinic.com', '935-497-3928', '6', '16');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (8, 'Rolph', 'Pavey', 'rpavey7@europa.eu', '285-520-9275', '15', '1');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (9, 'Dee', 'Johnston', 'djohnston8@privacy.gov.au', '462-414-9613', '8', '12');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (10, 'Suzy', 'Synnott', 'ssynnott9@irs.gov', '129-246-3709', '14', '10');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (11, 'Codi', 'Flucks', 'cflucksa@networkadvertising.org', '898-465-1433', '11', '17');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (12, 'Courtnay', 'Goodoune', 'cgoodouneb@ftc.gov', '439-312-6075', '19', '15');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (13, 'Delcina', 'Cultcheth', 'dcultchethc@issuu.com', '900-785-4318', '13', '11');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (14, 'Rebekah', 'Musgrave', 'rmusgraved@telegraph.co.uk', '568-188-6260', '10', '4');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (15, 'Swen', 'Hamlin', 'shamline@ameblo.jp', '211-317-5232', '2', '9');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (16, 'Neddie', 'Yakubovich', 'nyakubovichf@technorati.com', '385-360-0286', '5', '2');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (17, 'Hartwell', 'McCathay', 'hmccathayg@quantcast.com', '518-606-7048', '3', '19');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (18, 'Sayre', 'Dooney', 'sdooneyh@statcounter.com', '116-363-8110', '17', '20');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (19, 'Gabi', 'Parsell', 'gparselli@hibu.com', '105-965-8952', '9', '7');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (20, 'Iorgo', 'Hay', 'ihayj@ameblo.jp', '625-907-5634', '4', '6');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (21, 'Taddeo', 'Dines', 'tdines0@fc2.com', '253-398-2567', '20', '2');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (22, 'Yehudit', 'Gogin', 'ygogin1@geocities.jp', '232-966-7492', '11', '19');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (23, 'Conny', 'Gladhill', 'cgladhill2@bandcamp.com', '317-905-9340', '13', '13');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (24, 'Kalie', 'Weldon', 'kweldon3@parallels.com', '808-383-9483', '12', '14');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (25, 'Cass', 'Kobu', 'ckobu4@accuweather.com', '808-971-3260', '5', '17');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (26, 'Mair', 'Chaim', 'mchaim5@geocities.com', '241-616-9307', '15', '1');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (27, 'Aubry', 'Bennell', 'abennell6@unesco.org', '991-700-9077', '10', '5');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (28, 'Shirline', 'Regnard', 'sregnard7@mozilla.org', '554-664-9644', '18', '18');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (29, 'Hakim', 'Redfern', 'hredfern8@jiathis.com', '534-371-9616', '3', '6');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (30, 'Neal', 'Hurton', 'nhurton9@youtu.be', '566-266-5419', '19', '11');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (31, 'Bogart', 'Tremollet', 'btremolleta@ow.ly', '369-845-2830', '1', '16');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (32, 'Rozalin', 'Bullon', 'rbullonb@list-manage.com', '200-162-2749', '17', '9');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (33, 'Fran', 'Rendle', 'frendlec@vistaprint.com', '274-204-9777', '6', '12');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (34, 'Arlie', 'McShea', 'amcshead@blogs.com', '854-316-7722', '14', '10');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (35, 'Mildred', 'Crop', 'mcrope@123-reg.co.uk', '960-399-7881', '8', '3');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (36, 'Eleen', 'Dymond', 'edymondf@myspace.com', '680-338-2408', '4', '4');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (37, 'Celinka', 'Secombe', 'csecombeg@geocities.com', '439-241-6156', '9', '8');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (38, 'Mame', 'Waddie', 'mwaddieh@constantcontact.com', '648-386-0210', '16', '7');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (39, 'Maryann', 'Chell', 'mchelli@csmonitor.com', '285-928-5642', '7', '15');
insert into propertyOwner (ownerID, firstName, lastName, email, phoneNumber, listingID, agentID) values (40, 'Marylin', 'Treadgold', 'mtreadgoldj@example.com', '679-944-7498', '2', '20');

insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (1, '2021-02-22', 3, 2597156, 783, '7', '5');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (2, '2022-08-02', 5, 3599762, 425, '5', '15');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (3, '2022-09-10', 6, 2263103, 938, '12', '13');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (4, '2022-02-03', 5, 3264036, 19, '1', '4');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (5, '2020-04-29', 8, 4725214, 116, '16', '8');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (6, '2020-07-11', 2, 4531889, 160, '11', '14');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (7, '2021-05-11', 1, 4630195, 320, '17', '12');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (8, '2022-05-10', 6, 2852521, 854, '19', '18');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (9, '2021-08-29', 5, 3095996, 682, '18', '19');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (10, '2021-11-06', 4, 3174238, 813, '15', '17');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (11, '2022-05-05', 3, 4857358, 728, '3', '16');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (12, '2022-05-12', 4, 4155067, 69, '14', '11');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (13, '2021-12-26', 3, 324881, 143, '2', '1');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (14, '2021-01-01', 5, 3354759, 901, '13', '10');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (15, '2022-09-15', 1, 3533640, 704, '8', '20');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (16, '2021-08-01', 5, 529548, 152, '4', '3');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (17, '2020-10-04', 2, 2576812, 942, '6', '6');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (18, '2020-04-27', 10, 445616, 95, '10', '7');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (19, '2021-08-13', 6, 324903, 626, '9', '2');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (20, '2022-11-04', 1, 3879992, 984, '20', '9');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (21, '2021-12-19', 8, 2866390, 518, '12', '33');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (22, '2020-10-23', 5, 4544524, 228, '2', '24');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (23, '2020-03-13', 7, 4513257, 585, '17', '21');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (24, '2022-09-29', 7, 4807981, 802, '19', '31');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (25, '2021-01-13', 3, 4878365, 375, '1', '25');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (26, '2022-01-11', 1, 2776623, 362, '18', '4');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (27, '2020-03-09', 8, 3929681, 889, '9', '8');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (28, '2020-12-22', 7, 1339526, 652, '4', '1');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (29, '2021-05-20', 5, 3897397, 781, '3', '36');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (30, '2020-05-09', 9, 3935461, 605, '7', '39');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (31, '2021-02-01', 8, 3560572, 899, '8', '17');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (32, '2020-09-15', 6, 738391, 906, '20', '35');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (33, '2021-09-26', 9, 1108998, 597, '15', '28');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (34, '2021-03-13', 8, 3784852, 614, '6', '26');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (35, '2020-05-05', 6, 2802856, 383, '16', '27');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (36, '2021-01-22', 4, 2029737, 687, '11', '32');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (37, '2021-05-13', 3, 2646089, 90, '10', '6');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (38, '2020-06-04', 6, 454709, 891, '14', '13');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (39, '2022-01-06', 3, 4346377, 729, '5', '9');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (40, '2022-01-25', 7, 3092971, 179, '13', '11');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (41, '2022-07-15', 10, 4549370, 728, '20', '28');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (42, '2021-03-30', 4, 1415851, 524, '15', '7');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (43, '2021-06-26', 4, 3641930, 707, '8', '39');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (44, '2020-10-08', 4, 1311704, 362, '1', '23');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (45, '2022-03-09', 9, 1543173, 376, '11', '40');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (46, '2020-05-10', 2, 4964761, 725, '10', '32');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (47, '2021-02-05', 6, 4078293, 585, '12', '10');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (48, '2020-09-22', 8, 311683, 515, '4', '18');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (49, '2020-10-14', 7, 2033924, 954, '2', '24');
insert into soldListing (soldID, sellDate, commission, sellPrice, daysOnMarket, buyerID, agentID) values (50, '2020-03-28', 9, 4661897, 491, '14', '25');


insert into favoriteListing (listingID, buyerID) values ('18', '8');
insert into favoriteListing (listingID, buyerID) values ('14', '20');
insert into favoriteListing (listingID, buyerID) values ('1', '16');
insert into favoriteListing (listingID, buyerID) values ('8', '17');
insert into favoriteListing (listingID, buyerID) values ('5', '15');
insert into favoriteListing (listingID, buyerID) values ('6', '2');
insert into favoriteListing (listingID, buyerID) values ('9', '6');
insert into favoriteListing (listingID, buyerID) values ('11', '9');
insert into favoriteListing (listingID, buyerID) values ('3', '4');
insert into favoriteListing (listingID, buyerID) values ('17', '12');
insert into favoriteListing (listingID, buyerID) values ('10', '10');
insert into favoriteListing (listingID, buyerID) values ('12', '20');
insert into favoriteListing (listingID, buyerID) values ('19', '9');
insert into favoriteListing (listingID, buyerID) values ('13', '14');
insert into favoriteListing (listingID, buyerID) values ('7', '7');
insert into favoriteListing (listingID, buyerID) values ('20', '5');
insert into favoriteListing (listingID, buyerID) values ('16', '20');
insert into favoriteListing (listingID, buyerID) values ('4', '18');
insert into favoriteListing (listingID, buyerID) values ('15', '19');
insert into favoriteListing (listingID, buyerID) values ('2', '11');
insert into favoriteListing (listingID, buyerID) values ('6', '10');
insert into favoriteListing (listingID, buyerID) values ('14', '4');
insert into favoriteListing (listingID, buyerID) values ('19', '1');
insert into favoriteListing (listingID, buyerID) values ('7', '37');
insert into favoriteListing (listingID, buyerID) values ('11', '2');
insert into favoriteListing (listingID, buyerID) values ('8', '9');
insert into favoriteListing (listingID, buyerID) values ('15', '20');
insert into favoriteListing (listingID, buyerID) values ('4', '8');
insert into favoriteListing (listingID, buyerID) values ('20', '17');
insert into favoriteListing (listingID, buyerID) values ('17', '15');
insert into favoriteListing (listingID, buyerID) values ('10', '33');
insert into favoriteListing (listingID, buyerID) values ('1', '29');
insert into favoriteListing (listingID, buyerID) values ('18', '12');
insert into favoriteListing (listingID, buyerID) values ('16', '5');
insert into favoriteListing (listingID, buyerID) values ('2', '20');
insert into favoriteListing (listingID, buyerID) values ('3', '19');
insert into favoriteListing (listingID, buyerID) values ('12', '36');
insert into favoriteListing (listingID, buyerID) values ('5', '24');
insert into favoriteListing (listingID, buyerID) values ('9', '9');
insert into favoriteListing (listingID, buyerID) values ('13', '20');
insert into favoriteListing (listingID, buyerID) values ('7', '18');
insert into favoriteListing (listingID, buyerID) values ('5', '6');
insert into favoriteListing (listingID, buyerID) values ('2', '17');
insert into favoriteListing (listingID, buyerID) values ('1', '7');
insert into favoriteListing (listingID, buyerID) values ('16', '3');
insert into favoriteListing (listingID, buyerID) values ('6', '31');
insert into favoriteListing (listingID, buyerID) values ('11', '14');
insert into favoriteListing (listingID, buyerID) values ('15', '29');
insert into favoriteListing (listingID, buyerID) values ('9', '25');
insert into favoriteListing (listingID, buyerID) values ('18', '40');
insert into favoriteListing (listingID, buyerID) values ('20', '40');
insert into favoriteListing (listingID, buyerID) values ('3', '2');
insert into favoriteListing (listingID, buyerID) values ('17', '19');
insert into favoriteListing (listingID, buyerID) values ('4', '35');
insert into favoriteListing (listingID, buyerID) values ('10', '38');
insert into favoriteListing (listingID, buyerID) values ('12', '26');
insert into favoriteListing (listingID, buyerID) values ('14', '21');
insert into favoriteListing (listingID, buyerID) values ('13', '35');
insert into favoriteListing (listingID, buyerID) values ('19', '39');
insert into favoriteListing (listingID, buyerID) values ('8', '13');
insert into favoriteListing (listingID, buyerID) values ('9', '8');
insert into favoriteListing (listingID, buyerID) values ('11', '11');
insert into favoriteListing (listingID, buyerID) values ('16', '37');
insert into favoriteListing (listingID, buyerID) values ('1', '17');
insert into favoriteListing (listingID, buyerID) values ('13', '22');
insert into favoriteListing (listingID, buyerID) values ('10', '39');
insert into favoriteListing (listingID, buyerID) values ('15', '26');
insert into favoriteListing (listingID, buyerID) values ('5', '10');
insert into favoriteListing (listingID, buyerID) values ('4', '30');
insert into favoriteListing (listingID, buyerID) values ('18', '19');
insert into favoriteListing (listingID, buyerID) values ('9', '4');
insert into favoriteListing (listingID, buyerID) values ('28', '13');
insert into favoriteListing (listingID, buyerID) values ('20', '7');
insert into favoriteListing (listingID, buyerID) values ('4', '15');
insert into favoriteListing (listingID, buyerID) values ('7', '8');
insert into favoriteListing (listingID, buyerID) values ('17', '14');
insert into favoriteListing (listingID, buyerID) values ('93', '20');
insert into favoriteListing (listingID, buyerID) values ('11', '12');
insert into favoriteListing (listingID, buyerID) values ('19', '10');
insert into favoriteListing (listingID, buyerID) values ('15', '18');
insert into favoriteListing (listingID, buyerID) values ('14', '19');
insert into favoriteListing (listingID, buyerID) values ('5', '1');
insert into favoriteListing (listingID, buyerID) values ('10', '2');
insert into favoriteListing (listingID, buyerID) values ('2', '9');
insert into favoriteListing (listingID, buyerID) values ('3', '16');
insert into favoriteListing (listingID, buyerID) values ('1', '6');
insert into favoriteListing (listingID, buyerID) values ('18', '17');
insert into favoriteListing (listingID, buyerID) values ('16', '30');
insert into favoriteListing (listingID, buyerID) values ('12', '5');
insert into favoriteListing (listingID, buyerID) values ('26', '11');
insert into favoriteListing (listingID, buyerID) values ('65', '14');
insert into favoriteListing (listingID, buyerID) values ('69', '19');
insert into favoriteListing (listingID, buyerID) values ('55', '7');
insert into favoriteListing (listingID, buyerID) values ('43', '11');
insert into favoriteListing (listingID, buyerID) values ('87', '10');
insert into favoriteListing (listingID, buyerID) values ('90', '18');
insert into favoriteListing (listingID, buyerID) values ('88', '1');
insert into favoriteListing (listingID, buyerID) values ('77', '15');
insert into favoriteListing (listingID, buyerID) values ('72', '9');
insert into favoriteListing (listingID, buyerID) values ('50', '6');
insert into favoriteListing (listingID, buyerID) values ('99', '17');
insert into favoriteListing (listingID, buyerID) values ('100', '4');
insert into favoriteListing (listingID, buyerID) values ('56', '20');
insert into favoriteListing (listingID, buyerID) values ('100', '16');
insert into favoriteListing (listingID, buyerID) values ('91', '3');
insert into favoriteListing (listingID, buyerID) values ('92', '5');
insert into favoriteListing (listingID, buyerID) values ('93', '12');
insert into favoriteListing (listingID, buyerID) values ('57', '2');
insert into favoriteListing (listingID, buyerID) values ('58', '13');
insert into favoriteListing (listingID, buyerID) values ('59', '8');
insert into favoriteListing (listingID, buyerID) values ('60', '20');
insert into favoriteListing (listingID, buyerID) values ('61', '16');
insert into favoriteListing (listingID, buyerID) values ('62', '15');
insert into favoriteListing (listingID, buyerID) values ('63', '10');
insert into favoriteListing (listingID, buyerID) values ('64', '1');
insert into favoriteListing (listingID, buyerID) values ('65', '11');
insert into favoriteListing (listingID, buyerID) values ('67', '9');
insert into favoriteListing (listingID, buyerID) values ('68', '17');
insert into favoriteListing (listingID, buyerID) values ('69', '8');
insert into favoriteListing (listingID, buyerID) values ('100', '19');
insert into favoriteListing (listingID, buyerID) values ('19', '2');
insert into favoriteListing (listingID, buyerID) values ('4', '7');
insert into favoriteListing (listingID, buyerID) values ('8', '5');
insert into favoriteListing (listingID, buyerID) values ('2', '6');
insert into favoriteListing (listingID, buyerID) values ('98', '13');
insert into favoriteListing (listingID, buyerID) values ('64', '4');
insert into favoriteListing (listingID, buyerID) values ('93', '3');
insert into favoriteListing (listingID, buyerID) values ('95', '14');
insert into favoriteListing (listingID, buyerID) values ('81', '12');
insert into favoriteListing (listingID, buyerID) values ('85', '18');
insert into favoriteListing (listingID, buyerID) values ('82', '20');
insert into favoriteListing (listingID, buyerID) values ('91', '39');
insert into favoriteListing (listingID, buyerID) values ('61', '38');
insert into favoriteListing (listingID, buyerID) values ('59', '19');
insert into favoriteListing (listingID, buyerID) values ('44', '7');
insert into favoriteListing (listingID, buyerID) values ('43', '36');
insert into favoriteListing (listingID, buyerID) values ('47', '22');
insert into favoriteListing (listingID, buyerID) values ('22', '40');
insert into favoriteListing (listingID, buyerID) values ('30', '38');
insert into favoriteListing (listingID, buyerID) values ('12', '25');
insert into favoriteListing (listingID, buyerID) values ('37', '24');
insert into favoriteListing (listingID, buyerID) values ('29', '24');
insert into favoriteListing (listingID, buyerID) values ('40', '9');
insert into favoriteListing (listingID, buyerID) values ('32', '20');
insert into favoriteListing (listingID, buyerID) values ('38', '9');
insert into favoriteListing (listingID, buyerID) values ('29', '11');
insert into favoriteListing (listingID, buyerID) values ('21', '20');
insert into favoriteListing (listingID, buyerID) values ('5', '22');
insert into favoriteListing (listingID, buyerID) values ('4', '21');
insert into favoriteListing (listingID, buyerID) values ('6', '26');

insert into areaOfExpertise (agentID, areaOfExpertise) values ('1', 'luxury real estate');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('2', 'phasellus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('3', 'suspendisse ornare');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('4', 'tellus semper interdum mauris');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('5', 'luctus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('6', 'nulla');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('7', 'in felis eu sapien');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('8', 'new constructions');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('9', 'cursus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('10', 'vel nulla eget eros elementum');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('11', 'vivamus tortor');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('12', 'eget semper rutrum nulla');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('13', 'duis bibendum felis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('14', 'in sagittis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('15', 'amet sapien');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('16', 'leo odio');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('17', 'ipsum');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('18', 'mus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('19', 'ut nunc vestibulum ante');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('20', 'vestibulum vestibulum ante');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('21', 'ante ipsum primis in faucibus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('22', 'duis bibendum felis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('23', 'amet nunc viverra');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('24', 'tortor duis mattis egestas');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('25', 'nunc commodo placerat praesent');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('26', 'aliquam');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('27', 'ac');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('28', 'posuere metus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('29', 'non velit nec nisi vulputate');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('30', 'sit');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('31', 'convallis eget eleifend');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('32', 'turpis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('33', 'ante ipsum');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('34', 'ac neque duis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('35', 'libero nullam sit amet turpis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('36', 'proin at');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('37', 'nullam sit amet');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('38', 'purus phasellus in');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('39', 'etiam');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('40', 'nunc donec quis');

insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('051 Graceland Lane', 'Washington', 'DC', '20036', 5, 8, 1875, 8395, '1');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('146 Westend Crossing', 'Palm Bay', 'FL', '32909', 2, 3, 1940, 17442, '2');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('05725 Tony Avenue', 'Erie', 'PA', '16534', 14, 3, 1942, 18724, '3');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('11 Kensington Road', 'Plano', 'TX', '75074', 1, 6, 1966, 5788, '4');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('96 Moulton Avenue', 'Littleton', 'CO', '80161', 11, 1, 1923, 1182, '5');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('47412 Schurz Drive', 'Des Moines', 'IA', '50330', 3, 6, 1876, 8675, '6');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('91323 Dwight Terrace', 'Washington', 'DC', '20430', 0, 6, 1812, 5900, '7');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('07364 Mandrake Circle', 'Flint', 'MI', '48555', 14, 3, 1859, 11052, '8');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('9 Nancy Terrace', 'Fayetteville', 'NC', '28305', 13, 1, 1879, 19837, '9');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('94 Morningstar Road', 'Charleston', 'SC', '29403', 13, 2, 1848, 6299, '10');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('383 Farmco Avenue', 'Fort Collins', 'CO', '80525', 10, 3, 1906, 3025, '11');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('57644 Emmet Place', 'Richmond', 'VA', '23289', 11, 9, 1840, 5228, '12');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('82088 Saint Paul Point', 'Atlanta', 'GA', '30380', 2, 7, 1809, 3406, '13');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('806 Union Lane', 'Boston', 'MA', '02124', 14, 2, 1934, 17591, '14');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('176 Nevada Road', 'Knoxville', 'TN', '37914', 9, 5, 1854, 11558, '15');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('49369 Petterle Alley', 'Spokane', 'WA', '99220', 15, 4, 1980, 2793, '16');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('971 Sunfield Avenue', 'Cincinnati', 'OH', '45228', 2, 4, 1892, 11431, '17');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('3175 Delaware Junction', 'Irvine', 'CA', '92710', 3, 4, 1969, 7723, '18');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('936 Pine View Court', 'Fargo', 'ND', '58106', 14, 8, 1883, 1634, '19');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('20 Drewry Alley', 'Detroit', 'MI', '48242', 15, 5, 1930, 12574, '20');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('9 Grover Circle', 'Brooklyn', 'NY', '11220', 2, 7, 1961, 6157, '21');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('70339 Del Sol Alley', 'Oakland', 'CA', '94605', 4, 6, 1873, 14258, '22');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('0122 Reindahl Plaza', 'Raleigh', 'NC', '27626', 0, 2, 1805, 5938, '23');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('6 Parkside Way', 'Houston', 'TX', '77206', 2, 3, 1950, 8752, '24');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('2 Hooker Avenue', 'Baton Rouge', 'LA', '70883', 6, 7, 1857, 14234, '25');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('61 Eagle Crest Circle', 'Scranton', 'PA', '18505', 15, 10, 1858, 5553, '26');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('43 Artisan Trail', 'Louisville', 'KY', '40266', 0, 4, 1818, 9457, '27');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('2829 Darwin Junction', 'Washington', 'DC', '20470', 9, 8, 1850, 14678, '28');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('863 Randy Court', 'Atlanta', 'GA', '30328', 7, 2, 1848, 11946, '29');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('043 Lerdahl Trail', 'Mobile', 'AL', '36670', 2, 9, 1801, 4221, '30');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('089 Kingsford Drive', 'New York City', 'NY', '10275', 4, 10, 2021, 6566, '31');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('6 Rockefeller Parkway', 'Anaheim', 'CA', '92825', 6, 3, 1824, 9545, '32');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('52 Tennessee Trail', 'Miami', 'FL', '33261', 2, 6, 1829, 2284, '33');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('69 Delaware Drive', 'Waco', 'TX', '76705', 0, 5, 1993, 13876, '34');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('29993 Jana Crossing', 'Pompano Beach', 'FL', '33075', 9, 8, 2009, 12249, '35');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('2178 Oriole Alley', 'Bakersfield', 'CA', '93386', 7, 6, 1850, 16963, '36');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('077 Hoffman Hill', 'Fort Worth', 'TX', '76198', 11, 4, 1981, 4011, '37');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('12311 Almo Drive', 'Vancouver', 'WA', '98664', 15, 3, 2018, 12035, '38');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('67 Schlimgen Street', 'Anaheim', 'CA', '92805', 5, 1, 2019, 17791, '39');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('60243 Erie Pass', 'New Haven', 'CT', '06538', 3, 4, 1862, 6117, '40');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('9599 Spaight Court', 'Melbourne', 'FL', '32919', 2, 2, 1999, 5875, '41');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('72698 Myrtle Trail', 'Miami', 'FL', '33134', 0, 4, 1935, 15007, '42');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('48 Cascade Point', 'Denver', 'CO', '80299', 10, 2, 1816, 10576, '43');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('83303 Garrison Parkway', 'Houston', 'TX', '77260', 7, 7, 1958, 3057, '44');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('33 Moland Circle', 'Champaign', 'IL', '61825', 10, 8, 1871, 15277, '45');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('39 Meadow Ridge Crossing', 'Bethesda', 'MD', '20816', 3, 6, 1822, 17682, '46');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('448 Badeau Street', 'Young America', 'MN', '55573', 12, 5, 1968, 17701, '47');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('422 Rutledge Way', 'East Saint Louis', 'IL', '62205', 14, 7, 1830, 11307, '48');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('65851 Jenna Way', 'Cheyenne', 'WY', '82007', 2, 2, 1871, 8159, '49');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('038 Pankratz Plaza', 'El Paso', 'TX', '79923', 4, 10, 1963, 3323, '50');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('82 Huxley Pass', 'Littleton', 'CO', '80126', 11, 6, 2008, 1175, '51');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('03 Manley Terrace', 'Mountain View', 'CA', '94042', 15, 7, 1840, 19183, '52');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('91442 Ridgeview Hill', 'Charleston', 'SC', '29403', 3, 8, 1924, 15272, '53');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('76 Stoughton Place', 'Los Angeles', 'CA', '90076', 2, 6, 1816, 5211, '54');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('59 Kenwood Way', 'San Jose', 'CA', '95194', 7, 3, 1846, 15674, '55');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('4 Alpine Crossing', 'Greenville', 'SC', '29615', 6, 7, 1881, 12661, '56');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('75821 Norway Maple Way', 'Kansas City', 'MO', '64109', 4, 4, 1915, 3659, '57');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('980 Arrowood Terrace', 'Anaheim', 'CA', '92805', 1, 3, 1956, 6903, '58');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('15151 Farmco Trail', 'Flint', 'MI', '48550', 15, 5, 1990, 18107, '59');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('62583 Kim Avenue', 'Mobile', 'AL', '36641', 14, 10, 1815, 8934, '60');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('5339 Grim Trail', 'Washington', 'DC', '20310', 0, 2, 1976, 5889, '61');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('2318 Melvin Pass', 'Norman', 'OK', '73071', 3, 8, 1811, 13157, '62');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('46348 Carberry Parkway', 'Bismarck', 'ND', '58505', 4, 3, 2010, 5197, '63');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('33631 Fordem Court', 'Kansas City', 'MO', '64142', 6, 9, 1988, 4672, '64');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('992 Messerschmidt Drive', 'Salt Lake City', 'UT', '84170', 6, 9, 2015, 12418, '65');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8 Fordem Place', 'Phoenix', 'AZ', '85053', 9, 10, 1929, 15749, '66');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('389 Golf Park', 'Tampa', 'FL', '33661', 11, 7, 1958, 5663, '67');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('09 International Pass', 'New Haven', 'CT', '06520', 12, 7, 1854, 18530, '68');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('96 Golden Leaf Avenue', 'Shawnee Mission', 'KS', '66286', 7, 2, 1993, 18882, '69');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('3 Sunnyside Center', 'Ogden', 'UT', '84409', 0, 10, 1800, 8273, '70');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('3 Northland Court', 'Birmingham', 'AL', '35242', 5, 5, 1896, 16828, '71');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8094 Artisan Hill', 'Scottsdale', 'AZ', '85255', 1, 10, 1895, 630, '72');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('28 Florence Parkway', 'Columbus', 'OH', '43210', 8, 6, 2006, 17382, '73');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8 Toban Avenue', 'Montgomery', 'AL', '36114', 5, 9, 1864, 10793, '74');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('28 Maple Wood Terrace', 'Washington', 'DC', '20425', 11, 1, 1910, 9640, '75');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('959 Scott Street', 'Scottsdale', 'AZ', '85271', 15, 1, 1925, 18802, '76');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('14 Walton Pass', 'Houston', 'TX', '77218', 7, 9, 2018, 16644, '77');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('15 Dryden Court', 'Seattle', 'WA', '98109', 11, 1, 1937, 11365, '78');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('44 Hazelcrest Plaza', 'El Paso', 'TX', '79955', 13, 10, 1922, 8918, '79');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('363 Lighthouse Bay Alley', 'Saint Augustine', 'FL', '32092', 7, 2, 1814, 15432, '80');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('370 Bay Hill', 'Corpus Christi', 'TX', '78405', 3, 7, 1872, 11303, '81');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('889 Katie Way', 'Memphis', 'TN', '38197', 14, 1, 1849, 6314, '82');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8 Ronald Regan Pass', 'Fresno', 'CA', '93726', 10, 7, 1919, 12643, '83');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8129 Mayer Circle', 'Jacksonville', 'FL', '32230', 5, 7, 1842, 6337, '84');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8144 Pierstorff Junction', 'Albany', 'NY', '12237', 10, 7, 1848, 6120, '85');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('12243 Park Meadow Center', 'Houston', 'TX', '77060', 2, 2, 1878, 19446, '86');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('871 Arkansas Hill', 'Decatur', 'GA', '30033', 3, 1, 1954, 1612, '87');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('6 Pierstorff Alley', 'Honolulu', 'HI', '96810', 15, 2, 1956, 15365, '88');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('93284 Doe Crossing Street', 'Littleton', 'CO', '80127', 1, 1, 1925, 3644, '89');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('22508 Melrose Hill', 'Milwaukee', 'WI', '53277', 4, 3, 1918, 12491, '90');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('263 Weeping Birch Alley', 'Monticello', 'MN', '55585', 12, 10, 1998, 12418, '91');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('2 Manufacturers Plaza', 'Spartanburg', 'SC', '29305', 3, 4, 1858, 12431, '92');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('7032 Bartillon Lane', 'Waterbury', 'CT', '06705', 8, 2, 1849, 9715, '93');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('674 Commercial Park', 'Austin', 'TX', '78759', 6, 8, 1938, 13935, '94');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('4547 Truax Plaza', 'Palmdale', 'CA', '93591', 8, 5, 1953, 18210, '95');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('20 Longview Avenue', 'Richmond', 'VA', '23228', 9, 8, 1949, 2905, '96');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('8646 Mosinee Way', 'Portland', 'OR', '97211', 0, 8, 1989, 19353, '97');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('4 Michigan Lane', 'Hayward', 'CA', '94544', 7, 6, 1942, 14747, '98');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('391 Rockefeller Plaza', 'Corona', 'CA', '92883', 14, 8, 1834, 13307, '99');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('65 Glacier Hill Junction', 'Houston', 'TX', '77276', 8, 5, 1971, 7569, '100');

insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (1, '11:02:00', '16:35:00', '49435 Kingsford Way', 'Albany', 'NY', '12255', '2022-02-12', '6', '13');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (2, '9:59:00', '13:54:00', '0 Onsgard Plaza', 'Gainesville', 'FL', '32605', '2021-12-02', '10', '5');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (3, '9:28:00', '16:08:00', '9 Oneill Way', 'Salt Lake City', 'UT', '84120', '2022-06-25', '2', '3');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (4, '9:49:00', '15:50:00', '47 Hanson Center', 'Charleston', 'WV', '25331', '2022-10-28', '3', '10');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (5, '8:51:00', '1:02:00', '0 Eliot Park', 'San Diego', 'CA', '92115', '2022-11-29', '19', '17');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (6, '8:21:00', '15:15:00', '17 Sage Avenue', 'Corpus Christi', 'TX', '78475', '2022-10-31', '7', '14');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (7, '10:01:00', '12:34:00', '60042 Stone Corner Trail', 'Torrance', 'CA', '90510', '2022-03-06', '16', '4');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (8, '11:54:00', '16:20:00', '6343 Mayer Park', 'Tucson', 'AZ', '85715', '2022-10-31', '5', '15');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (9, '8:00:00', '12:33:00', '99756 Sutherland Center', 'Houston', 'TX', '77234', '2021-12-08', '18', '7');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (10, '11:09:00', '16:17:00', '697 Acker Crossing', 'Des Moines', 'IA', '50315', '2022-06-30', '8', '1');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (11, '9:14:00', '16:08:00', '6 Mallard Junction', 'Brockton', 'MA', '02305', '2022-02-15', '9', '20');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (12, '8:27:00', '12:51:00', '59497 Columbus Trail', 'Columbus', 'OH', '43284', '2022-10-29', '14', '9');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (13, '8:03:00', '16:51:00', '762 Sundown Drive', 'Metairie', 'LA', '70005', '2022-10-21', '13', '6');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (14, '11:23:00', '16:59:00', '5 Jenifer Avenue', 'Philadelphia', 'PA', '19115', '2021-11-26', '4', '11');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (15, '11:00:00', '16:28:00', '22 Myrtle Drive', 'Fresno', 'CA', '93750', '2022-10-28', '20', '8');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (16, '10:42:00', '16:43:00', '718 Ronald Regan Street', 'Minneapolis', 'MN', '55402', '2022-09-05', '17', '2');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (17, '11:04:00', '13:15:00', '922 Golden Leaf Park', 'Tuscaloosa', 'AL', '35405', '2022-08-31', '9', '16');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (18, '8:44:00', '15:09:00', '20 Ramsey Point', 'Albany', 'NY', '12227', '2022-05-07', '15', '19');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (19, '9:14:00', '12:27:00', '67860 Northland Trail', 'Colorado Springs', 'CO', '80935', '2022-04-27', '11', '12');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (20, '10:50:00', '14:03:00', '759 Doe Crossing Street', 'Mansfield', 'OH', '44905', '2022-03-24', '20', '18');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (21, '10:16:00', '4:55:00', '204 Ronald Regan Plaza', 'Dallas', 'TX', '75310', '2022-09-19', '8', '12');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (22, '11:02:00', '2:20:00', '782 Maryland Terrace', 'Evansville', 'IN', '47719', '2022-11-03', '34', '10');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (23, '8:52:00', '4:56:00', '104 Sunbrook Plaza', 'Chicago', 'IL', '60630', '2022-10-31', '17', '14');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (24, '11:12:00', '1:34:00', '26 Ohio Crossing', 'Springfield', 'IL', '62711', '2022-08-23', '9', '1');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (25, '10:09:00', '3:44:00', '13 Surrey Way', 'Roanoke', 'VA', '24004', '2022-09-23', '11', '17');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (26, '8:56:00', '2:04:00', '68 Hallows Junction', 'Grand Rapids', 'MI', '49505', '2022-09-11', '2', '8');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (27, '10:00:00', '12:54:00', '09359 Bay Circle', 'Appleton', 'WI', '54915', '2022-05-31', '19', '6');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (28, '10:31:00', '2:44:00', '4 Di Loreto Circle', 'Birmingham', 'AL', '35244', '2022-09-15', '9', '39');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (29, '9:28:00', '4:44:00', '87177 Sauthoff Alley', 'Charlotte', 'NC', '28278', '2022-06-07', '3', '27');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (30, '10:13:00', '2:32:00', '8 Shopko Road', 'San Diego', 'CA', '92132', '2022-07-20', '20', '2');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (31, '8:55:00', '4:51:00', '9 Bashford Alley', 'Wilmington', 'DE', '19810', '2022-08-20', '1', '1');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (32, '11:05:00', '1:14:00', '4 East Center', 'Miami', 'FL', '33175', '2022-05-30', '6', '13');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (33, '8:51:00', '3:02:00', '34 Westend Junction', 'Detroit', 'MI', '48258', '2022-05-21', '13', '20');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (34, '9:16:00', '1:27:00', '6167 Luster Drive', 'Riverside', 'CA', '92519', '2022-03-05', '15', '16');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (35, '9:47:00', '1:35:00', '318 High Crossing Parkway', 'Raleigh', 'NC', '27635', '2022-03-26', '4', '19');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (36, '10:52:00', '3:23:00', '263 Magdeline Court', 'Washington', 'DC', '20540', '2022-08-16', '5', '1');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (37, '10:48:00', '12:09:00', '117 Park Meadow Lane', 'Lees Summit', 'MO', '64082', '2022-09-18', '7', '8');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (38, '11:33:00', '12:11:00', '905 Fisk Hill', 'Madison', 'WI', '53726', '2022-11-18', '12', '11');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (39, '8:36:00', '2:23:00', '481 Vermont Alley', 'Schenectady', 'NY', '12325', '2022-11-17', '10', '15');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (40, '9:02:00', '1:00:00', '5 Continental Plaza', 'Toledo', 'OH', '43610', '2021-12-14', '18', '8');

insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (1, 'Four Stars', 'cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor', 'Wilona', 2016, '9');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (2, 'One Star', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec', 'Allyn', 2013, '18');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (3, 'Three Stars', 'curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit', 'Kippar', 2017, '3');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (4, 'Two Stars', 'quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus', 'Cathrine', 2021, '17');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (5, 'One Star', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu', 'Wilton', 2013, '10');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (6, 'Two Stars', 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 'Madella', 2022, '4');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (7, 'Three Stars', 'amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum', 'Denny', 2013, '14');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (8, 'Five Stars', 'leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus', 'Chrystal', 2019, '12');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (9, 'One Star', 'ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', 'Alva', 2019, '1');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (10, 'Three Stars', 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis', 'Sidonia', 2013, '8');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (11, 'Four Stars', 'massa tempor convallis nulla neque libero convallis eget eleifend', 'Sigismundo', 2014, '5');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (12, 'Two Stars', 'dapibus dolor vel est donec odio justo sollicitudin ut suscipit', 'Libby', 2017, '13');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (13, 'Four Stars', 'neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia', 'Elfreda', 2018, '2');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (14, 'Two Stars', 'ut ultrices vel augue vestibulum', 'Marge', 2020, '16');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (15, 'One Star', 'dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac', 'Glen', 2015, '6');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (16, 'Three Stars', 'tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet', 'Elsbeth', 2017, '11');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (17, 'Five Stars', 'ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer', 'Vonnie', 2018, '19');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (18, 'Five Stars', 'sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non', 'Eddy', 2019, '15');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (19, 'Five Stars', 'blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis', 'Lorenzo', 2018, '7');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (20, 'Two Stars', 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse', 'Jerrilee', 2014, '20');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (21, 'Three Stars', 'dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia', 'Donica', 2013, '19');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (22, 'One Star', 'in blandit ultrices enim lorem', 'Idalia', 2012, '14');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (23, 'Five Stars', 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in', 'James', 2015, '3');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (24, 'Five Stars', 'ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in', 'Jacqueline', 2018, '6');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (25, 'Four Stars', 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis', 'Edsel', 2017, '17');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (26, 'One Star', 'nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue', 'Marigold', 2022, '5');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (27, 'Four Stars', 'nam congue risus semper porta volutpat quam pede lobortis ligula', 'Tessie', 2020, '11');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (28, 'Five Stars', 'ut massa volutpat convallis morbi', 'Cort', 2017, '18');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (29, 'Three Stars', 'ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 'Laraine', 2014, '9');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (30, 'Four Stars', 'ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia', 'Beverley', 2012, '1');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (31, 'Five Stars', 'at dolor quis odio consequat varius integer ac', 'Ardelle', 2015, '2');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (32, 'Two Stars', 'dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis', 'Franky', 2019, '10');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (33, 'One Star', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique', 'Anderson', 2020, '15');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (34, 'Three Stars', 'viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero', 'Caty', 2017, '4');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (35, 'Five Stars', 'diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 'Maryanna', 2015, '32');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (36, 'One Star', 'suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper', 'Veronica', 2021, '23');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (37, 'Four Stars', 'odio consequat varius integer ac leo pellentesque ultrices mattis odio donec', 'Mariellen', 2019, '26');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (38, 'Four Stars', 'augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo', 'Laurel', 2014, '20');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (39, 'Two Stars', 'ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 'Carmelia', 2021, '28');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (40, 'Four Stars', 'maecenas tristique est et tempus semper est quam pharetra magna', 'Clarisse', 2022, '37');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (41, 'Two Stars', 'quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum', 'Aguie', 2021, '2');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (42, 'Five Stars', 'vivamus vel nulla eget eros elementum pellentesque quisque porta', 'Moyna', 2012, '21');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (43, 'Four Stars', 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus', 'Adella', 2017, '1');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (44, 'Three Stars', 'eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu', 'Iggy', 2017, '5');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (45, 'Four Stars', 'leo pellentesque ultrices mattis odio donec vitae nisi nam', 'Marjorie', 2019, '14');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (46, 'Three Stars', 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris', 'Anabelle', 2014, '33');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (47, 'Four Stars', 'tempor convallis nulla neque libero convallis eget eleifend luctus', 'Mora', 2014, '3');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (48, 'Two Stars', 'sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis', 'Meggie', 2021, '7');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (49, 'Two Stars', 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius', 'Bordie', 2013, '9');
insert into clientTestimonial (testimonialID, stars, description, firstName, yearCreated, agentID) values (50, 'Four Stars', 'in sagittis dui vel nisl duis ac nibh fusce lacus purus', 'Chelsae', 2019, '39');

insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (1, 'Kiehn LLC', 2019, 306272431, '22 Browning Avenue', 'Tampa', 'FL', '33694', '1');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (2, 'Miller, Predovic and Bergnaum', 1967, 855760392, '6110 Marcy Crossing', 'Chicago', 'IL', '60691', '2');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (3, 'Gutkowski and Sons', 1977, 1477292366, '76460 Towne Road', 'Saint Louis', 'MO', '63126', '3');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (4, 'Adams, Kling and Schulist', 2011, 589712282, '5 Helena Center', 'Stockton', 'CA', '95298', '4');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (5, 'Reynolds-Veum', 1981, 382493140, '92866 Loomis Terrace', 'Punta Gorda', 'FL', '33982', '5');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (6, 'Gusikowski-Hayes', 2012, 1783279466, '58366 Jenna Street', 'Spokane', 'WA', '99215', '6');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (7, 'Herzog Group', 1967, 1675364693, '01534 Pleasure Way', 'Tallahassee', 'FL', '32314', '7');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (8, 'Lind, Hoeger and Feeney', 1994, 130694276, '7974 Morning Drive', 'Wilmington', 'DE', '19897', '8');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (9, 'Pouros Group', 1927, 1897470522, '5507 Daystar Way', 'Houston', 'TX', '77276', '9');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (10, 'Mosciski and Sons', 1978, 340504285, '65 John Wall Circle', 'Miami', 'FL', '33134', '10');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (11, 'Pollich-Hauck', 1939, 1933684749, '085 Erie Place', 'Pittsburgh', 'PA', '15210', '11');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (12, 'Upton, Ratke and Hettinger', 1936, 1123311766, '400 Meadow Valley Avenue', 'Dayton', 'OH', '45419', '12');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (13, 'Gaylord-Goyette', 2004, 1186023913, '31961 Drewry Drive', 'New Haven', 'CT', '06505', '14');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (14, 'Grimes, Abshire and Considine', 2016, 493316070, '72 Hallows Street', 'Saint Louis', 'MO', '63116', '13');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (15, 'Schuppe, Rodriguez and Von', 1982, 117536727, '12 Crownhardt Plaza', 'Hampton', 'VA', '23668', '15');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (16, 'Gislason-Walter', 1947, 913843819, '0132 Lakewood Gardens Lane', 'Austin', 'TX', '78732', '16');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (17, 'Boyer LLC', 2010, 331748087, '510 Transport Pass', 'Sarasota', 'FL', '34233', '17');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (18, 'Abbott, Crist and Leannon', 1974, 39132097, '84 Debs Parkway', 'Boston', 'MA', '02163', '18');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (19, 'Tillman Inc', 1959, 1313338974, '95 Clove Pass', 'Washington', 'DC', '20078', '19');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (20, 'Heathcote, Greenholt and Spinka', 1979, 679824180, '6 Wayridge Center', 'Santa Clara', 'CA', '95054', '20');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (21, 'Zieme, Price and Buckridge', 2018, 708523362, '3597 Magdeline Point', 'Shreveport', 'LA', '71130', '21');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (22, 'Koepp-Pollich', 1941, 15168242, '1920 Annamark Crossing', 'Anaheim', 'CA', '92812', '22');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (23, 'Cartwright, Leuschke and Bernhard', 2017, 1105021754, '16 Valley Edge Street', 'New York City', 'NY', '10029', '23');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (24, 'Franecki and Sons', 2014, 1478452297, '33 Sutherland Way', 'Corpus Christi', 'TX', '78470', '24');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (25, 'Leffler Inc', 2002, 862065448, '51 Hanover Drive', 'Houston', 'TX', '77299', '25');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (26, 'Pagac, Hoeger and Collins', 2019, 1606070208, '18 Roth Drive', 'Arlington', 'VA', '22225', '26');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (27, 'Langworth Inc', 2009, 824940416, '87 Maryland Trail', 'Birmingham', 'AL', '35231', '27');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (28, 'Hoeger, Jacobson and Leannon', 1952, 1727303147, '35 La Follette Alley', 'Winston Salem', 'NC', '27157', '28');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (29, 'Brown, Emard and Denesik', 1945, 912892480, '13308 Maple Road', 'New Orleans', 'LA', '70183', '29');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (30, 'Considine, Lockman and Pfannerstill', 1998, 1513771860, '18575 Briar Crest Pass', 'Huntington', 'WV', '25709', '30');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (31, 'Jacobson-Hilpert', 1959, 1725921158, '53124 Swallow Drive', 'Pittsburgh', 'PA', '15225', '31');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (32, 'Ebert and Sons', 1949, 671482853, '02521 West Road', 'Fort Lauderdale', 'FL', '33305', '32');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (33, 'Grimes, Dietrich and Luettgen', 1998, 825582034, '73 Veith Drive', 'New Orleans', 'LA', '70174', '33');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (34, 'Robel-Parker', 2021, 1471317620, '81 Valley Edge Point', 'Fort Worth', 'TX', '76105', '34');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (35, 'Simonis-O''Reilly', 1957, 1981421710, '1 Hanover Center', 'Tyler', 'TX', '75710', '35');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (36, 'Beahan, Boehm and Wilderman', 1981, 170065523, '6201 Kipling Street', 'Kansas City', 'MO', '64193', '36');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (37, 'Mraz, Kilback and Rice', 2021, 1989593639, '3719 Sachtjen Place', 'Charleston', 'SC', '29424', '37');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (38, 'Waters-Casper', 1960, 1130552582, '29654 Columbus Center', 'San Rafael', 'CA', '94913', '38');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (39, 'Brown and Sons', 1950, 1988345903, '01692 Farwell Plaza', 'Englewood', 'CO', '80150', '39');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (40, 'Cole-Homenick', 1953, 44379784, '8063 Di Loreto Avenue', 'Miami', 'FL', '33153', '40');

insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (1, '8:40:00', '16:29:00', '38 Rockefeller Pass', 'Chicago', 'IL', '60697', '2022-01-07', 'Violetta', 'Alekhov', '9');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (2, '9:25:00', '14:21:00', '3850 Goodland Junction', 'Van Nuys', 'CA', '91499', '2022-08-19', 'Agneta', 'Sorensen', '10');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (3, '9:53:00', '14:43:00', '9284 Hansons Junction', 'Memphis', 'TN', '38119', '2022-01-31', 'Florrie', 'Rizzardo', '8');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (4, '10:47:00', '12:41:00', '448 Holy Cross Center', 'Lakewood', 'WA', '98498', '2022-10-30', 'Allx', 'Fuentes', '18');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (5, '8:29:00', '16:47:00', '0325 Nevada Circle', 'Bellevue', 'WA', '98008', '2022-09-06', 'Kyrstin', 'Duff', '16');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (6, '10:39:00', '14:29:00', '6430 Stoughton Plaza', 'Milwaukee', 'WI', '53210', '2022-09-18', 'Gordie', 'Ianson', '2');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (7, '11:28:00', '14:10:00', '936 Melody Way', 'Oklahoma City', 'OK', '73190', '2021-12-24', 'Shelley', 'Byars', '12');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (8, '11:07:00', '14:27:00', '71161 Carioca Park', 'San Francisco', 'CA', '94137', '2022-10-09', 'Clarette', 'Piffe', '6');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (9, '9:28:00', '12:53:00', '70 Upham Place', 'Visalia', 'CA', '93291', '2022-01-21', 'Buck', 'Seely', '5');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (10, '8:19:00', '12:32:00', '9 La Follette Lane', 'Columbus', 'OH', '43220', '2022-03-18', 'Sherye', 'Kohrt', '11');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (11, '8:32:00', '13:47:00', '935 Canary Avenue', 'Fort Smith', 'AR', '72916', '2022-03-20', 'Arv', 'Falkner', '14');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (12, '10:24:00', '14:25:00', '87100 Sutteridge Lane', 'Charleston', 'WV', '25305', '2022-10-09', 'Minnaminnie', 'Travers', '4');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (13, '8:50:00', '14:21:00', '1613 Kropf Place', 'Washington', 'DC', '20397', '2022-06-22', 'Osbourne', 'Lisciandro', '3');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (14, '11:15:00', '13:05:00', '1 Warbler Circle', 'Dallas', 'TX', '75251', '2021-12-14', 'Della', 'Desport', '17');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (15, '11:28:00', '16:15:00', '451 Carioca Avenue', 'Sioux Falls', 'SD', '57193', '2022-07-18', 'Damaris', 'Guiett', '19');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (16, '11:41:00', '14:05:00', '460 Talmadge Circle', 'Salt Lake City', 'UT', '84189', '2022-07-13', 'Cchaddie', 'Leneve', '1');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (17, '11:52:00', '14:34:00', '6 Arrowood Parkway', 'Louisville', 'KY', '40256', '2022-02-21', 'Cody', 'Shorten', '13');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (18, '11:36:00', '13:01:00', '096 Forest Pass', 'Charlotte', 'NC', '28242', '2022-02-10', 'Erica', 'Adkin', '20');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (19, '10:44:00', '15:42:00', '2168 American Ash Point', 'Palo Alto', 'CA', '94302', '2022-11-28', 'Koo', 'Soames', '7');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (20, '11:03:00', '13:25:00', '2043 Quincy Court', 'Akron', 'OH', '44315', '2022-06-27', 'Englebert', 'Golston', '15');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (21, '10:31:00', '1:50:00', '46917 Commercial Center', 'Lexington', 'KY', '40524', '2022-08-20', 'Talyah', 'Marwood', '2');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (22, '10:19:00', '3:29:00', '056 Waubesa Point', 'Des Moines', 'IA', '50315', '2022-06-23', 'Adela', 'Kincey', '13');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (23, '9:23:00', '2:59:00', '4 Farmco Court', 'Rochester', 'NY', '14614', '2022-05-01', 'Barbara-anne', 'Togher', '11');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (24, '11:58:00', '4:59:00', '52 Rockefeller Junction', 'Valdosta', 'GA', '31605', '2022-02-05', 'Geri', 'Colt', '10');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (25, '11:49:00', '4:51:00', '653 Eastlawn Street', 'Melbourne', 'FL', '32919', '2022-01-26', 'Lurlene', 'Borg', '34');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (26, '10:53:00', '4:45:00', '29143 Montana Lane', 'Young America', 'MN', '55551', '2022-03-17', 'Odella', 'Stronach', '39');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (27, '11:11:00', '4:03:00', '5553 Stephen Center', 'Bloomington', 'IN', '47405', '2021-11-25', 'Marsiella', 'Gaffey', '22');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (28, '11:09:00', '1:59:00', '949 Mayer Way', 'Lafayette', 'LA', '70593', '2022-06-29', 'Orlan', 'Fiddy', '37');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (29, '9:19:00', '3:49:00', '74290 Sage Avenue', 'Brooklyn', 'NY', '11241', '2022-03-13', 'Antoinette', 'Gaenor', '26');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (30, '10:18:00', '12:53:00', '2408 Division Court', 'Charlotte', 'NC', '28220', '2022-06-26', 'Artus', 'Kemell', '28');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (31, '10:45:00', '4:13:00', '66 Garrison Drive', 'Delray Beach', 'FL', '33448', '2021-11-30', 'Heddi', 'Beton', '40');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (32, '9:46:00', '3:40:00', '81395 Transport Place', 'Omaha', 'NE', '68164', '2022-05-17', 'Anissa', 'Matteini', '19');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (33, '10:23:00', '4:43:00', '3 Oriole Pass', 'Austin', 'TX', '78769', '2022-07-06', 'Rosamund', 'Mathen', '20');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (34, '10:30:00', '1:12:00', '351 Homewood Junction', 'Santa Clara', 'CA', '95054', '2022-10-16', 'Carey', 'Bursnoll', '1');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (35, '10:36:00', '2:14:00', '7083 Waywood Pass', 'Los Angeles', 'CA', '90060', '2021-12-02', 'Carline', 'Ibbetson', '14');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (36, '11:17:00', '12:22:00', '3 Loomis Circle', 'Edmond', 'OK', '73034', '2022-09-25', 'Cammie', 'Runge', '7');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (37, '11:18:00', '1:58:00', '5 Park Meadow Avenue', 'Macon', 'GA', '31296', '2022-11-01', 'Joyce', 'Greenshiels', '8');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (38, '11:42:00', '2:54:00', '01485 Caliangt Park', 'Worcester', 'MA', '01654', '2022-04-18', 'Corry', 'Rahl', '9');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (39, '10:36:00', '1:31:00', '0 Glendale Pass', 'Washington', 'DC', '20231', '2022-04-01', 'Murdock', 'Hendrickx', '15');
insert into inspection (inspID, startTime, endTime, street, city, state, zip, date, inspFirstName, inspLastName, agentID) values (40, '9:51:00', '12:48:00', '2755 Sheridan Terrace', 'Albany', 'NY', '12262', '2022-11-15', 'Beck', 'Kehri', '5');

insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (1, '11:01:00', '16:21:00', '03 Vidon Lane', 'Oakland', 'CA', 'TX', '2022-01-17', '19');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (2, '10:09:00', '13:59:00', '50 Mayfield Plaza', 'Rochester', 'NY', 'TX', '2022-02-04', '9');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (3, '8:19:00', '14:13:00', '755 Pleasure Way', 'Maple Plain', 'MN', 'CA', '2022-02-25', '8');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (4, '10:45:00', '15:28:00', '49 Northwestern Court', 'Seattle', 'WA', 'NC', '2021-12-06', '7');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (5, '11:21:00', '13:42:00', '7 Commercial Pass', 'Shreveport', 'LA', 'PA', '2022-07-20', '20');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (6, '11:48:00', '14:50:00', '50 Bowman Pass', 'Las Vegas', 'NV', 'CA', '2022-11-11', '2');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (7, '10:13:00', '15:41:00', '0832 Mifflin Point', 'Pittsburgh', 'PA', 'CT', '2022-05-31', '13');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (8, '10:35:00', '16:57:00', '413 6th Avenue', 'Beaumont', 'TX', 'IL', '2022-08-19', '5');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (9, '11:18:00', '12:43:00', '578 Knutson Terrace', 'Fresno', 'CA', 'OH', '2021-12-10', '11');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (10, '11:23:00', '12:23:00', '457 Lillian Terrace', 'Colorado Springs', 'CO', 'NY', '2022-11-04', '3');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (11, '8:38:00', '14:05:00', '2642 Gerald Terrace', 'Houston', 'TX', 'PA', '2022-05-10', '4');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (12, '10:48:00', '15:40:00', '33 Jay Junction', 'Houston', 'TX', 'AZ', '2022-07-24', '12');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (13, '9:23:00', '14:35:00', '5501 Forster Street', 'Detroit', 'MI', 'DC', '2022-04-18', '14');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (14, '10:35:00', '13:27:00', '4 David Street', 'Peoria', 'IL', 'VA', '2021-12-03', '1');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (15, '8:18:00', '16:16:00', '74141 Ramsey Street', 'Jefferson City', 'MO', 'DC', '2022-06-02', '15');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (16, '11:54:00', '14:01:00', '94 Weeping Birch Hill', 'Los Angeles', 'CA', 'MT', '2022-05-29', '16');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (17, '9:20:00', '14:14:00', '04134 Valley Edge Circle', 'Chico', 'CA', 'FL', '2022-07-20', '10');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (18, '8:14:00', '13:24:00', '84 Longview Circle', 'Trenton', 'NJ', 'TX', '2022-06-10', '17');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (19, '8:52:00', '16:29:00', '1 Morningstar Lane', 'Des Moines', 'IA', 'TN', '2022-08-24', '18');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (20, '11:29:00', '13:29:00', '64841 Fulton Park', 'Los Angeles', 'CA', 'MA', '2022-09-30', '6');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (21, '9:50:00', '12:32:00', '6136 Mendota Plaza', 'Little Rock', 'AR', 'CO', '2021-11-30', '12');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (22, '9:51:00', '3:34:00', '3 Sage Plaza', 'Omaha', 'NE', 'TX', '2022-06-16', '20');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (23, '10:31:00', '3:26:00', '81271 Elka Center', 'Dallas', 'TX', 'NY', '2022-06-03', '1');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (24, '11:24:00', '1:13:00', '9626 Fordem Avenue', 'Springfield', 'MO', 'SC', '2022-08-16', '13');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (25, '11:33:00', '4:44:00', '900 New Castle Park', 'Detroit', 'MI', 'MD', '2022-05-01', '4');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (26, '11:32:00', '12:51:00', '77474 Main Street', 'Washington', 'DC', 'SC', '2021-12-18', '27');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (27, '10:54:00', '1:30:00', '13284 Marquette Avenue', 'Salt Lake City', 'UT', 'TX', '2022-10-21', '14');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (28, '11:22:00', '2:19:00', '11 Dawn Circle', 'Santa Monica', 'CA', 'WA', '2021-12-27', '3');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (29, '9:20:00', '4:15:00', '998 Emmet Center', 'Ridgely', 'MD', 'DC', '2022-01-25', '16');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (30, '8:26:00', '1:53:00', '59 Graceland Hill', 'Baton Rouge', 'LA', 'DC', '2021-12-24', '8');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (31, '10:21:00', '1:08:00', '829 Vera Hill', 'Miami', 'FL', 'NY', '2022-06-29', '39');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (32, '11:06:00', '4:32:00', '36171 Bayside Trail', 'Lexington', 'KY', 'MI', '2022-07-27', '9');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (33, '8:10:00', '4:50:00', '9495 Longview Road', 'Vancouver', 'WA', 'ID', '2022-10-26', '6');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (34, '9:26:00', '1:16:00', '07 Northland Pass', 'Los Angeles', 'CA', 'OH', '2022-09-12', '17');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (35, '11:50:00', '12:31:00', '5 Cherokee Alley', 'Minneapolis', 'MN', 'IN', '2022-09-23', '12');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (36, '11:46:00', '4:37:00', '51369 Haas Junction', 'North Las Vegas', 'NV', 'CA', '2022-03-11', '8');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (37, '9:40:00', '4:34:00', '28129 Mendota Center', 'Los Angeles', 'CA', 'CA', '2022-07-08', '1');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (38, '9:29:00', '2:14:00', '21265 Ronald Regan Pass', 'Rochester', 'NY', 'FL', '2022-01-23', '11');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (39, '11:42:00', '4:32:00', '9544 Sunbrook Road', 'Huntington', 'WV', 'KS', '2022-07-07', '10');
insert into openHouse (ohID, startTime, endTime, street, city, state, zip, date, agentID) values (40, '8:22:00', '12:46:00', '0637 Scoville Drive', 'Tulsa', 'OK', 'CA', '2022-04-18', '8');