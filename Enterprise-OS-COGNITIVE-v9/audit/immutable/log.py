import hashlib
import json
import time

class ImmutableAuditLog:
    def __init__(self):
        self.chain = []
        self.prev_hash = "0" * 64

    def log(self, event: dict):
        block = {
            "timestamp": time.time(),
            "event": event,
            "prev_hash": self.prev_hash,
            "hash": hashlib.sha3_512(json.dumps(event, sort_keys=True).encode()).hexdigest()
        }
        self.chain.append(block)
        self.prev_hash = block["hash"]
        print(f"[IMMUTABLE AUDIT] {block['hash'][:16]}... {event.get('action','event')}")
