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

create procedure QuestionVote (IN userid INT, IN question_id INT, IN type INT)
    BEGIN 
    IF EXISTS(select * from Question_votes Q where Q.userid=uid and Q.question_id=qid)
    THEN delete from Question_votes Q where Q.userid=uid and Q.question_id=qid;
    ELSE insert into Question_votes values (qid, uid, type); 
    END IF;
    END?

Delimiter $$
CREATE TRIGGER insertQvote
    before insert on Question_votes
    FOR EACH ROW 
BEGIN
    IF (NEW.type = 0) THEN
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Question where Question.question_id = NEW.question_id); 
        Update Question set Question.upvotes = Question.upvotes + 1 where Question.question_id = NEW.question_id;
    ELSE
        Update User set User.reputation = User.reputation - 1 where User.userid=(select userid from Question where Question.question_id = NEW.question_id);
        Update Question set Question.downvotes = Question.downvotes + 1 where Question.question_id = NEW.question_id;
    END IF;    
END$$
DELIMITER ;

Delimiter $$
CREATE TRIGGER deleteQvote
    before delete on Question_votes
    FOR EACH ROW 
BEGIN
    IF (OLD.type = 0) THEN
        Update User set User.reputation = User.reputation - 2 where User.userid=(select userid from Question where Question.question_id = OLD.question_id); 
        Update Question set Question.upvotes = Question.upvotes - 1 where Question.question_id = OLD.question_id;
    ELSE
        Update User set User.reputation = User.reputation + 1 where User.userid=(select userid from Question where Question.question_id = OLD.question_id);
        Update Question set Question.downvotes = Question.downvotes - 1 where Question.question_id = OLD.question_id;
    END IF;    
END$$
DELIMITER ;