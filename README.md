# Project Name

## Introduction
- This Project is implemeted based on the requirements given by coffee beans for implementing Event Trigger and Email Notification System.
## Assumptions made
- For making the work done I have made some assumptions.
    - CAMPAIN ID is static and will loaded from ENV.
    - User need to register to enter into the system.
    - When event name is not provided for event creation api responds with 400

## Installation
- git clone https://github.com/rvkrish/EventBeans.git
- cd EventBeans
- bundle install
- rake db:migrate
- add .env on your root directory and add below test keys
CAMPAIN_ID=1234
BASE_URI=https://api.iterable.com/api
EVENT_TRACK_URI=/events/track
EVENT_TARGET_URI=/email/target
ITERABLE_API_KEY="random_key"
- rails s


## Usage

- By default application will be redirected to login page.
  <img src='https://github.com/rvkrish/EventBeans/blob/e33fabd34ee8bec058bdec7d7b8e1b1e9c3cc08f/public/screenshots/Login.png' width='400'>

- You need to register to access the tool.
  <img src='https://github.com/rvkrish/EventBeans/blob/e33fabd34ee8bec058bdec7d7b8e1b1e9c3cc08f/public/screenshots/Register.png' width='400'>
- Once registered you will be able to see the buttons to click for creating events
  <img src='https://github.com/rvkrish/EventBeans/blob/e33fabd34ee8bec058bdec7d7b8e1b1e9c3cc08f/public/screenshots/home.png' width='400'>

## RSpec and Test coverage.

Run simple `rspec` command run the specs.
where i have covered following scenarios


- Controller:
  - Succes/Fail of API call when creating event A.
  - While creating event b 
    - creation and email sending successful.
    - Event creation is success but email sending fail.
    - Event creation fails.
  - API Service
    - When API responds for event creation with success.
    - when API responds for event creation with fail.
    - when Provided invalid event name.
    - when provided empty event name.
    - When provided invalid email how service method respond both while event creation and mail creation.
    - When invalid or empty campain id is provided. 


## Features
- I have implemented the code but it wont work until we have a proper api key from https://api.iterable.com/api/doc 


