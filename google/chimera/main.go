/*
 * Copyright © 2025 Devin B. Royal.
 * All Rights Reserved.
 */
package main

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"cloud.google.com/go/pubsub"
	"github.com/golang-jwt/jwt/v5"
	"gopkg.in/yaml.v3"
)

type Config struct {
	ProjectID string `yaml:"project_id"`
	TopicID   string `yaml:"topic_id"`
	TenantID  string `yaml:"tenant_id"`
	Secret    string `yaml:"secret"`
}

type Event struct {
	Timestamp int64                  `json:"timestamp"`
	TenantID  string                 `json:"tenant_id"`
	Payload   map[string]interface{} `json:"payload"`
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: chimera <config.yaml>")
		os.Exit(1)
	}

	cfg := loadConfig(os.Args[1])
	client := createPubSubClient(cfg.ProjectID)
	topic := client.Topic(cfg.TopicID)
	defer topic.Stop()

	event := Event{
		Timestamp: time.Now().Unix(),
		TenantID:  cfg.TenantID,
		Payload:   map[string]interface{}{"action": "deploy", "version": "1.0.0"},
	}

	jwtToken := generateJWT(event, cfg.Secret)
	eventData, _ := json.Marshal(event)
	msg := &pubsub.Message{
		Data: eventData,
		Attributes: map[string]string{
			"jwt": jwtToken,
		},
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result := topic.Publish(ctx, msg)
	id, err := result.Get(ctx)
	if err != nil {
		fmt.Printf("Failed to publish: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("Published message ID: %s\n", id)
}

func loadConfig(path string) Config {
	data, err := os.ReadFile(path)
	if err != nil {
		fmt.Printf("Config error: %v\n", err)
		os.Exit(1)
	}
	var cfg Config
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		fmt.Printf("YAML error: %v\n", err)
		os.Exit(1)
	}
	return cfg
}

func createPubSubClient(projectID string) *pubsub.Client {
	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		fmt.Printf("Pub/Sub client error: %v\n", err)
		os.Exit(1)
	}
	return client
}

func generateJWT(event Event, secretB64 string) string {
	secret, _ := base64.StdEncoding.DecodeString(secretB64)
	claims := jwt.MapClaims{
		"iss": "chimera",
		"sub": event.TenantID,
		"iat": time.Now().Unix(),
		"exp": time.Now().Add(1 * time.Hour).Unix(),
		"event": event,
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := token.SignedString(secret)
	if err != nil {
		fmt.Printf("JWT error: %v\n", err)
		os.Exit(1)
	}
	return signed
}
