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
create procedure QuestionVote (IN uid INT, IN qid INT, IN type INT)
    BEGIN 
    IF EXISTS(select * from Question_votes Q where Q.userid=uid and Q.question_id=qid)
    THEN delete from Question_votes Q where Q.userid=uid and Q.question_id=qid;
    ELSE insert into Question_votes values (qid, uid, type); 
    END IF;
    END$$
DELIMITER ;

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

create procedure AnswerVote (IN uid INT, IN qid INT, IN aid INT, IN type INT)
    BEGIN 
    IF EXISTS(select * from Answer_votes A where A.userid=uid and A.question_id=qid and A.answer_id=aid)
    THEN delete from Answer_votes A where A.userid=uid and A.question_id=qid and A.answer_id=aid;
    ELSE insert into Answer_votes values (qid, aid, uid, type); 
    END IF; 
    END?

Delimiter $$
CREATE TRIGGER insertAvote
    before insert on Answer_votes
    FOR EACH ROW 
BEGIN
    IF (NEW.type = 0) THEN
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
        Update Answer set Answer.upvotes = Answer.upvotes + 1 where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id;
    ELSE
        Update User set User.reputation = User.reputation - 1 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
        Update Answer set Answer.downvotes = Answer.downvotes + 1 where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id;
    END IF;    
END$$
DELIMITER ;

Delimiter $$
CREATE TRIGGER deleteAvote
    before delete on Answer_votes
    FOR EACH ROW 
BEGIN
    IF (OLD.type = 0) THEN
        Update User set User.reputation = User.reputation - 2 where User.userid=(select userid from Answer where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id); 
        Update Answer set Answer.upvotes = Answer.upvotes - 1 where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id;
    ELSE
        Update User set User.reputation = User.reputation + 1 where User.userid=(select userid from Answer where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id); 
        Update Answer set Answer.downvotes = Answer.downvotes - 1 where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id;
    END IF;
END$$

Delimiter $$
CREATE TRIGGER Userdelete
    before delete on User
    FOR EACH ROW 
BEGIN
        Delete from Question_votes where Question_votes.userid = OLD.userid;
        Delete from Answer_votes where Answer_votes.userid = OLD.userid;    
END$$
DELIMITER ;