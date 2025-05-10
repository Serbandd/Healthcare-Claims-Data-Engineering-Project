-- gold/fact_procedure_cost.sql
--  This is procedure cost benchmarking
SELECT
    provider_number,
    claim_type_code,
    AVG(claim_payment_amount) AS avg_claim_amount
FROM {{ ref('silver_claims') }}
GROUP BY provider_number, claim_type_code
