#!/usr/bin/env python
# -*- coding: utf-8 -*-

import httplib, json, sqlite3, time, pycountry
from scipy.stats import norm

# Generate ratings for attacking, defending, passing and statistics based on player statistics.
# Uses the inverse normal distribution to normalise the values.
def generatRankings(player):
    pass

# Get data from API. If argument is left empty, statistics for all players will be fetched.
# Otherwise, the personal information of a specific player provided by the PlayerId will be fetched.
def getData(PlayerId=""):
    # Set HTTP headers for request.
    headers = {
        'Host': 'api.fantasydata.net',
        'Ocp-Apim-Subscription-Key': '5a2b7b21c3524a15a7ab1721bb43d7b8',
    }
    
    # Get all player data or a specific player's data depending on whether the PlayerId has been provided.
    if PlayerId == "":
        path = "/soccer/v2/json/PlayerSeasonStats/73?"
    else:
        path = "/soccer/v2/json/Player/" + str(PlayerId) + "?"
    
    try:
        # API url.
        conn = httplib.HTTPSConnection('api.fantasydata.net')
        # Create the request.
        conn.request("GET", path, "{body}", headers)
        # Get the response and save it to the data variable.
        response = conn.getresponse()
        data = response.read()
        # Convert the data string to json to be parsed correctly.
        players = json.loads(data)
        # Close the connection once the data has been received.
        conn.close()
        # Return the data.
        return players
    # Catch any erros in getting the data.
    except Exception as e:
        print("Error, unable to load Player Season Stats from API.".format(e.errno, e.strerror))
        return false

# Given a set of data received from the API, it will save it to the database. Only statistical data needs
# To be updated, as personal information never changes. If the player isn't in the database, their personal
# Information is fetched and they are added to the database.
def saveData(players):
    # Get country code data.
    countries = {}
    for country in pycountry.countries:
        countries[country.name] = country.alpha2
    
    # Set up Players database.
    conn=sqlite3.connect('Footballers.db')
    curs=conn.cursor()
    
    # Loop through every player.
    for playerStats in players:
        # Check if player is already saved in the database.
        for row in curs.execute("SELECT * FROM Players WHERE PlayerId='" + str(playerStats["PlayerId"]) + "'"):
            # If the player is already in the database, update the data using the statistics from the data.
            curs.execute("UPDATE Players SET Games = ?, Minutes = ?, Goals = ?, Assists = ?, YellowCards = ?, RedCards = ?, ShotSuccess = ?, PassSuccess = ?, TacklesWon = ? WHERE PlayerId='" + str(playerStats["PlayerId"]) + "'", (playerStats["Games"], playerStats["Minutes"], playerStats["Goals"], playerStats["Assists"], playerStats["ShotsOnGoal"], playerStats["YellowCards"], playerStats["RedCards"], playerStats["PassesCompleted"], playerStats["TacklesWon"]))
            
            print("Player updated: " + playerStats["Name"])
            break
        else:
            # If the player isn't in the database, get their personal information and insert a new entry.
            playerData = getData(playerStats["PlayerId"])
            # Set the region code depending on nationality.
            regionCode = countries.get(playerData["Nationality"])
            
            curs.execute("""INSERT INTO Players values((?), (?), (?), '', (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), '', '', '', '')""", (playerStats["PlayerId"], playerStats["Name"], playerData["Nationality"], playerStats["Team"], playerStats["TeamId"], playerStats["Position"], playerData["Jersey"], playerData["Height"], playerData["Weight"], playerData["BirthDate"], playerData["PhotoUrl"], playerStats["Games"], playerStats["Minutes"], playerStats["Goals"], playerStats["Assists"], playerStats["YellowCards"], playerStats["RedCards"], playerStats["ShotsOnGoal"], playerStats["PassesCompleted"], playerStats["TacklesWon"]))
            conn.commit()
            print("New player added: " + playerStats["Name"])

    # Remove any null values.
    curs.execute("UPDATE Players SET Jersey = ' ' WHERE Jersey IS NULL")
    curs.execute("UPDATE Players SET Height = ' ' WHERE Height IS NULL")
    curs.execute("UPDATE Players SET Weight = ' ' WHERE Weight IS NULL")
    
    # Close database.
    conn.close()



"""

# Get country code data.
countries = {}
for country in pycountry.countries:
    countries[country.name] = country.alpha2

countries['England'] = 'GB-ENG'
countries['Wales'] = 'GB-WLS'
countries['Scotland'] = 'GB-SCT'
countries['Northern Ireland'] = 'GB-NIR'
countries['Republic of Ireland'] = 'IE'
countries['Congo DR'] = 'CD'
countries['Côte d’Ivoire'] = 'CI'
countries['Korea Republic'] = 'KR'
countries['Venezuela'] = 'VE'

# Set up Players database.
conn=sqlite3.connect('Footballers.db')
curs=conn.cursor()
    
   
# Check if player is already saved in the database.
for row in curs.execute("SELECT Nationality FROM Players"):
    code = countries.get(row[0], "Unkonwn code")
    if code == "Unkonwn code":
        print(row[0])"""






"""start = time.time()
players = getData()
end = time.time()
print(end - start)
print("LOADED")
start = time.time()
saveData(players)
end = time.time()
print(end - start)"""




