import subprocess
import time
import os

def monitor_and_heal():
    while True:
        proc = subprocess.run(["pgrep", "-f", "cognitive_engine"], capture_output=True)
        if not proc.stdout:
            print("[SELF-HEAL] Cognitive engine down → restarting...")
            os.system("nohup python3 core/agents/cognitive_engine.py &")
        time.sleep(3)
