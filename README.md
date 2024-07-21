SQL Data Analysis Project: Financial Transactions Dataset
Overview

This project involves analyzing a financial transactions dataset using SQL to extract valuable insights and perform various analyses. The dataset includes transactions such as Payments, Transfers, Cash Outs, and Debits, with attributes like transaction amounts, original and new balances, account identifiers, and fraud indicators.
Table of Contents

    Dataset
    Key Analyses and Queries
        Classifying Transactions Based on Amount
        Identifying Suspicious Transactions
        Total Amount Transacted by Each Account
        Accounts with Multiple Transaction Types
        Top 3 Largest Transactions per Account
        Detecting Accounts with Multiple Fraudulent Transactions
    Project Highlights
    Outcome
    Getting Started
    License

Dataset

The dataset includes various types of financial transactions with the following attributes:

    step: Time step (hour) of the transaction.
    type: Type of transaction (e.g., PAYMENT, TRANSFER).
    amount: Transaction amount.
    nameOrig: Identifier of the originating account.
    oldbalanceOrg: Original balance of the originating account before the transaction.
    newbalanceOrig: New balance of the originating account after the transaction.
    nameDest: Identifier of the destination account.
    oldbalanceDest: Original balance of the destination account before the transaction.
    newbalanceDest: New balance of the destination account after the transaction.
    isFraud: Indicator if the transaction is fraudulent.
    isFlaggedFraud: Indicator if the transaction is flagged as potentially fraudulent.

Project Highlights

    Conditional Logic and Classification: Used CASE statements to classify transaction amounts and flag suspicious transactions.
    Common Table Expressions (CTEs): Simplified complex queries with CTEs for better readability and maintenance.
    Window Functions: Employed window functions to rank transactions and extract the top entries for each account.
    Data Aggregation: Filtered and aggregated data to identify trends and suspicious activities across the dataset.

  Outcome

This project provided a comprehensive analysis of financial transactions, showcasing the power of SQL in data analysis and fraud detection. It was an excellent opportunity to deepen my understanding of SQL functions and enhance my data analytical skills.
