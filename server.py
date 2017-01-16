#!/usr/bin/env python

from flask import Flask
from flask import request
import sqlite3

# Web server name.
app = Flask(__name__)

# Returns a player data for a given PlayerId.
@app.route('/getPlayer')
def getPlayer():
    # Get PlayerId from HTTP request.
    PlayerId = request.args.get('PlayerId')
    
    # Set up Players database.
    conn=sqlite3.connect('Footballers.db')
    curs=conn.cursor()
    
    # Search database until player with correct PlayerId is found.
    try:
        player = curs.execute("SELECT * FROM Players WHERE PlayerId='" + PlayerId + "'")[0]
    except:
        return "Invalid PlayerId. No player found."
    
    # Close database.
    conn.close()

    # Create string to store json data.
    json = '{'
    
    # Loop through each attribute.
    for i in range(len(curs.description)):
        # Add attribute name to data.
        json += '"' + curs.description[i][0] + '": '
        # Add attribute value to data.
        json += '"' + player[i] + '", '

    # Parse data so that it is correct json.
    json = json[:-3] + '}'

    # Return the json data.
    return json

# Returns a certain number of player sorted by a value. It return PlayerId, Name, RegionCode,
# Team, TeamId and the value being sorted.
@app.route('/getPlayers')
def getPlayers():
    # Get the attribute to sort the players by, and the number of players to send
    # From the HTTP request.
    SortValue = request.args.get('SortValue')
    NumberToGet = request.args.get('NumberToGet')
    
    # Set up Players database.
    conn=sqlite3.connect('Footballers.db')
    curs=conn.cursor()
    
    # Create a string to store the json data.
    json = '['
    
    # Gets the correct number of player attributes sorted by the given value.
    for row in curs.execute("SELECT PlayerId, Name, RegionCode, Team, TeamId, " + SortValue + " FROM Players ORDER BY " + SortValue + " DESC LIMIT " + NumberToGet):
        # Create a string to store the player as json.
        json += ' { '
        for i in range(len(curs.description)):
            # Add attribute name to data.
            json += '"' + curs.description[i][0] + '": '
            # Add attribute value to data. Parse integers and floats to strings.
            if type(row[i]) == int or type(row[i]) == float:
                json += '"' + str(row[i]) + '", '
            # Unicode cannot be converted with str() so it can be parsed as it is.
            else:
                json += '"' + row[i] + '", '
    
        # Parse the string so it is correct json.
        json = json[:-2] + ' }, '

    json = json[:-2] + ' ]'
    
    # Close the database.
    conn.close()
    
    # Return the data.
    return json

# Run the server.
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
