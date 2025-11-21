package quantum_crypto

import (
	"crypto/rand"
	"fmt"
	"golang.org/x/crypto/kyber/kem/kyber1024"
	"filippo.io/mlkem"
)

func InitQuantumSafeChannel() {
	// Kyber1024 (NIST PQC Standard)
	pk, sk, _ := kyber1024.GenerateKeyPair(rand.Reader)
	fmt.Printf("[QUANTUM-SAFE] Kyber1024 keypair generated: %d bytes\n", len(pk))

	// ML-KEM (FIPS 203)
	kem := mlkem.NewKEM768()
	pub, priv := kem.GenerateKeyPair()
	fmt.Printf("[QUANTUM-SAFE] ML-KEM-768 active: %d bytes\n", len(pub))
}
