# Use a base image with a shell
FROM alpine

# Set the working directory in the container
WORKDIR /app

# Copy the shell script into the container
COPY script.sh .

# Make the shell script executable
RUN chmod +x script.sh

# Run the shell script when the container starts
CMD ["./script.sh"]
