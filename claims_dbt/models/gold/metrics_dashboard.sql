SELECT 
  -- Underutilization %
  (SELECT ROUND(100.0 * COUNT(*) / NULLIF(total.total_beneficiaries, 0), 2)
   FROM fact_underutilized_care) AS percent_underutilized,

  -- Duplicate claim rate
  (SELECT ROUND(100.0 * SUM(duplicate_count - 1) / NULLIF(total_claims, 0), 2)
   FROM fact_duplicate_claims) AS duplicate_claim_rate,

  -- High-cost provider info (example top 1)
  (SELECT provider_number FROM fact_procedure_cost 
   ORDER BY avg_claim_amount DESC LIMIT 1) AS top_provider_by_cost,

  (SELECT ROUND(MAX(avg_claim_amount), 2) FROM fact_procedure_cost) AS max_avg_claim_cost

FROM 
  (SELECT COUNT(DISTINCT beneficiary_id) AS total_beneficiaries FROM silver_claims) total,
  (SELECT COUNT(*) AS total_claims FROM silver_claims) claims