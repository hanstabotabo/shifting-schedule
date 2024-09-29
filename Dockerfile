# Use an official CentOS image as the base
FROM centos:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the bash script and other necessary files into the container
COPY shift_sched.sh /app/shift_sched.sh

# Make sure the bash script is executable
RUN chmod +x /app/shift_sched.sh

# Define the command to run your bash script
ENTRYPOINT ["/app/shift_sched.sh"]
