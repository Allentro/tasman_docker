# TALYS dockerfile
FROM ubuntu:20.04

MAINTAINER Ross Allen (rossallen1996@gmail.com) 


ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y gfortran && \
    apt install -y nano
    
### INSTALLING TALYS ################################
RUN mkdir /home/bin

ADD talys.tar /home/bin

WORKDIR "/home/bin/talys/source" 

# Editing setup file to have correct home directory location
RUN sed -i "s|bindir=$Thome'/bin'|bindir='/home' |g" /home/bin/talys/talys.setup

#changing path in machine.f
RUN sed -i "s|home='/Users/koning/'|home='/home/'|g" /home/bin/talys/source/machine.f

ENV PATH="/home/talys:${PATH}"
### INSTALLING TASMAN ################################

# Adding TASMAN tar to OS
ADD tasman.tar /home/bin

WORKDIR "/home/bin/tasman/source" 

# Editing setup file to have correct home directory location
RUN sed -i "s|bindir=$Thome'/bin'|bindir='/home' |g" /home/bin/tasman/tasman.setup

#changing path in machine.f
RUN sed -i "s|home='/Users/koning/'|home='/home/'|g" /home/bin/tasman/source/machine.f

#Compiling TALYS 
RUN gfortran -c *.f && \
    gfortran *.o -o tasman && \
    mv tasman /bin
    
# Adding TASMAN to path 
ENV PATH="/home/bin/tasman:/home/bin/talys:/home/bin:${PATH}"

# Install base utilities
RUN apt-get update && \
    apt-get -y install gedit && \
    apt-get -y install curl && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Creating test environment (will be removed in full deployment) 
RUN mkdir /home/test
ADD input /home/test/
WORKDIR "/home/test"



