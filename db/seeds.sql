\c discussiondb;

TRUNCATE TABLE users, topicname, comments RESTART IDENTITY; 


INSERT INTO users
  (name, email, password, created_at)
VALUES
  ('Ann', 'ann@ga.com', 'admin', CURRENT_TIMESTAMP),
  ('Devs', 'dev@dev.com', 'admin2', CURRENT_TIMESTAMP);

INSERT INTO topicname
  (user_id, topic_name, created_at)
VALUES
  (1, 'Barcelona', CURRENT_TIMESTAMP),
  (2, 'Prague', CURRENT_TIMESTAMP);

INSERT INTO comments
(user_id, topic_id, message)
VALUES
  (1, 1, 'Museum worth it? '),
  (2, 2, 'Where did you guys stay?');


SELECT * FROM users;
SELECT * FROM topicname;
SELECT * FROM comments;



