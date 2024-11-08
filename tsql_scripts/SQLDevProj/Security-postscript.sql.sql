-- Create roles
CREATE ROLE db_qa;
CREATE ROLE db_developer;
CREATE ROLE db_admin;

-- Grant permissions to roles
GRANT SELECT ON Customer TO db_qa;
GRANT SELECT ON Orders TO db_qa;
GRANT SELECT ON Invoice TO db_qa;
GRANT SELECT ON Invoice_Detail TO db_qa;
GRANT SELECT ON Product TO db_qa;

GRANT SELECT, INSERT, UPDATE ON Customer TO db_developer;
GRANT SELECT, INSERT, UPDATE ON Orders TO db_developer;
GRANT SELECT, INSERT, UPDATE ON Invoice TO db_developer;
GRANT SELECT, INSERT, UPDATE ON Invoice_Detail TO db_developer;
GRANT SELECT, INSERT, UPDATE ON Product TO db_developer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Customer TO db_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO db_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Invoice TO db_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Invoice_Detail TO db_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Product TO db_admin;

-- Create users and assign roles
CREATE USER qa_user WITH PASSWORD = 'qa_password';
CREATE USER developer_user WITH PASSWORD = 'developer_password';
CREATE USER admin_user WITH PASSWORD = 'admin_password';

ALTER ROLE db_qa ADD MEMBER qa_user;
ALTER ROLE db_developer ADD MEMBER developer_user;
ALTER ROLE db_admin ADD MEMBER admin_user;-- Write your own SQL object definition here, and it'll be included in your package.
