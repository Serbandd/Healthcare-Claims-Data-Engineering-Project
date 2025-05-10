/*
This will:

Remove NULL claim_id

Keep only columns necessary for analytics

Remove duplicates based on claim_id
*/


-- silver/silver_claims.sql
WITH cleaned AS (
    SELECT
        claim_id,
        beneficiary_id,
        provider_number,
        claim_start_date,
        claim_end_date,
        claim_payment_amount,
        claim_type_code,
        source_file_name,
        loaded_timestamp
    FROM {{ source('claims_database', 'raw_claims') }}
    WHERE claim_id IS NOT NULL
)

SELECT *
FROM cleaned
QUALIFY ROW_NUMBER() OVER (PARTITION BY claim_id ORDER BY loaded_timestamp DESC) = 1
