CREATE TABLE IF NOT EXISTS motor (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   name TEXT NOT NULL UNIQUE, 
   pulseWidthMin INTEGER NOT NULL, 
   pulseWidthMax INTEGER NOT NULL, 
   rotationRangeMin INTEGER NOT NULL, 
   rotationRangeMax INTEGER NOT NULL, 
   velocity INTEGER NOT NULL, 
   acceleration INTEGER NOT NULL, 
   deceleration INTEGER NOT NULL, 
   period INTEGER NOT NULL, 
   turnedOn BOOLEAN NOT NULL, 
   visible BOOLEAN NOT NULL,
   invert BOOLEAN NOT NULL);

INSERT INTO motor(name, pulseWidthMin, pulseWidthMax, rotationRangeMin, rotationRangeMax, velocity, acceleration, deceleration, period, turnedOn, visible, invert) VALUES
   ('tilt_forward_motor', 700, 2500, -4500, 4500, 16000, 10000, 5000, 19500, TRUE,TRUE, FALSE),
   ('tilt_sideways_motor', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, FALSE, FALSE),
   ('turn_head_motor', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('thumb_left_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('thumb_left_opposition', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('index_left_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('middle_left_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('ring_left_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('pinky_left_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('thumb_right_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('thumb_right_opposition', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('index_right_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('middle_right_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('ring_right_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('pinky_right_stretch', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('upper_arm_left_rotation', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('elbow_left', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('lower_arm_left_rotation', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('wrist_left', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('shoulder_vertical_left', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('shoulder_horizontal_left', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('upper_arm_right_rotation', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('elbow_right', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('lower_arm_right_rotation', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('wrist_right', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('shoulder_vertical_right', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE),
   ('shoulder_horizontal_right', 700, 2500, -9000, 9000, 16000, 10000, 5000, 19500, TRUE, TRUE, FALSE);

CREATE TABLE IF NOT EXISTS personality (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   personalityId Text UNIQUE NOT NULL, 
   name Text NOT NULL, 
   gender Text NOT NULL, 
   description Text, 
   pauseThreshold Numeric NOT NULL);

INSERT INTO personality(personalityId, name, gender, description, pauseThreshold) VALUES
   ("8f73b580-927e-41c2-98ac-e5df070e7288", "Eva", "Female", NULL, 0.8),
   ("8b310f95-92cd-4512-b42a-d3fe29c4bb8a", "Thomas", "Male", NULL, 0.8);

CREATE TABLE IF NOT EXISTS cameraSettings (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   resolution Text NOT NULL, 
   refreshRate Numeric NOT NULL, 
   qualityFactor INTEGER NOT NULL, 
   resX Integer NOT NULL, 
   resY Integer NOT Null);

INSERT INTO cameraSettings(resolution, refreshRate, qualityFactor, resX, resY) VALUES
   ("SD", 0.1, 80, 640, 480);

CREATE TABLE IF NOT EXISTS bricklet (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   uid TEXT UNIQUE NOT NULL,
   brickletNumber INTEGER UNIQUE NOT NULL
);

INSERT INTO bricklet(uid, brickletNumber) VALUES 
   ("AAA", 1), 
   ("BBB", 2), 
   ("CCC", 3);

CREATE TABLE IF NOT EXISTS brickletPin (
   id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
   brickletId INTEGER NOT NULL, 
   motorId INTEGER NOT NULL, 
   pin INTEGER NOT NULL,
   invert BOOLEAN NOT NULL,  
   FOREIGN KEY (brickletId) REFERENCES bricklet(id), 
   FOREIGN KEY (motorId) REFERENCES motor(id));

INSERT INTO brickletPin(motorId, brickletId, pin, invert) VALUES
   ((SELECT id FROM motor WHERE name = "turn_head_motor"), 1, 0, FALSE),
   ((SELECT id FROM motor WHERE name = "tilt_forward_motor"), 1, 1, FALSE),
   ((SELECT id FROM motor WHERE name = "tilt_sideways_motor"), 2, 8, FALSE),
   ((SELECT id FROM motor WHERE name = "thumb_left_opposition"), 1, 9, FALSE),
   ((SELECT id FROM motor WHERE name = "thumb_left_stretch"), 2, 0, FALSE),
   ((SELECT id FROM motor WHERE name = "index_left_stretch"), 2, 1, FALSE),
   ((SELECT id FROM motor WHERE name = "middle_left_stretch"), 2, 2, FALSE),
   ((SELECT id FROM motor WHERE name = "ring_left_stretch"), 2, 3, FALSE),
   ((SELECT id FROM motor WHERE name = "pinky_left_stretch"), 2, 4, FALSE),
   ((SELECT id FROM motor WHERE name = "thumb_right_opposition"), 1, 3, FALSE),
   ((SELECT id FROM motor WHERE name = "thumb_right_stretch"), 1, 4, FALSE),
   ((SELECT id FROM motor WHERE name = "index_right_stretch"), 1, 5, FALSE),
   ((SELECT id FROM motor WHERE name = "middle_right_stretch"), 1, 6, FALSE),
   ((SELECT id FROM motor WHERE name = "ring_right_stretch"), 1, 7, FALSE),
   ((SELECT id FROM motor WHERE name = "pinky_right_stretch"), 1, 8, FALSE),
   ((SELECT id FROM motor WHERE name = "upper_arm_left_rotation"), 2, 5, FALSE),
   ((SELECT id FROM motor WHERE name = "elbow_left"), 2, 6, FALSE),
   ((SELECT id FROM motor WHERE name = "lower_arm_left_rotation"), 2, 7, FALSE),
   ((SELECT id FROM motor WHERE name = "wrist_left"), 1, 2, FALSE),
   ((SELECT id FROM motor WHERE name = "shoulder_vertical_left"), 3, 7, TRUE),
   ((SELECT id FROM motor WHERE name = "shoulder_vertical_left"), 3, 9, FALSE),
   ((SELECT id FROM motor WHERE name = "shoulder_horizontal_left"), 3, 0, FALSE),
   ((SELECT id FROM motor WHERE name = "upper_arm_right_rotation"), 3, 1, FALSE),
   ((SELECT id FROM motor WHERE name = "elbow_right"), 3, 2, FALSE),
   ((SELECT id FROM motor WHERE name = "lower_arm_right_rotation"), 3, 3, FALSE),
   ((SELECT id FROM motor WHERE name = "wrist_right"), 3, 4, FALSE),
   ((SELECT id FROM motor WHERE name = "shoulder_vertical_right"), 3, 5, TRUE),
   ((SELECT id FROM motor WHERE name = "shoulder_vertical_right"), 3, 8, FALSE),
   ((SELECT id FROM motor WHERE name = "shoulder_horizontal_right"), 3, 6, FALSE);

CREATE TABLE IF NOT EXISTS program (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   name TEXT NOT NULL, 
   codeVisual TEXT NOT NULL, 
   programNumber TEXT UNIQUE NOT NULL);
   
INSERT INTO program(name, codeVisual, programNumber) VALUES
   ("hello_world", '{"blocks":{"languageVersion":0,"blocks":[{"type":"text_print","id":"]l,+vC{q$rZPVdSfyx=4","x":229,"y":67,"inputs":{"TEXT":{"shadow":{"type":"text","id":"v,}3JGN5d7og[X_/KJ)|","fields":{"TEXT":"hello world"}}}}}]}}', "e1d46e2a-935e-4e2b-b2f9-0856af4257c5");

CREATE TABLE IF NOT EXISTS chat (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   chatid TEXT UNIQUE NOT NULL,
   topic TEXT NOT NULL, 
   personalityId TEXT NOT NULL, 
   FOREIGN KEY (personalityId) REFERENCES personality(personalityId)
);

INSERT INTO chat(chatid, topic, personalityId) VALUES
   ("b4f01552-0c09-401c-8fde-fda753fb0261", "Nuernberg", "8f73b580-927e-41c2-98ac-e5df070e7288"),
   ("ee3e80f9-c8f7-48c2-9f15-449ba9bbe4ab", "Home-Office", "8b310f95-92cd-4512-b42a-d3fe29c4bb8a");

create table IF NOT EXISTS chatMessage (
   id INTEGER primary key AUTOINCREMENT NOT NULL, 
   messageId TEXT NOT NULL, 
   timestamp TEXT NOT NULL DEFAULT (DATETIME('now')),
   isUser INTEGER NOT NULL, 
   content TEXT NOT NULL,
   chatId TEXT NOT NULL,
   FOREIGN KEY (chatId) REFERENCES chat(chatId)
);

INSERT INTO chatMessage("messageId", "isUser", "content", "chatId") VALUES
   ("539ed3e6-9e3d-11ee-8c90-0242ac120002", TRUE, "hello pib!", "b4f01552-0c09-401c-8fde-fda753fb0261"),
   ("0a080706-9e3e-11ee-8c90-0242ac120002", FALSE, "hello user!", "b4f01552-0c09-401c-8fde-fda753fb0261");