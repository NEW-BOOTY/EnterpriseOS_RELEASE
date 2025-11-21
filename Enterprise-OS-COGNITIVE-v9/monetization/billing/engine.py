class CognitiveBilling:
    def __init__(self):
        self.rate_per_token = 0.00012  # USD

    def charge_tenant(self, tenant_id: str, tokens_used: int):
        cost = tokens_used * self.rate_per_token
        print(f"[BILLING] Tenant {tenant_id}: ${cost:,.8f} for {tokens_used:,} cognitive tokens")
        return {"charged_usd": cost, "status": "SETTLED"}
