# Service Management Application

This project is a Service Management application that includes a React frontend and a Flask backend. The application allows users to manage services, track incidents, and stay informed about the status of various services.

## Prerequisites

- Node.js and npm
- Python 3.x
- PostgreSQL

## Setting Up the React Frontend

1. Navigate to the client directory:
   ```bash
   cd client
   ```

2. Install the dependencies:
   ```bash
   npm install
   ```

3. Start the React development server:
   ```bash
   npm start
   ```

The React app will be running on `http://localhost:3000`.

## Setting Up the Flask Backend

1. Navigate to the server directory:
   ```bash
   cd server
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   ```

3. Activate the virtual environment:
   - On Windows:
     ```bash
     .\venv\Scripts\activate
     ```
   - On macOS and Linux:
     ```bash
     source venv/bin/activate
     ```

4. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Run the Flask server:
   ```bash
   flask run
   ```

The Flask server will be running on `http://localhost:5000`.

## Navigating the Application

- **Landing Page**: The entry point of the application where users can sign in or check the service status.
- **Service Status**: Click on "Check Service Status" to view the current status of services.
- **Sign In**: Use the "Sign In" button to authenticate and access more features.

## Database Setup

Ensure PostgreSQL is running and create the necessary database and tables using the provided SQL scripts in the `models.py` file.

## Notes

- Ensure that the backend server is running before accessing the frontend application.
- Update the database connection settings in `config.py` as needed.

---

This README provides a basic setup guide. For more detailed information, refer to the documentation or contact the project maintainers. 