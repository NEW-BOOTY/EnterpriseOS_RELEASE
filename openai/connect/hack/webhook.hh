<?hh
function verify_proof(string $proof, string $secret): bool {
    return hash_hmac('sha256', $proof, $secret) === $proof;
}
echo verify_proof("mock", "appsecret") ? "Webhook valid\n" : "Invalid\n";
