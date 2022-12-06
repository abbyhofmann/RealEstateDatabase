from datetime import timedelta

from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

# Buyers blueprint
prospectiveBuyers = Blueprint('prospectiveBuyers', __name__)

# Get all agents from the DB and return sorted based on user sort selection
@prospectiveBuyers.route('/agents', methods=['POST'])
def get_agents():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        current_app.logger.info(request.form)
        selected_sort_option = request.form['sort-agents']

        # alphabetical sorting
        if selected_sort_option == 'alphabetical':
            cursor.execute('SELECT * FROM agent ORDER BY lastName')
            all_agents = cursor.fetchall()

        # sort by most experienced agents
        elif selected_sort_option == 'most-exp':
            cursor.execute('SELECT * FROM agent ORDER BY yearsOfExperience DESC')
            all_agents = cursor.fetchall()

        # sort by least experienced agents
        elif selected_sort_option == 'least-exp':
            cursor.execute('SELECT * FROM agent ORDER BY yearsOfExperience')
            all_agents = cursor.fetchall()

        # default sort ordering
        else:
            cursor.execute('SELECT * FROM agent')
            all_agents = cursor.fetchall()

        row_headers = [x[0] for x in cursor.description]
        json_data = []
        for row in all_agents:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Get all active listings and their property details from the DB
@prospectiveBuyers.route('/listings', methods=['GET'])
def get_active_listings():
    cursor = db.get_db().cursor()

    # get all the listings
    cursor.execute('select listingID, status, askingPrice, daysOnMarket from activeListing')

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        # for each listing, get the property details associated with it (based on listingID)
        id = row[0]
        select_stmt = 'select street, city, state, zip, beds, baths, yearBuilt, squareFootage \
                       from propertyDetails where listingID = %s'
        tuple1 = (id)
        cursor.execute(select_stmt, tuple1)
        mt_inner = []

        # store a dictionary of the property detail attributes and values
        for inner_row in cursor.fetchall():
            mt_inner.append(dict(zip([x[0] for x in cursor.description], inner_row)))

        # merge the dictionaries so the activeListing and propertyDetails attributes are together
        new_dict = dict(zip(row_headers, row)) | mt_inner[0]
        json_data.append(new_dict)
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Gets all the favorite listings and their details for logged in user
@prospectiveBuyers.route('/fav_listings', methods=['GET', 'POST'])
def get_fav_listings():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        this_buyer = request.form['buyerID']

        cursor.execute('SELECT aL.status, aL.askingPrice, aL.daysOnMarket, aL.listingDate, \
                       pD.street, pD.city, pD.state, pD.zip, pD.beds, pD.baths, pD.yearBuilt, pD.squareFootage \
                       FROM activeListing aL JOIN favoriteListing fL ON aL.listingID=fL.listingID \
                       JOIN propertyDetails pD on aL.listingID=pD.listingID \
                       WHERE fL.buyerID=%s', (this_buyer))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Gets all the buyer specifics for the logged in user
@prospectiveBuyers.route('/specifics', methods=['GET', 'POST'])
def get_specifics():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        this_buyer = request.form['buyerID']

        cursor.execute('SELECT * FROM buyerSpecifics bS \
                       JOIN featuresWishList fW on bS.buyerID=fW.buyerID \
                       JOIN neighborhood n on bS.buyerID=n.buyerID \
                       JOIN propertyType pT on bS.buyerID=pT.buyerID \
                       WHERE bS.buyerID=%s', (this_buyer))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Get all the showings a logged in buyer has
@prospectiveBuyers.route('/showings', methods=['GET', 'POST'])
def buyer_showings():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        this_buyer = request.form['buyerID']
        cursor.execute('SELECT startTime, endTime, street, city, state, zip, date \
                       FROM showingAppt sA WHERE sA.buyerID=%s', (this_buyer))
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



