import pandas as pd
import requests
import io

url = "https://data.cms.gov/sites/default/files/2023-04/67157de9-d962-4af0-bf0e-3578b3afec58/inpatient.csv"

# Download the CSV file
response = requests.get(url)
response.raise_for_status()

# Load into pandas DataFrame
df = pd.read_csv(io.BytesIO(response.content))

# Preview the data
print("--- DataFrame ---")
print(df.head())

# Save locally
df.to_csv("D:\python_Scripts\customer_1_inpatient.csv", index=False)
print("Saved: customer_1_inpatient.csv")