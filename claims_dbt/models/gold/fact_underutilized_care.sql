-- gold/fact_underutilized_care.sql
-- Preventive care → No claims detected for preventive code → Under-utilization.
-- Identify beneficiaries who might be missing preventive services (e.g., diabetes checkups, vaccines, screenings) based on their claim history.
SELECT
    beneficiary_id,
    COUNT(*) AS claims_count
FROM {{ ref('silver_claims') }}
WHERE claim_payment_amount < 100
GROUP BY beneficiary_id
--HAVING COUNT(*) = 0
