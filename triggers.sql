Delimiter $$
CREATE TRIGGER before_tagged_insert
    before insert on Tagged
    FOR EACH ROW 
BEGIN
    IF EXISTS(select tagname from Tag where tagname = NEW.tagname) THEN
        Update Tag set question_count = question_count + 1 where tagname = NEW.tagname; 
    ELSE
        insert into Tag(tagname, question_count, description) values (NEW.tagname, 1, "");
    END IF;    
END$$
DELIMITER ;

Delimiter $$
CREATE TRIGGER before_upvote
    before insert on Question_votes
    FOR EACH ROW 
BEGIN
    IF (NEW.type == 0) THEN
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Question where Question.question_id = NEW.question_id); 
    ELSE
        Update User set User.reputation = User.reputation - 1 where User.userid=(select userid from Question where Question.question_id = NEW.question_id);
    END IF;    
END$$
DELIMITER ;

Delimiter $$
CREATE TRIGGER before_answer_vote
    before insert on Answer_votes
    FOR EACH ROW 
BEGIN
    IF (NEW.type == 0) THEN
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
    ELSE
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
    END IF;    
END$$
DELIMITER ;