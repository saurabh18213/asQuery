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