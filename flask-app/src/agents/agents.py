from datetime import timedelta

from flask import Blueprint, request, jsonify, make_response
import json
from src import db

# Agent blueprint
agents = Blueprint('agents', __name__)


# Get all prospective buyers and their associated agent from the DB
@agents.route('/buyers', methods=['GET'])
def get_all_buyers():
    cursor = db.get_db().cursor()
    cursor.execute('select agentID, buyerID, firstName, lastName, email, phoneNumber \
                   from prospectiveBuyer')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        # get the associated agent first and last name
        their_agent_id = row[0]
        cursor.execute('select firstName as agentFirst, lastName as agentLast from agent where agentID = %s',
                       their_agent_id)
        agent_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))
        new_dict = {**dict(zip(row_headers, row)), **agent_dict}
        json_data.append(new_dict)
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all prospective buyers associated with agent currently logged in
@agents.route('/agent_buyers', methods=['GET', 'POST'])
def get_agent_buyers():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        this_agent = request.form['agentID']
        cursor.execute('select pb.buyerID, pb.firstName, pb.lastName, pb.email, pb.phoneNumber, \
                       bs.budget, bs.beds, bs.baths, bs.city as desiredCity, bs.state as desiredState \
                       from prospectiveBuyer pb \
                       join buyerSpecifics bs on pb.buyerID = bs.buyerID where agentID = %s', (this_agent))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Get all showing appointments of the agent logged in
@agents.route('/showing_appts', methods=['GET', 'POST'])
def get_showing_appts():
    cursor = db.get_db().cursor()

    if request.method == 'POST':
        agentID = request.form['agentID']
        # get all showing appointments
        cursor.execute('select startTime, endTime, street, city, state, \
            zip, date, buyerID from showingAppt where agentID = %s', agentID)

        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:

            buyerID = row[0]
            cursor.execute('SELECT firstName, lastName from prospectiveBuyer where buyerID = %s', buyerID)
            buyer_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

            asList = list(row)
            for index, item in list(enumerate(asList)):
                if isinstance(item, timedelta):
                    asList[index] = str(asList[index])
            asTuple = tuple(asList)

            new_dict = {**buyer_dict, **dict(zip(row_headers, asTuple))}
            json_data.append(new_dict)

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# get all inspection appointments of the agent logged in
@agents.route('/insp_appts', methods=['GET', 'POST'])
def get_insp_appts():
    cursor = db.get_db().cursor()

    if request.method == 'POST':
        agentID = request.form['agentID']

        cursor.execute('select startTime, endTime, street, city, state, \
            zip, date, inspFirstName, inspLastName from inspection where agentID = %s', agentID)

        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            asList = list(row)
            for index, item in list(enumerate(asList)):
                if isinstance(item, timedelta):
                    asList[index] = str(asList[index])
            asTuple = tuple(asList)
            json_data.append(dict(zip(row_headers, asTuple)))

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# get all open house appointments of the agent logged in
@agents.route('/oh_appts', methods=['GET', 'POST'])
def get_oh_appts():
    cursor = db.get_db().cursor()

    if request.method == 'POST':
        agentID = request.form['agentID']

        cursor.execute('select startTime, endTime, street, city, state, \
                zip, date from openHouse where agentID = %s', agentID)

        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            asList = list(row)
            for index, item in list(enumerate(asList)):
                if isinstance(item, timedelta):
                    asList[index] = str(asList[index])
            asTuple = tuple(asList)
            json_data.append(dict(zip(row_headers, asTuple)))

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Get prospective buyer details and buyer specifics details for buyer with given buyerID
@agents.route('/buyer', methods=['POST'])
def get_buyer():
    if request.method == 'POST':
        buyerID = request.form['buyerID']
        # buyerID = data['buyerID']
        cursor = db.get_db().cursor()
        cursor.execute('select * from prospectiveBuyer where buyerID = {0}'.format(buyerID))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()

        # get the buyer specifics associated with the buyer (based on given buyerID)
        select_stmt = 'select budget, beds, baths, city as desired_city, state as desired_state \
                               from buyerSpecifics where buyerID = %s'
        tuple1 = (buyerID)
        cursor.execute(select_stmt, tuple1)

        # store a dictionary of the property detail attributes and values
        specifics_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

        # get the features wish list
        select_stmt = 'select featuresWishList from featuresWishList where buyerID = %s'
        cursor.execute(select_stmt, tuple1)

        # todo: fix this part of routes (features, neighborhood, property type - index out of bounds)
        wishlist_dict = {}
        if cursor.rowcount > 0:
            # store a dictionary of the features wish list attributes and values
            wishlist_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

        # get the neighborhood
        select_stmt = 'select neighborhood from neighborhood where buyerID = %s'
        cursor.execute(select_stmt, tuple1)

        neighborhood_dict = {}
        if cursor.rowcount > 0:
            # store a dictionary of the features wish list attributes and values
            neighborhood_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

        # get the property type
        select_stmt = 'select propertyType from propertyType where buyerID = %s'
        cursor.execute(select_stmt, tuple1)

        property_dict = {}
        if cursor.rowcount > 0:
            # store a dictionary of the features wish list attributes and values
            property_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

        # merge the dictionaries so the activeListing and propertyDetails attributes are together
        new_dict = {**dict(zip(row_headers, theData[0])), **specifics_dict, **neighborhood_dict, **property_dict,
                    **wishlist_dict}
        json_data.append(new_dict)

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Register a new buyer
@agents.route('/new_buyer', methods=['POST'])
def register_buyer():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        firstName = request.form['firstName']
        lastName = request.form['lastName']
        email = request.form['email']
        phone = request.form['phone']
        street = request.form['street']
        city = request.form['city']
        state = request.form['state']
        zipCode = request.form['zip']
        agentID = request.form['agentID']
        beds = request.form['beds']
        baths = request.form['baths']
        budget = request.form['budget']
        desired_city = request.form['desired_city']
        desired_state = request.form['desired_state']
        features = request.form['features']
        neighborhood = request.form['neighborhood']
        property = request.form['property']

        # insert buyer into prospective buyer table
        cursor.execute('INSERT INTO prospectiveBuyer (firstName, lastName, email, phoneNumber, street, city, state, zip, agentID) '
                       'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)', (firstName, lastName, email, phone, street, city, state, zipCode, agentID))
        db.get_db().commit()

        # get buyer id from new buyer entry in prospective buyer
        cursor.execute('SELECT buyerID from prospectiveBuyer WHERE email=%s', (email))
        id = cursor.fetchall()[0][0]

        # insert buyer specifics into table
        cursor.execute('INSERT INTO buyerSpecifics (budget, beds, baths, city, state, buyerID) '
                       'VALUES (%s, %s, %s, %s, %s, %s)', (budget, beds, baths, desired_city, desired_state, id))
        db.get_db().commit()

        # insert features wish list into table
        cursor.execute('INSERT INTO featuresWishList (buyerID, featuresWishList) '
                       'VALUES (%s, %s)', (id, features))
        db.get_db().commit()

        # insert neighborhood into table
        cursor.execute('INSERT INTO neighborhood (buyerID, neighborhood) '
                       'VALUES (%s, %s)', (id, neighborhood))
        db.get_db().commit()

        # insert property type into table
        cursor.execute('INSERT INTO propertyType (buyerID, propertyType) '
                       'VALUES (%s, %s)', (id, property))
        db.get_db().commit()

    cursor.execute('select * from prospectiveBuyer')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all of the listings of the agent logged in
@agents.route('/listings', methods=['GET','POST'])
def get_agent_listings():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        agent = request.form['agentID']
        cursor.execute('SELECT aL.status, aL.askingPrice, aL.daysOnMarket, aL.listingDate, \
                        pD.street, pD.city, pD.state, pD.zip, pD.beds, pD.baths, pD.yearBuilt, pD.squareFootage \
                        FROM activeListing AS aL JOIN propertyDetails AS pD ON aL.listingID = pD.listingID \
                        WHERE aL.agentID = %s', (agent))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Register a new active listing
@agents.route('/new_listing', methods=['GET', 'POST'])
def register_listing():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        agent = request.form['agentID']
        status = request.form['status']
        askingPrice = request.form['asking_price']
        daysOnMarket = request.form['days']
        listingDate = request.form['list_date']
        ownerFirstName = request.form['owner_first_name']
        ownerLastName = request.form['owner_last_name']
        ownerEmail = request.form['owner_email']
        ownerPhone = request.form['owner_phone']
        street = request.form['street']
        city = request.form['city']
        state = request.form['state']
        zipCode = request.form['zip']
        beds = request.form['beds']
        baths = request.form['baths']
        yearBuilt = request.form['year_built']
        sqFoot = request.form['sq_foot']

        # insert listing into active listing
        cursor.execute('INSERT INTO activeListing (status, askingPrice, daysOnMarket, listingDate, agentID) '
                       'VALUES (%s, %s, %s, %s, %s)', (status, askingPrice, daysOnMarket, listingDate, agent))
        db.get_db().commit()

        # get listing id from new active listing entry
        cursor.execute('SELECT listingID from activeListing ORDER BY listingID')
        id = cursor.fetchall()[cursor.rowcount - 1][0]

        # insert property owner
        cursor.execute('INSERT INTO propertyOwner (firstName, lastName, email, phoneNumber, listingID, agentID)'
                       'VALUES (%s, %s, %s, %s, %s, %s)', (ownerFirstName, ownerLastName, ownerEmail, ownerPhone, id, agent))
        db.get_db().commit()

        # insert property details
        cursor.execute('INSERT INTO propertyDetails (street, city, state, zip, beds, baths, yearBuilt, squareFootage, listingID) '
                       'VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)', (street, city, state, zipCode, beds, baths, yearBuilt,
                                                                       sqFoot, id))
        db.get_db().commit()

        cursor.execute('select * from activeListing')
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))

        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response