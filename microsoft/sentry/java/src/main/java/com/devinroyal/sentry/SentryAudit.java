/*
 * Copyright © 2025 Devin B. Royal.
 * All Rights Reserved.
 */
package com.devinroyal.sentry;

import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import java.nio.file.Paths;
import java.time.Instant;

public class SentryAudit {
    public static void main(String[] args) throws Exception {
        String bucket = System.getenv("SENTRY_BUCKET");
        if (bucket == null) throw new IllegalStateException("SENTRY_BUCKET required");
        S3Client s3 = S3Client.builder().credentialsProvider(DefaultCredentialsProvider.create()).build();
        String key = "audit/" + Instant.now().toString().replace(":", "-") + ".json";
        s3.putObject(PutObjectRequest.builder().bucket(bucket).key(key).serverSideEncryption("aws:kms").build(), Paths.get("audit.json"));
        System.out.println("Audit logged: s3://" + bucket + "/" + key);
    }
}
