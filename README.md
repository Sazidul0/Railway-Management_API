# Railway Management API

This project is a Railway Management API built using Flask. The API provides various endpoints to manage users, trains, tickets, and employees. It also includes a Docker file for easy setup and deployment.

## Features

- **User Management**
  - Insert a new user
  - Search user by ID or email
  - List all users
  - List active users

- **Train Management**
  - List all trains
  - Search trains from one station to another
  - Check train capacity

- **Ticket Management**
  - Book a ticket
  - Check available tickets
  - List sold tickets by date
  - Get total sell between dates
  - Get highest sold tickets between dates

- **Employee Management**
  - List all employees
  - Search employee by ID
  
- **Wallet Management**
  - Create or update user wallets


## Endpoints

- `POST /api/insertUser` - Insert a new user
- `GET /api/users` - List all users
- `GET /api/active_users` - List active users
- `GET /api/search_user?name=<User Name>` - Search user by Name
- `GET /api/search_user_by_email?email=<email>` - Search user by email
- `GET /api/trains` - List all trains
- `GET /api/search_trains?from=<from_station>&to=<to_station>` - Search trains from one station to another
- `GET /api/train_capacity?train_id=<train_id>` - Check train capacity
- `POST /api/book_ticket` - Book a ticket
- `GET /api/check_available_tickets?departure_station_id=<station_id>&arrival_station_id=<station_id>` - Check available tickets
- `GET /api/sold_tickets_by_date?date=<date>` - List sold tickets by date
- `GET /api/total_sell_between_dates?start_date=<start_date>&end_date=<end_date>` - Get total sell between dates
- `GET /api/highest_sold_tickets?start_date=<start_date>&end_date=<end_date>` - Get highest sold tickets between dates
- `GET /api/list_employees` - List all employees
- `GET /api/search_employee_by_id?id=<id>` - Search employee by ID
- `POST /api/wallets` - Create or update user wallet


### Prerequisites

- Docker

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/your-username/railway-management-api.git
   cd railway-management-api

2. Build the Docker image:

   ```sh
   docker build -t railway-system .

4. Run the Docker container:

   ```sh
   docker run -p 8000:8000 railway-system
   
