import Foundation
struct Push: Codable { let aps: APS }
struct APS: Codable { let alert: String }
let payload = Push(aps: APS(alert: "Secure push"))
let data = try! JSONEncoder().encode(payload)
print("APNs payload ready (PKCS#12 required)")
