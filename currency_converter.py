import requests

# 1. Take the base currency from the user (e.g., "USD", "EUR", "INR")
base_currency = input().lower().strip()

# 2. Fetch the entire JSON payload for the base currency to populate the initial cache
url = f"http://floatrates.com/daily/{base_currency}.json"
response = requests.get(url).json()

# 3. Initialize the cache. Pre-cache USD and EUR relative to your base currency
cache = {}

# If the base currency itself is USD or EUR, set it to 1.0; otherwise fetch from JSON
if base_currency == "usd":
    cache["usd"] = 1.0
elif "usd" in response:
    cache["usd"] = response["usd"]["rate"]

if base_currency == "eur":
    cache["eur"] = 1.0
elif "eur" in response:
    cache["eur"] = response["eur"]["rate"]

# 4. Process user queries indefinitely until an empty line is hit
while True:
    target_currency = input().lower().strip()
    if not target_currency:
        break  # Exit loop if input is empty

    amount = float(input())

    print("Checking the cache...")

    # Check cache status and handle accordingly
    if target_currency in cache:
        print("Oh! It is in the cache!")
    else:
        print("Sorry, but it is not in the cache!")
        # Fetch the missing currency rate from our pre-loaded API response and add it to cache
        cache[target_currency] = response[target_currency]["rate"]

    # Calculate converted value
    # Since Floatrates rates are all base_currency -> target_currency,
    # the target rate is simply cache[target_currency]
    converted_amount = round(amount * float(cache[target_currency]), 2)

    print(f"You received {converted_amount} {target_currency.upper()}.")
