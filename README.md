# SplitIt Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Features Overview](#features-overview)
3. [User Authentication](#user-authentication)
4. [Group Management](#group-management)
5. [Expense Management](#expense-management)
6. [Debt Tracking](#debt-tracking)
7. [Settlement and Payment Tracking](#settlement-and-payment-tracking)
8. [Email Notifications](#email-notifications)
9. [Payment Reports](#payment-reports)
10. [Technology Stack](#technology-stack)
11. [Setup and Installation](#setup-and-installation)
12. [Contact](#contact)

## Introduction

SplitIt is a Flutter application designed to simplify the management of shared expenses. It enables users to create groups, manage expenses, track debts, and settle payments manually with ease. SplitIt is built with a focus on simplicity, security, and user-friendly experience, catering to a wide range of use cases like shared household expenses, trips, friendly expenses, and events.

## Features Overview

- **User Authentication**: Secure registration, login, and logout.
- **Group Management**: Create and manage groups with customizable members.
- **Expense Management**: Add, categorize, and split expenses among group members.
- **Debt Tracking**: Automatic calculation and tracking of balances between users.
- **Settlement and Payment Tracking**: Manual recording of settlements and payments.
- **Notifications**: Email notifications for group activities like expense creation and for payment reminders.
- **Reporting**: Generate and download payments report.

## User Authentication

- **Registration**: New users can register using their email and a secure password. Passwords are hashed and stored securely in the database.
- **Login**: Users can log in using their email and password.
- **Logout**: Users can log out securely.
- **Security Measures**:
  - Passwords are hashed using industry-standard encryption.
  - Sessions are managed securely to prevent unauthorized access.

![Simulator Screenshot - iPhone 15 Pro Max - 2024-08-28 at 12 27 43](https://github.com/user-attachments/assets/90b9e868-bdca-4b68-adb3-a26c9f388c7a.webp)


## Group Management

- **Create Groups**: 
    - Users can create groups for managing shared expenses.
    - Each group requires a name and a description.
- **Manage Group Members**: The group creator can add or remove members as needed.
- **Group List Management**: Users can view all their created groups and the members within each group.

## Expense Management

- **Create Expenses**: Users can create new expenses and add description for each created expense.
- **Expense Details**: Each expense includes:
  - Amount
  - Date
  - Description
  - Paid By (user who paid for the expense)
- **Splitting Expenses**: Expenses are split equally among all group participants.
- **Expense History**: Users can view the history of all expenses in each group.
  

## Debt Tracking

- **Automatic Debt Calculation**: After an expense is recorded, the app automatically updates the debts between users within the group.
- **Debt Overview**: Users can see a summary of who owes whom and how much within each group.

## Settlement and Payment Tracking

- **Manual Settlement Recording**: Users can manually record cash settlements between members.
- **Payment History**: The app maintains a history of all settlements and payments for transparency and record-keeping.

## Email Notifications

- **Real-Time Notifications**: Users receive notifications for:
  - New expenses added
  - Reminders for payment
- **Notification Methods**: Notifications are sent via email.

## Payment Reports

- **Expense Reports**: Users can generate report for the payments involving them.
- **Export Options**: Reports are exported in CSV(comma separated values) format.

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Golang
- **Database**: MySQL
- **Authentication**: JWT
- **Hosting**: Database and backend are hosted on AWS
- **Application**: The android application can be downloaded from [here](https://github.com/sakshamnegi07/Split-it_FE/releases/tag/v1.0.0)

## Setup and Installation

### Prerequisites:

 #### To set up and run the SplitIt Flutter project locally, ensure you have the following   installed and configured:
 
- **Flutter SDK**: Make sure you have the Flutter SDK installed and the SDK path is set correctly. You can download it from the official Flutter website.
- **Golang**: Download and install Go from the official Go website. Set up your Go environment by configuring the $GOPATH and adding $GOROOT/bin to your system's PATH.
- **MySQL**: Make sure to configure MySQL and note down the username, password, and database name, as you'll need these for database connection in your environment variables.
- **Git**: Ensure you have Git installed on your machine. You can download it from Git's official website.
- **Editor**: Install an editor or IDE with Flutter support, such as Visual Studio Code or Android Studio.
- **Device or Emulator**: Set up an Android Emulator, iOS Simulator, or connect a physical device for testing.

### MySQL setup:

1. **Create a database**:
   ```bash
   CREATE DATABASE `database_name`
   USE `database_name`
   ```
   
2. **Create tables**:
    ```bash
    CREATE TABLE `balances` (
      `group_id` int DEFAULT NULL,
      `lender` bigint DEFAULT NULL,
      `borrower` bigint DEFAULT NULL,
      `amount` decimal(10,2) NOT NULL,
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `balance_id` int NOT NULL AUTO_INCREMENT,
      PRIMARY KEY (`balance_id`)
    );
    
    CREATE TABLE `expenses` (
      `expense_id` int NOT NULL AUTO_INCREMENT,
      `group_id` int DEFAULT NULL,
      `description` varchar(255) NOT NULL,
      `amount` decimal(10,2) NOT NULL,
      `paid_by` bigint DEFAULT NULL,
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`expense_id`)
    );

    CREATE TABLE `groups` (
      `group_id` int NOT NULL AUTO_INCREMENT,
      `group_name` varchar(255) NOT NULL,
      `group_description` text,
      `created_by` bigint unsigned NOT NULL,
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `deleted_at` datetime DEFAULT NULL,
      PRIMARY KEY (`group_id`),
      KEY `created_by` (`created_by`),
      CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
    );
    
    CREATE TABLE `members` (
      `user_id` bigint DEFAULT NULL,
      `group_id` int DEFAULT NULL,
      `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `deleted_at` timestamp NULL DEFAULT NULL
    );
    
    CREATE TABLE `payments` (
      `payment_id` int NOT NULL AUTO_INCREMENT,
      `paid_by` bigint DEFAULT NULL,
      `paid_to` bigint DEFAULT NULL,
      `amount` decimal(10,2) NOT NULL,
      `paid_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`payment_id`)
    );
    
    CREATE TABLE `reminders` (
      `reminder_id` int NOT NULL AUTO_INCREMENT,
      `sent_by` bigint DEFAULT NULL,
      `sent_to` bigint DEFAULT NULL,
      `amount` decimal(10,2) NOT NULL,
      `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`reminder_id`)
    );

    CREATE TABLE `users` (
      `id` bigint unsigned NOT NULL AUTO_INCREMENT,
      `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `deleted_at` timestamp NULL DEFAULT NULL,
      `username` varchar(255) NOT NULL,
      `email` varchar(255) NOT NULL,
      `password` varchar(255) NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `username` (`username`),
      UNIQUE KEY `email` (`email`)
    );
    ```

### Backend Setup:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sakshamnegi07/Split-it_BE.git
   ```
   
2. **Navigate to the root directory**:
    ```bash
   cd Split-it_BE/main
   ```

3. **Environment Variables**: 
   Create a `.env` file and add the necessary environment variables:
   - `AWS_DSN` for data source name which has your database credentials
   - `JWT_KEY` for authentication using jwt secret key
   - `MAIL_HOST` for email host port number
   - `MAIL_ADDRESS` for email host address
   - `MAIL_PASS` for app password for your email
   - `PORT` for specifying port number (9090 by default)

4. **Run the Server**:
   ```bash
   # installs dependencies and starts server
   go run main.go
   ```

### Frontend Setup:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sakshamnegi07/Split-it_FE.git
   ```
   
2. **Navigate to the root directory**:
    ```bash
   cd Split-it_FE
   ```

3. **Install dependencies**:
   ```bash
    # Install flutter dependencies
    flutter pub get
    
    # Ensure your flutter environment is correctly setup by running
    flutter doctor
   ```

3. **Start an emulator and run the application**:
    ```bash
    flutter run
    ```

## Contact

Reach out to me at saksham.negi@supersixsports.com for any questions, feedback, or collaboration opportunities.
