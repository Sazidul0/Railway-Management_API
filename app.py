from flask import Flask, request, jsonify
from datetime import datetime
import sqlite3

app = Flask(__name__)

# Function to get database connection and cursor
def get_db_cursor():
    db = sqlite3.connect("sqlite.db")
    cursor = db.cursor()
    return db, cursor




# API endpoint for creating a new user
@app.route('/api/insertUser', methods=['POST'])
def create_user():
    data = request.json
    db, cursor = get_db_cursor()
    cursor.execute("INSERT INTO Users (Username, Password, FirstName, LastName, Email, PhoneNumber, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?)",
                   (data["Username"], data["Password"], data["FirstName"], data["LastName"], data["Email"], data["PhoneNumber"], data.get("IsActive", 1)))
    db.commit()
    db.close()
    return jsonify(data), 201

# API endpoint for retrieving all users
@app.route('/api/users', methods=['GET'])
def get_users():
    db, cursor = get_db_cursor()
    cursor.execute("SELECT * FROM Users")
    users = [{"UserID": row[0], "Username": row[1], "Password": row[2], "FirstName": row[3], "LastName": row[4], "Email": row[5], "PhoneNumber": row[6], "IsActive": row[7]} for row in cursor.fetchall()]
    db.close()
    return jsonify(users), 200






# Route for creating or updating wallets
@app.route('/api/wallets', methods=['POST'])
def create_update_wallet():
    data = request.json
    db, cursor = get_db_cursor()
    
    # Fetch UserID based on Username
    cursor.execute("SELECT UserID FROM Users WHERE Username = ?", (data["Username"],))
    user = cursor.fetchone()
    
    if user:
        user_id = user[0]
        # Check if Wallet already exists for the user
        cursor.execute("SELECT * FROM Wallets WHERE UserID = ?", (user_id,))
        existing_wallet = cursor.fetchone()
        if existing_wallet:
            # Update existing wallet
            cursor.execute("UPDATE Wallets SET Balance = ? WHERE UserID = ?", (data["Balance"], user_id))
        else:
            # Create new wallet
            cursor.execute("INSERT INTO Wallets (UserID, Balance) VALUES (?, ?)", (user_id, data["Balance"]))
        
        db.commit()
        db.close()
        return jsonify(data), 201
    else:
        db.close()
        return jsonify({"error": "User not found"}), 404





@app.route('/api/trains', methods=['GET'])
def get_trains():
    db, cursor = get_db_cursor()
    cursor.execute("SELECT * FROM Trains")
    trains = [
        {
            "TrainID": row[0],
            "TrainName": row[1],
            "OriginStationID": row[2],
            "DestinationStationID": row[3],
            "DepartureTime": row[4],
            "ArrivalTime": row[5],
            "Frequency": row[6],
            "StartDate": row[7],
            "EndDate": row[8],
            "FarePerKilometer": row[9]
        }
        for row in cursor.fetchall()
    ]
    db.close()
    return jsonify(trains), 200






# Route for list All Active Users
@app.route('/api/active_users', methods=['GET'])
def count_active_users():
    db, cursor = get_db_cursor()

    # Execute SQL query to count active users
    cursor.execute("SELECT COUNT(*) FROM Users WHERE IsActive = 1")
    count = cursor.fetchone()[0]

    db.close()

    return jsonify({'active_users_count': count}), 200








@app.route('/api/sold_tickets_by_date', methods=['GET'])
def sold_tickets_by_date():
    # Extracting the date parameter from the request
    date = request.args.get('date')
    
    # Debug: Log the date received from the request
    print(f"Received date: {date}")

    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    try:
        # Check if the date parameter is provided
        if not date:
            db.close()
            return jsonify({'error': 'Date parameter is required'}), 400

        # Ensuring the date is in the correct format
        try:
            formatted_date = datetime.strptime(date, '%Y-%m-%d').date()
        except ValueError:
            db.close()
            return jsonify({'error': 'Invalid date format. Expected YYYY-MM-DD'}), 400

        # Debug: Log the formatted date being used in the query
        print(f"Querying for tickets on: {formatted_date}")

        # Executing SQL query to count sold tickets for the specified date
        cursor.execute("SELECT COUNT(*) FROM Tickets WHERE DATE(TravelDate) = ? AND IsReserved = 1", (formatted_date,))
        sold_tickets_count = cursor.fetchone()[0]

        # Debug: Log the result of the query
        print(f"Sold tickets count: {sold_tickets_count}")

        # Closing the database connection
        db.close()

        # Returning the count of sold tickets for the specified date
        return jsonify({'sold_tickets_count': sold_tickets_count}), 200

    except Exception as e:
        db.close()
        return jsonify({'error': str(e)}), 500







# Route for search a user by name
@app.route('/api/search_user', methods=['GET'])
def search_user():
    # Extract the name parameter from the request
    name = request.args.get('name')

    # Establish a connection to the database
    db, cursor = get_db_cursor()

    # Execute SQL query to retrieve user information based on first name or last name
    cursor.execute("SELECT * FROM Users WHERE FirstName LIKE ? OR LastName LIKE ?", ('%' + name + '%', '%' + name + '%'))

    # Fetch the results of the query
    user_info = cursor.fetchall()
    db.close()

    # Check if any user information was found
    if user_info:
        # Return user information as JSON response
        return jsonify(user_info), 200
    else:
        return jsonify({'error': 'No user found with the provided name'}), 404







# Sell Between two dates
@app.route('/api/total_sell_between_dates', methods=['GET'])
def total_sell_between_dates():
    # Extracting the start and end date parameters from the request
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    # Executing SQL query to calculate the total sell between the specified dates
    cursor.execute("""
        SELECT SUM(Fare) 
        FROM Tickets 
        WHERE TravelDate BETWEEN ? AND ? 
        AND IsReserved = 1
    """, (start_date, end_date))
    total_sell = cursor.fetchone()[0]

    # Closing the database connection
    db.close()

    # Returning the total sell between the specified dates
    return jsonify({'total_sell': total_sell}), 200








# Route for searching user by email
@app.route('/api/search_user_by_email', methods=['GET'])
def search_user_by_email():
    # Extracting email parameter from the request
    email = request.args.get('email')

    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    # Executing SQL query to retrieve user information by email
    cursor.execute("SELECT * FROM Users WHERE Email = ?", (email,))
    user = cursor.fetchone()

    # Closing the database connection
    db.close()

    # Returning the user information if found, or an error message if not found
    if user:
        user_info = {
            'UserID': user[0],
            'Username': user[1],
            'FirstName': user[3],
            'LastName': user[4],
            'Email': user[5],
            'PhoneNumber': user[6],
            'IsActive': bool(user[7])
        }
        return jsonify(user_info), 200
    else:
        return jsonify({'error': 'User not found for the given email'}), 404








# Route for listing all employees
@app.route('/api/list_employees', methods=['GET'])
def list_employees():
    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    # Executing SQL query to retrieve all employees
    cursor.execute("SELECT * FROM Employees")
    employees = cursor.fetchall()

    # Closing the database connection
    db.close()

    # Formatting employee data into a list of dictionaries
    employee_list = []
    for employee in employees:
        employee_info = {
            'EmployeeID': employee[0],
            'Username': employee[1],
            'FirstName': employee[3],
            'LastName': employee[4],
            'Email': employee[5],
            'PhoneNumber': employee[6],
            'IsActive': bool(employee[7])
        }
        employee_list.append(employee_info)

    # Returning the list of employees
    return jsonify(employee_list), 200







# Route for searching an employee by EmployeeID
@app.route('/api/search_employee_by_id', methods=['GET'])
def search_employee_by_id():
    # Extracting the EmployeeID parameter from the request
    employee_id = request.args.get('EmployeeID')

    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    # Executing SQL query to retrieve the employee by EmployeeID
    cursor.execute("SELECT * FROM Employees WHERE EmployeeID = ?", (employee_id,))
    employee = cursor.fetchone()

    # Closing the database connection
    db.close()

    # Checking if the employee with the given EmployeeID exists
    if employee:
        # Formatting employee data into a dictionary
        employee_info = {
            'EmployeeID': employee[0],
            'Username': employee[1],
            'FirstName': employee[3],
            'LastName': employee[4],
            'Email': employee[5],
            'PhoneNumber': employee[6],
            'IsActive': bool(employee[7])
        }
        return jsonify(employee_info), 200
    else:
        return jsonify({'error': 'Employee not found'}), 404








# Route for showing train capacity ordered by capacity
@app.route('/api/train_capacity', methods=['GET'])
def train_capacity():
    db, cursor = get_db_cursor()
    cursor.execute("""
        SELECT Trains.TrainName, TrainCapacity.Capacity 
        FROM Trains 
        JOIN TrainCapacity ON Trains.TrainID = TrainCapacity.TrainID 
        ORDER BY TrainCapacity.Capacity ASC
    """)
    train_capacity_list = cursor.fetchall()
    db.close()

    # Formatting the result into a list of dictionaries
    formatted_capacity_list = [{'TrainName': row[0], 'Capacity': row[1]} for row in train_capacity_list]

    return jsonify(formatted_capacity_list), 200









# Route for search trains by station id
@app.route('/api/search_trains', methods=['GET'])
def search_trains():
    from_station_id = request.args.get('from_station_id')
    to_station_id = request.args.get('to_station_id')

    db, cursor = get_db_cursor()
    
    cursor.execute("""
        SELECT
            TS1.TrainID,
            T.TrainName AS TrainName,
            Departure.StationID AS DepartureStationID,
            Departure.StationName AS DepartureStation,
            Destination.StationID AS DestinationStationID,
            Destination.StationName AS DestinationStation,
            (TS2.Distance - TS1.Distance) AS DistanceBetweenStations,
            T.FarePerKilometer AS FarePerKilometer,
            (TS2.Distance - TS1.Distance) * T.FarePerKilometer AS Fare
        FROM
            TrainStops TS1
        INNER JOIN
            TrainStops TS2 ON TS1.TrainID = TS2.TrainID AND TS1.Distance < TS2.Distance
        INNER JOIN
            Stations Departure ON TS1.StationID = Departure.StationID AND TS1.IsStop = 1
        INNER JOIN
            Stations Destination ON TS2.StationID = Destination.StationID
        INNER JOIN
            Trains T ON TS1.TrainID = T.TrainID
        WHERE
            Departure.StationID = ? AND Destination.StationID = ?
    """, (from_station_id, to_station_id))

    rows = cursor.fetchall()
    db.close()

    # Create a list of dictionaries, each representing a train
    trains = [
        {
            "TrainID": row[0],
            "TrainName": row[1],
            "DepartureStationID": row[2],
            "DepartureStationName": row[3],
            "DestinationStationID": row[4],
            "DestinationStationName": row[5],
            "DistanceBetweenStations": row[6],
            "FarePerKilometer": row[7],
            "Fare": row[8]
        }
        for row in rows
    ]

    return jsonify(trains), 200











@app.route('/api/book_ticket', methods=['POST'])
def book_ticket():
    # Extract parameters from the request
    user_id = request.json.get('user_id')
    train_id = request.json.get('train_id')
    departure_station_id = request.json.get('departure_station_id')
    arrival_station_id = request.json.get('arrival_station_id')

    # Establish database connection
    db, cursor = get_db_cursor()

    try:
        # Check if the user exists
        cursor.execute("SELECT * FROM Users WHERE UserID = ?", (user_id,))
        user = cursor.fetchone()
        if not user:
            db.close()
            return jsonify({'error': 'User not found'}), 404

        user_name = f"{user[3]} {user[4]}"  # Assuming FirstName is at index 3 and LastName is at index 4

        # Check if the train exists and get its capacity
        cursor.execute("SELECT * FROM TrainCapacity WHERE TrainID = ?", (train_id,))
        train_capacity = cursor.fetchone()
        if not train_capacity:
            db.close()
            return jsonify({'error': 'Train not found'}), 404

        # Assuming TrainCapacity columns are TrainID, Capacity, ReservedSeats
        capacity = train_capacity[1]  # Assuming Capacity is at index 1
        reserved_seats = train_capacity[2]  # Assuming ReservedSeats is at index 2

        # Check if there are available seats
        if reserved_seats >= capacity:
            db.close()
            return jsonify({'error': 'No available seats on the train'}), 400

        # Calculate fare and book the ticket
        cursor.execute("""
            SELECT (TS2.Distance - TS1.Distance) * T.FarePerKilometer AS Fare
            FROM TrainStops TS1
            INNER JOIN TrainStops TS2 ON TS1.TrainID = TS2.TrainID AND TS1.Distance < TS2.Distance
            INNER JOIN Stations Departure ON TS1.StationID = Departure.StationID AND TS1.IsStop = 1
            INNER JOIN Stations Destination ON TS2.StationID = Destination.StationID
            INNER JOIN Trains T ON TS1.TrainID = T.TrainID
            WHERE Departure.StationID = ? AND Destination.StationID = ?
            LIMIT 1
        """, (departure_station_id, arrival_station_id))

        fare_result = cursor.fetchone()
        if not fare_result:
            db.close()
            return jsonify({'error': 'Fare calculation error'}), 500

        fare = fare_result[0]  # Fetch the Fare value

        # Check user's wallet balance
        cursor.execute("SELECT Balance FROM Wallets WHERE UserID = ?", (user_id,))
        user_balance = cursor.fetchone()
        if not user_balance:
            db.close()
            return jsonify({'error': 'User wallet not found'}), 404

        user_balance = user_balance[0]  # Fetch the Balance value
        if user_balance < fare:
            db.close()
            return jsonify({'error': 'Insufficient balance'}), 400

        # Deduct fare from user's balance
        new_balance = user_balance - fare
        cursor.execute("UPDATE Wallets SET Balance = ? WHERE UserID = ?", (new_balance, user_id))

        # Get the next available seat number and reserve the seat
        cursor.execute("SELECT MAX(SeatNumber) FROM Tickets WHERE TrainID = ?", (train_id,))
        max_seat_number = cursor.fetchone()[0] or 0
        seat_number = max_seat_number + 1

        # Get the current date and time for ReservationDate
        current_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        # Insert the ticket into Tickets table
        cursor.execute("""
            INSERT INTO Tickets (UserID, TrainID, BoardingStationID, DisembarkingStationID, SeatNumber, Fare, TravelDate, IsReserved, ReservationDate, IsCancelled, CancellationDate, ReservationUserID)
            VALUES (?, ?, ?, ?, ?, ?, DATE('now'), 1, ?, 0, NULL, ?)
        """, (user_id, train_id, departure_station_id, arrival_station_id, seat_number, fare, current_datetime, user_id))

        # Update TrainCapacity: increment reserved seats count
        cursor.execute("UPDATE TrainCapacity SET ReservedSeats = ReservedSeats + 1 WHERE TrainID = ?", (train_id,))

        # Fetch train name from Trains table
        cursor.execute("SELECT TrainName FROM Trains WHERE TrainID = ?", (train_id,))
        train_name_result = cursor.fetchone()
        train_name = train_name_result[0] if train_name_result else 'Unknown Train'

        # Commit transaction and close database connection
        db.commit()
        db.close()

        # Return the response in the desired format
        return jsonify({
            'train_name': train_name,
            'user_id': user_id,
            'user_name': user_name,
            'fare': fare,
            'seat_number': seat_number,
            'new_balance': new_balance
        }), 200

    except Exception as e:
        db.rollback()
        db.close()
        return jsonify({'error': str(e)}), 500
















@app.route('/api/check_available_tickets', methods=['GET'])
def check_available_tickets():
    # Extract parameters from request
    request_data = request.json
    departure_station_id = request_data.get('departure_station_id')
    arrival_station_id = request_data.get('arrival_station_id')
    train_id = request_data.get('train_id')
    date = request_data.get('date')  # Assuming date is passed in a suitable format (e.g., 'YYYY-MM-DD')

    # Establish database connection
    db, cursor = get_db_cursor()

    try:
        # Fetch train details (name and ID)
        cursor.execute("SELECT TrainName FROM Trains WHERE TrainID = ?", (train_id,))
        train_result = cursor.fetchone()
        if not train_result:
            db.close()
            return jsonify({'error': 'Train not found'}), 404
        train_name = train_result[0]

        # Calculate fare for the journey
        cursor.execute("""
            SELECT (TS2.Distance - TS1.Distance) * T.FarePerKilometer AS Fare
            FROM TrainStops TS1
            INNER JOIN TrainStops TS2 ON TS1.TrainID = TS2.TrainID AND TS1.Distance < TS2.Distance
            INNER JOIN Stations Departure ON TS1.StationID = Departure.StationID AND TS1.IsStop = 1
            INNER JOIN Stations Destination ON TS2.StationID = Destination.StationID
            INNER JOIN Trains T ON TS1.TrainID = T.TrainID
            WHERE Departure.StationID = ? AND Destination.StationID = ?
            LIMIT 1
        """, (departure_station_id, arrival_station_id))
        fare_result = cursor.fetchone()
        if not fare_result:
            db.close()
            return jsonify({'error': 'Fare calculation error'}), 500
        fare = fare_result[0]

        # Fetch total train capacity and reserved seats from TrainCapacity table
        cursor.execute("SELECT Capacity, ReservedSeats FROM TrainCapacity WHERE TrainID = ?", (train_id,))
        capacity_result = cursor.fetchone()
        if not capacity_result:
            db.close()
            return jsonify({'error': 'Train capacity not found'}), 404
        total_capacity = capacity_result[0]
        reserved_seats = capacity_result[1]

        # Count booked tickets for the train on the specified date
        cursor.execute("""
            SELECT COUNT(*) FROM Tickets
            WHERE TrainID = ? AND TravelDate = ? AND IsCancelled = 0
        """, (train_id, date))
        booked_count_result = cursor.fetchone()
        booked_count = booked_count_result[0] if booked_count_result else 0

        # Calculate available ticket count
        available_tickets = total_capacity - reserved_seats - booked_count

        # Close the database connection
        db.close()

        # Return the response
        return jsonify({
            'train_name': train_name,
            'train_id': train_id,
            'fare': fare,
            'available_tickets': available_tickets
        }), 200

    except Exception as e:
        db.close()
        return jsonify({'error': str(e)}), 500
















@app.route('/api/highest_sold_tickets', methods=['GET'])
def highest_sold_tickets():
    # Extracting the start_date and end_date parameters from the request
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    # Debug: Log the dates received from the request
    print(f"Received start_date: {start_date}, end_date: {end_date}")

    # Establishing a connection to the database
    db, cursor = get_db_cursor()

    try:
        # Check if the date parameters are provided
        if not start_date or not end_date:
            db.close()
            return jsonify({'error': 'Both start_date and end_date parameters are required'}), 400

        # Ensuring the dates are in the correct format
        try:
            formatted_start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
            formatted_end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
        except ValueError:
            db.close()
            return jsonify({'error': 'Invalid date format. Expected YYYY-MM-DD'}), 400

        # Debug: Log the formatted dates being used in the query
        print(f"Querying for tickets between: {formatted_start_date} and {formatted_end_date}")

        # Executing SQL query to find the date with the maximum number of sold tickets in the range
        cursor.execute("""
            SELECT TravelDate, MAX(SoldTickets) as MaxSoldTickets
            FROM (
                SELECT DATE(TravelDate) as TravelDate, COUNT(*) as SoldTickets
                FROM Tickets
                WHERE DATE(TravelDate) BETWEEN ? AND ? AND IsReserved = 1
                GROUP BY DATE(TravelDate)
            ) as subquery
        """, (formatted_start_date, formatted_end_date))
        
        result = cursor.fetchone()

        # Debug: Log the result of the query
        if result:
            highest_sold_date = result[0]
            highest_sold_tickets = result[1]
            print(f"Highest sold tickets count: {highest_sold_tickets} on {highest_sold_date}")
        else:
            highest_sold_date = None
            highest_sold_tickets = 0
            print("No tickets sold in the given date range")

        # Closing the database connection
        db.close()

        # Returning the highest sold tickets count and the corresponding date
        return jsonify({
            'highest_sold_date': highest_sold_date,
            'highest_sold_tickets': highest_sold_tickets
        }), 200

    except Exception as e:
        db.close()
        return jsonify({'error': str(e)}), 500