### `Note: This Branch Is For Study Purpose`

# Messenger API

A simple messaging API built with Ruby on Rails that allows users to create and manage conversations, send and receive messages, and track message read status. The Messenger API provides a backend service for a messaging application, supporting basic messaging functionalities such as creating conversations, sending messages, and marking messages as read.

## Version
* Rails v6.1.7
* Ruby v2.7.2
* Database postgreSQL
* Bundle v2.1.4

## Features

- Create and manage conversations
- Send and receive messages
- Track read status of messages
- Retrieve conversations with the latest message and unread message count

## Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/mukhlish32/messenger-api.git
    cd messenger-api
    ```

2. **Install dependencies:**

    Make sure you have Ruby and Bundler installed. Then run:

    ```bash
    bundle install
    ```

3. **Setup the database:**

   This project uses PostgreSQL. Ensure you have PostgreSQL installed and running on your machine. You can download it from the [official site](https://www.postgresql.org/download/). Update the `config/database.yml` file with your PostgreSQL credentials.


    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

5. **Start the server:**

    ```bash
    rails server
    ```

## API Endpoints
### Conversations
- `GET /conversations` - Retrieves a list of conversations with the latest message and unread message count
- `GET /conversations/:id` - Retrieves a specific conversation with detailed information
### Messages
- `GET /conversations/:conversation_id/messages` - Retrieves messages for a specific conversation
- `POST /messages` - Create and Send a message in a conversation
- `GET /messages/:id` - Retrieves a specific message and updates its read status

## Testing

To run the tests, use the following command:

```bash
bundle exec rspec
```

Ensure that you have set up the test database:

```bash
rails db:test:prepare
```


## Case Study

### Problem Statement

In a hypothetical scenario, a company needs to implement a messaging system for their customer service platform. The requirements are as follows:
1. **Conversations Management**: Support creating, listing, and retrieving conversations between users and customer service agents.
2. **Message Handling**: Allow sending and receiving messages within these conversations.
3. **Read Status Tracking**: Track whether a message has been read and update the read status when a message is viewed.
4. **Accurate Data Retrieval**: Ensure that conversation data includes the latest message and the count of unread messages for each conversation.

### Solution

The Messenger API was designed to meet these requirements using the following features:

1. **Conversations Management**: The API supports creating conversations and retrieving a list of conversations with the last message and unread count.
2. **Message Handling**: Messages can be sent within conversations, and each message is associated with a sender and a conversation.
3. **Read Status Tracking**: When a message is viewed, the `read_at` attribute is updated to indicate the message has been read.
4. **Accurate Data Retrieval**: Custom serializers ensure that conversation data includes relevant details such as the latest message and unread count.

### Database Details

The database consists of three main tables: `users`, `conversations`, and `messages`. Below is a detailed explanation of each table and their relationships.

#### Tables

1. **Users**

    This table stores information about users who participate in conversations.

    - `id`: Primary key
    - `name`: String - The name of the user
    - `email`: String - The email of the user
    - `password`: String - The password of the user
    - `photo_url`: String - The URL of the user's profile photo
    - `created_at`: Timestamp - The date and time the user was created
    - `updated_at`: Timestamp - The date and time the user was last updated

2. **Conversations**

    This table stores information about conversations between users.

    - `id`: Primary key
    - `user_id`: Foreign key - The ID of the user who started the conversation
    - `with_user_id`: Foreign key - The ID of the user with whom the conversation is held
    - `created_at`: Timestamp - The date and time the conversation was created
    - `updated_at`: Timestamp - The date and time the conversation was last updated

    A conversation is established between two users, `user_id` and `with_user_id`.

3. **Messages**

    This table stores messages exchanged within conversations.

    - `id`: Primary key
    - `conversation_id`: Foreign key - The ID of the conversation to which the message belongs
    - `sender_id`: Foreign key - The ID of the user who sent the message
    - `message`: String - The content of the message
    - `read_at`: Timestamp - The date and time the message was read
    - `created_at`: Timestamp - The date and time the message was created
    - `updated_at`: Timestamp - The date and time the message was last updated

#### Relationships

- **Users and Conversations:**
  - A user can have many conversations (`has_many :conversations`).
  - A conversation involves two users (`belongs_to :user`, `belongs_to :with_user`, where `with_user` is also a reference to the `User` model).

- **Conversations and Messages:**
  - A conversation can have many messages (`has_many :messages`).
  - A message belongs to one conversation (`belongs_to :conversation`).

- **Users and Messages:**
  - A user can send many messages (`has_many :messages`, foreign_key: 'sender_id').
  - A message is sent by one user (`belongs_to :sender`, class_name: 'User').


### Implementation Details

- **Creating and Managing Conversations**: The `ConversationsController` handles endpoints related to conversation creation and retrieval. Custom serializers like `ConversationSerializer` format the conversation data.
- **Sending and Receiving Messages**: The `MessagesController` manages message creation and retrieval. The `MessageSerializer` formats message data, including sender details and timestamps.
- **Tracking Read Status**: The `show` action in `MessagesController` updates the `read_at` timestamp before rendering the message as JSON.

### Example

Here’s a practical example of how the API is used:

1. **Creating a Conversation**: A user initiates a conversation with a customer service agent.
2. **Sending Messages**: The user and agent exchange messages within the conversation.
3. **Viewing a Message**: When the agent views a message, the `read_at` timestamp is updated to reflect the read status.

## Screenshot
![image](https://github.com/mukhlish32/messenger-api/assets/85531251/ae969d00-c3c1-4405-a5d3-698012295307)
