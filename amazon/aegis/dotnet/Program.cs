using Azure.Identity; using Azure.Security.KeyVault.Secrets;
var client = new SecretClient(new Uri("https://vault.vault.azure.net"), new DefaultAzureCredential());
var secret = await client.GetSecretAsync("my-secret");
Console.WriteLine("Rotated: " + secret.Value.Value);
