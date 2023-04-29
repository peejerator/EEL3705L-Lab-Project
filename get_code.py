code_dict = {
    "0": "1000000",
    "1": "1111001",
    "2": "0100100",
    "3": "0110000",
    "4": "0011001",
    "5": "0010010",
    "6": "0000010",
    "7": "1111000",
    "8": "0000000",
    "9": "0011000",
    "A": "0001000",
    "B": "0000011",
    "C": "1000110",
    "D": "0100001",
    "E": "0000110",
    "F": "0001110",
}

def get_code(code: str) -> str:
    full_code = ""
    for i in code:
        if i not in code_dict:
            raise ValueError("Invalid code")

        full_code += code_dict[i]

    return full_code


if __name__ == "__main__":
    code = ""
    while True:
        code = str(input("Code: "))
        if code == "exit":
            break
        
        print(get_code(code))