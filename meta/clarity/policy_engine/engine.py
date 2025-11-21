import yaml, time, re
rules = yaml.safe_load(open("rules.yaml"))
last_call = 0
def check(prompt):
    global last_call
    if time.time() - last_call < 6: return False, "Rate limit"
    last_call = time.time()
    for r in rules:
        if 'pattern' in r and re.search(r['pattern'], prompt): return False, r['reason']
    return True, "OK"
print(check("my ssn is 123-45-6789"))
