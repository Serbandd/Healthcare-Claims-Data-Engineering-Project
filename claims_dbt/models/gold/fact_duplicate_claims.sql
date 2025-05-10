-- gold/fact_duplicate_claims.sql
-- This is a fact → find duplicate claims submitted by provider + patient + same day.
SELECT
    beneficiary_id,
    provider_number,
    claim_start_date,
    COUNT(*) AS duplicate_count
FROM {{ ref('silver_claims') }}
GROUP BY beneficiary_id, provider_number, claim_start_date
HAVING COUNT(*) > 1
