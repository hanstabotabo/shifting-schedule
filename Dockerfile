# CentOS Official Docker Image 
FROM centos:latest

# Install bash and any other dependencies (if required)
RUN sudo yum update -y && sudo yum install bash -y

# Set the working directory inside the container
WORKDIR /app

# Copy the bash script and any other files needed into the container
COPY . .

# Make the bash script executable
RUN chmod +x shift_sched.sh

# Define the entrypoint to run the bash script
ENTRYPOINT ["./shift_sched.sh"]
