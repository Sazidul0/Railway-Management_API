#official Python image
FROM python:3.11.5-slim-bookworm

# Set environment variables
ENV DOCKER_BUILDKIT=1
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8000

# Set the working directory
WORKDIR /app

# Copy all files from the current directory to /app in the container
COPY . .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Run any initialization scripts (StartDb.py in your case)
RUN python StartDb.py

# Expose the port for the Flask app
EXPOSE 8000

# Command to run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=8000"]

