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

insert into featuresWishList (buyerID, featuresWishList) values ('2', 'eu est congue elementum in hac habitasse platea dictumst');
insert into featuresWishList (buyerID, featuresWishList) values ('4', 'habitasse platea dictumst maecenas ut');
insert into featuresWishList (buyerID, featuresWishList) values ('16', 'est donec odio');
insert into featuresWishList (buyerID, featuresWishList) values ('1', 'dolor sit amet consectetuer adipiscing elit proin interdum mauris non');
insert into featuresWishList (buyerID, featuresWishList) values ('7', 'ornare imperdiet sapien');
insert into featuresWishList (buyerID, featuresWishList) values ('13', 'ut ultrices');
insert into featuresWishList (buyerID, featuresWishList) values ('19', 'hendrerit at vulputate vitae');
insert into featuresWishList (buyerID, featuresWishList) values ('20', 'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis');
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
insert into featuresWishList (buyerID, featuresWishList) values ('9', 'sed');
insert into featuresWishList (buyerID, featuresWishList) values ('18', 'lobortis ligula sit amet');

insert into neighborhood (buyerID, neighborhood) values ('19', 'amet consectetuer adipiscing elit');
insert into neighborhood (buyerID, neighborhood) values ('3', 'rhoncus');
insert into neighborhood (buyerID, neighborhood) values ('20', 'augue vel accumsan');
insert into neighborhood (buyerID, neighborhood) values ('7', 'dolor sit amet consectetuer');
insert into neighborhood (buyerID, neighborhood) values ('7', 'ligula vehicula');
insert into neighborhood (buyerID, neighborhood) values ('16', 'dui');
insert into neighborhood (buyerID, neighborhood) values ('12', 'praesent blandit nam nulla');
insert into neighborhood (buyerID, neighborhood) values ('9', 'montes nascetur');
insert into neighborhood (buyerID, neighborhood) values ('10', 'ipsum');
insert into neighborhood (buyerID, neighborhood) values ('6', 'in faucibus orci luctus');
insert into neighborhood (buyerID, neighborhood) values ('15', 'purus sit amet');
insert into neighborhood (buyerID, neighborhood) values ('19', 'rhoncus');
insert into neighborhood (buyerID, neighborhood) values ('15', 'sit amet turpis');
insert into neighborhood (buyerID, neighborhood) values ('12', 'interdum venenatis');
insert into neighborhood (buyerID, neighborhood) values ('20', 'turpis integer');
insert into neighborhood (buyerID, neighborhood) values ('16', 'adipiscing molestie hendrerit at');
insert into neighborhood (buyerID, neighborhood) values ('12', 'nullam');
insert into neighborhood (buyerID, neighborhood) values ('1', 'turpis');
insert into neighborhood (buyerID, neighborhood) values ('1', 'pede');
insert into neighborhood (buyerID, neighborhood) values ('12', 'porttitor id consequat');

insert into propertyType (buyerID, propertyType) values ('1', 'townhome');
insert into propertyType (buyerID, propertyType) values ('1', 'apartment');
insert into propertyType (buyerID, propertyType) values ('16', 'townhome');
insert into propertyType (buyerID, propertyType) values ('2', 'townhome');
insert into propertyType (buyerID, propertyType) values ('9', 'apartment');
insert into propertyType (buyerID, propertyType) values ('7', 'apartment');
insert into propertyType (buyerID, propertyType) values ('20', 'condo');
insert into propertyType (buyerID, propertyType) values ('10', 'house');
insert into propertyType (buyerID, propertyType) values ('19', 'house');
insert into propertyType (buyerID, propertyType) values ('12', 'condo');
insert into propertyType (buyerID, propertyType) values ('6', 'condo');
insert into propertyType (buyerID, propertyType) values ('15', 'townhome');
insert into propertyType (buyerID, propertyType) values ('3', 'condo');
insert into propertyType (buyerID, propertyType) values ('12', 'house');
insert into propertyType (buyerID, propertyType) values ('7', 'townhome');
insert into propertyType (buyerID, propertyType) values ('12', 'apartment');
insert into propertyType (buyerID, propertyType) values ('15', 'condo');
insert into propertyType (buyerID, propertyType) values ('4', 'apartment');
insert into propertyType (buyerID, propertyType) values ('20', 'apartment');
insert into propertyType (buyerID, propertyType) values ('19', 'apartment');

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

insert into areaOfExpertise (agentID, areaOfExpertise) values ('13', 'tristique');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('11', 'phasellus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('19', 'suspendisse ornare');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('17', 'tellus semper interdum mauris');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('9', 'luctus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('6', 'nulla');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('15', 'in felis eu sapien');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('7', 'ultrices posuere');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('10', 'cursus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('5', 'vel nulla eget eros elementum');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('8', 'vivamus tortor');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('2', 'eget semper rutrum nulla');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('12', 'duis bibendum felis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('4', 'in sagittis');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('3', 'amet sapien');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('16', 'leo odio');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('18', 'ipsum');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('1', 'mus');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('14', 'ut nunc vestibulum ante');
insert into areaOfExpertise (agentID, areaOfExpertise) values ('20', 'vestibulum vestibulum ante');

insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('051 Graceland Lane', 'Washington', 'DC', '20036', 5, 8, 1875, 8395, '7');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('146 Westend Crossing', 'Palm Bay', 'FL', '32909', 2, 3, 1940, 17442, '14');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('05725 Tony Avenue', 'Erie', 'PA', '16534', 14, 3, 1942, 18724, '12');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('11 Kensington Road', 'Plano', 'TX', '75074', 1, 6, 1966, 5788, '10');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('96 Moulton Avenue', 'Littleton', 'CO', '80161', 11, 1, 1923, 1182, '6');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('47412 Schurz Drive', 'Des Moines', 'IA', '50330', 3, 6, 1876, 8675, '20');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('91323 Dwight Terrace', 'Washington', 'DC', '20430', 0, 6, 1812, 5900, '17');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('07364 Mandrake Circle', 'Flint', 'MI', '48555', 14, 3, 1859, 11052, '16');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('9 Nancy Terrace', 'Fayetteville', 'NC', '28305', 13, 1, 1879, 19837, '11');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('94 Morningstar Road', 'Charleston', 'SC', '29403', 13, 2, 1848, 6299, '3');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('383 Farmco Avenue', 'Fort Collins', 'CO', '80525', 10, 3, 1906, 3025, '2');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('57644 Emmet Place', 'Richmond', 'VA', '23289', 11, 9, 1840, 5228, '8');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('82088 Saint Paul Point', 'Atlanta', 'GA', '30380', 2, 7, 1809, 3406, '19');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('806 Union Lane', 'Boston', 'MA', '02124', 14, 2, 1934, 17591, '4');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('176 Nevada Road', 'Knoxville', 'TN', '37914', 9, 5, 1854, 11558, '15');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('49369 Petterle Alley', 'Spokane', 'WA', '99220', 15, 4, 1980, 2793, '18');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('971 Sunfield Avenue', 'Cincinnati', 'OH', '45228', 2, 4, 1892, 11431, '9');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('3175 Delaware Junction', 'Irvine', 'CA', '92710', 3, 4, 1969, 7723, '5');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('936 Pine View Court', 'Fargo', 'ND', '58106', 14, 8, 1883, 1634, '13');
insert into propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) values ('20 Drewry Alley', 'Detroit', 'MI', '48242', 15, 5, 1930, 12574, '1');

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
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (17, '11:04:00', '13:15:00', '922 Golden Leaf Park', 'Tuscaloosa', 'AL', '35405', '2022-08-31', '12', '16');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (18, '8:44:00', '15:09:00', '20 Ramsey Point', 'Albany', 'NY', '12227', '2022-05-07', '15', '19');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (19, '9:14:00', '12:27:00', '67860 Northland Trail', 'Colorado Springs', 'CO', '80935', '2022-04-27', '11', '12');
insert into showingAppt (apptID, startTime, endTime, street, city, state, zip, date, buyerID, agentID) values (20, '10:50:00', '14:03:00', '759 Doe Crossing Street', 'Mansfield', 'OH', '44905', '2022-03-24', '1', '18');

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

insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (1, 'Kiehn LLC', 2019, 306272431, '22 Browning Avenue', 'Tampa', 'FL', '33694', '4');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (2, 'Miller, Predovic and Bergnaum', 1967, 855760392, '6110 Marcy Crossing', 'Chicago', 'IL', '60691', '17');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (3, 'Gutkowski and Sons', 1977, 1477292366, '76460 Towne Road', 'Saint Louis', 'MO', '63126', '2');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (4, 'Adams, Kling and Schulist', 2011, 589712282, '5 Helena Center', 'Stockton', 'CA', '95298', '9');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (5, 'Reynolds-Veum', 1981, 382493140, '92866 Loomis Terrace', 'Punta Gorda', 'FL', '33982', '19');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (6, 'Gusikowski-Hayes', 2012, 1783279466, '58366 Jenna Street', 'Spokane', 'WA', '99215', '15');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (7, 'Herzog Group', 1967, 1675364693, '01534 Pleasure Way', 'Tallahassee', 'FL', '32314', '3');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (8, 'Lind, Hoeger and Feeney', 1994, 130694276, '7974 Morning Drive', 'Wilmington', 'DE', '19897', '6');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (9, 'Pouros Group', 1927, 1897470522, '5507 Daystar Way', 'Houston', 'TX', '77276', '16');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (10, 'Mosciski and Sons', 1978, 340504285, '65 John Wall Circle', 'Miami', 'FL', '33134', '14');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (11, 'Pollich-Hauck', 1939, 1933684749, '085 Erie Place', 'Pittsburgh', 'PA', '15210', '8');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (12, 'Upton, Ratke and Hettinger', 1936, 1123311766, '400 Meadow Valley Avenue', 'Dayton', 'OH', '45419', '18');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (13, 'Gaylord-Goyette', 2004, 1186023913, '31961 Drewry Drive', 'New Haven', 'CT', '06505', '5');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (14, 'Grimes, Abshire and Considine', 2016, 493316070, '72 Hallows Street', 'Saint Louis', 'MO', '63116', '13');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (15, 'Schuppe, Rodriguez and Von', 1982, 117536727, '12 Crownhardt Plaza', 'Hampton', 'VA', '23668', '10');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (16, 'Gislason-Walter', 1947, 913843819, '0132 Lakewood Gardens Lane', 'Austin', 'TX', '78732', '1');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (17, 'Boyer LLC', 2010, 331748087, '510 Transport Pass', 'Sarasota', 'FL', '34233', '11');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (18, 'Abbott, Crist and Leannon', 1974, 39132097, '84 Debs Parkway', 'Boston', 'MA', '02163', '20');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (19, 'Tillman Inc', 1959, 1313338974, '95 Clove Pass', 'Washington', 'DC', '20078', '7');
insert into brokerage (brokerageID, name, yearFounded, totalSales, brokerageStreet, brokerageCity, brokerageState, brokerageZip, brokerID) values (20, 'Heathcote, Greenholt and Spinka', 1979, 679824180, '6 Wayridge Center', 'Santa Clara', 'CA', '95054', '12');

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
