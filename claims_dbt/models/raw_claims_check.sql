-- models/raw_claims_check.sql
SELECT *
FROM CLAIMS_DATABASE.PUBLIC.raw_claims
WHERE claim_id IS NULL
