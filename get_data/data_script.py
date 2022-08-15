import requests
from io import StringIO
import pandas as pd
import csv


def main():
    get_evm_data("etherscan.io", "ethereum")
    get_evm_data("polygonscan.com", "polygon")
    get_evm_data("ftmscan.com", "ftm")
    get_evm_data("bscscan.com", "bsc")
    get_evm_data("snowtrace.io", "avax")
    get_sol_data()
    
# No need to handle the case where there are no tx on 01/01/2021 since all chains were active since then
def get_evm_data(link, name):
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"}
    r = requests.get(f"https://{link}/chart/tx?output=csv", headers=headers)
    # print(r.content)
    s = str(r.content, 'utf-8')
    s = StringIO(s)
    df = pd.read_csv(s)
    # Find index of the row containing the start date
    index = df.loc[df['Date(UTC)'] == "1/1/2021"].index[0]
    new = df[index:]
    new.to_csv(f"{name}_data.csv")

def get_sol_data():
    r = requests.get("https://dashboard.chaincrunch.cc/api/public/dashboard/cc7a0d94-7f70-46f4-aae4-2f8810430931/card/45?parameters=%5B%7B%22type%22%3A%22date%2Fall-options%22%2C%22value%22%3A%22past589days%22%2C%22target%22%3A%5B%22dimension%22%2C%5B%22field%22%2C144%2Cnull%5D%5D%7D%5D")
    p = r.json()
    s = p['data']['rows']
    new_list = []
    for sub in s:
        # CLEAN DATE UP AND USE ONLY NONE-VOTE TXS
        l = [sub[1][:10], sub[3]]
        new_list.append(l)
        
    headerlist = ["Date", "Value"]
    with open("sol_data.csv", 'w') as file:
        dw = csv.DictWriter(file, delimiter=',', 
                            fieldnames=headerlist)
        writer = csv.writer(file, delimiter=',')
        dw.writeheader()
        writer.writerows(new_list)

    # ORDER BY DATE
    df = pd.read_csv('./sol_data.csv')
    df["Date"] = df["Date"].astype('datetime64[ns]')
    new = df.sort_values(by='Date')
    new.to_csv("ordered_solana.csv")
    
if __name__ == "__main__":
    main()
