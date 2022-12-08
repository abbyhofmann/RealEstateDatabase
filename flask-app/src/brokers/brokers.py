# routes: get all sold listings (can filter by agent and/or sort by date sold), get all the clients in
# the DB, reassign client to a different agent, total sales

from flask import Blueprint, request, jsonify, make_response
import json
from src import db

# brokers route
brokers = Blueprint('brokers', __name__)

# Get all sold listings sorted as specified
@brokers.route('/sold', methods=['GET', 'POST'])
def get_sold():
   cursor = db.get_db().cursor()

   if request.method == 'POST':
       selected_sort_option = request.form['sort-by']
       if selected_sort_option == 'P-HL':  #todo - if statements for selected sort option
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing ORDER BY sellPrice DESC')
           # cursor.fetchall()  ???

       elif selected_sort_option == 'P-LH':
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing ORDER BY sellPrice')

       elif selected_sort_option == 'most-days':
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing ORDER BY daysOnMarket DESC')

       elif selected_sort_option == 'least-days':
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing ORDER BY daysOnMarket')

       elif selected_sort_option == 'most-recent':
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing ORDER BY sellDate')

       else:
           cursor.execute('select sellDate, commission, sellPrice, daysOnMarket, buyerID, \
                              agentID from soldListing')

       row_headers = [x[0] for x in cursor.description]
       json_data = []
       theData = cursor.fetchall()
       for row in theData:
           agent = row[0]
           cursor.execute('select firstName as agentFirstName, lastName as agentLastName from agent where agentID = %s', agent)
           agent_dict = {}
           if cursor.rowcount > 0:
               agent_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

           buyer = row[1] # todo: add buyer info for sold listings
           cursor.execute('select firstName as ownerFirstName, lastName as ownerLastName from propertyOwner where ownerID = %s', buyer)
           buyer_dict = {}
           if cursor.rowcount > 0:
               buyer_dict = dict(zip([x[0] for x in cursor.description], cursor.fetchall()[0]))

           new_dict = {**dict(zip(row_headers, row)), **agent_dict, **buyer_dict}
           json_data.append(new_dict)
       the_response = make_response(jsonify(json_data))
       the_response.status_code = 200
       the_response.mimetype = 'application/json'
       return the_response


# Reassigns an agent to a specified buyer
@brokers.route('/reassign_agent', methods=['GET', 'POST'])
def reassign_agent():
    cursor = db.get_db().cursor()
    if request.method == 'POST':
        agent = request.form['agentID']
        buyer = request.form['buyerID']
        cursor.execute('UPDATE prospectiveBuyer SET agentID = %s WHERE buyerID = %s', (agent, buyer))
        db.get_db().commit()
        # Check updated entry
        cursor.execute('SELECT * FROM prospectiveBuyer WHERE buyerID = %s', (buyer))
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response


# Get all the buyers grouped by their agents
@brokers.route('/agent_buyers', methods=['GET'])
def get_agent_buyers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM prospectiveBuyer GROUP BY agentID')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


