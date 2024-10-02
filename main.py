import json
from handler import hello
if __name__ == "__main__":
    event = {
        "key":"value"
    }

    result = hello(event,None)
    print(json.dumps(result,indent=2))