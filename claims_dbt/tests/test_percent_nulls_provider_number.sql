SELECT
  COUNT(*) AS null_count
FROM {{ source('claims_database', 'raw_claims') }}
WHERE provider_number IS NULL
HAVING COUNT(*) > (
    SELECT COUNT(*) * 0.1
    FROM {{ source('claims_database', 'raw_claims') }}
)
