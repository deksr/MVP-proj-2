DROP DATABASE IF EXISTS discussiondb;

CREATE DATABASE discussiondb;

\c discussiondb;


CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,

  password VARCHAR NOT NULL
);


CREATE TABLE topicname(
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  topic_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL

);


CREATE TABLE comments(
id SERIAL PRIMARY KEY,
user_id INTEGER NOT NULL REFERENCES users(id),
topic_id INTEGER NOT NULL REFERENCES topicname(id),
message VARCHAR NOT NULL
);


