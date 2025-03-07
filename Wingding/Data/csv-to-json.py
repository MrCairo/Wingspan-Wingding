import csv
import json


def csv_to_json(csvFilePath, jsonFilePath, printRow: bool = False):
    jsonArray = []

    with open(csvFilePath, encoding='cp1252') as csvf:
        csvReader = csv.DictReader(csvf)

        for row in csvReader:
            if printRow:
                jsonStr = json.dumps(row, indent=2)
                print(f"{jsonStr}\n")
            jsonArray.append(row)

    with open(jsonFilePath, 'w', encoding='utf-8') as jsonf:
        jsonString = json.dumps(jsonArray, indent=4)
        jsonf.write(jsonString)


def convert_birds():
    "Convert Birds CSV."
    csv_file_path = r'wingspan-20221201-Birds.csv'
    json_file_path = r'wingspan-birds-data.json'
    csv_to_json(csv_file_path, json_file_path, True)


def convert_bonus():
    "Convert Bonus CSV."
    csv_file_path = r'wingspan-20221201-Bonus.csv'
    json_file_path = r'wingspan-bonus-data.json'
    csv_to_json(csv_file_path, json_file_path, True)


def convert_goals():
    "Convert Goals CSV."
    csv_file_path = r'wingspan-20221201-Goals.csv'
    json_file_path = r'wingspan-goals-data.json'
    csv_to_json(csv_file_path, json_file_path, True)


if __name__ == "__main__":
    convert_birds()
    convert_bonus()
    convert_goals()
