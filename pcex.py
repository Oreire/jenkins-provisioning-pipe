def calculate_compound_interest(initial_capital, daily_rate, months):
    days = months * 30  # Approximate number of days in the given months
    cumulative_capital = initial_capital

    for day in range(days):
        cumulative_capital += cumulative_capital * (daily_rate / 100)

    return cumulative_capital

if __name__ == "__main__":
    initial_capital = float(input("Enter the initial capital: "))

    daily_rate = 2.2  # Daily increment rate in percentage
    days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]  # Days in each month of the year
    print("Month\tTotal Amount")
    for month in range(1, 13):
        final_amount = calculate_compound_interest(initial_capital, daily_rate, month)
        print(f"{month}\t{final_amount:.2f}")
    months = int(input("Enter the number of months: "))

    final_amount = calculate_compound_interest(initial_capital, daily_rate, months)
    print(f"The final amount after {months} months is: {final_amount:.2f}")