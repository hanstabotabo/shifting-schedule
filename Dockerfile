# Use an official CentOS image as the base
FROM centos:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the bash script and other necessary files into the container
COPY . .

# Make sure the bash script is executable
RUN chmod +x shift_sched.sh

# Install bash (already present in CentOS) and any other necessary dependencies
RUN yum update -y && yum clean all && yum install -y bash

# Define the command to run your bash script
ENTRYPOINT ["./shift_sched.sh"]
