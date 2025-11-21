/*
 * Copyright © 2025 Devin B. Royal.
 * All Rights Reserved.
 */
package com.devinroyal.synergy;

import javax.jms.*;
import java.util.Properties;

public class JMSTransformer {
    public static void main(String[] args) throws Exception {
        Properties p = new Properties();
        p.setProperty("java.naming.factory.initial", "com.ibm.mq.jms.MQConnectionFactory");
        p.setProperty("javax.net.ssl.trustStore", "trust.jks");
        p.setProperty("javax.net.ssl.keyStore", "client.jks");
        Connection c = new com.ibm.mq.jms.MQConnectionFactory().createConnection();
        c.start();
        Session s = c.createSession(false, Session.AUTO_ACKNOWLEDGE);
        Queue q = s.createQueue("GDPR.IN");
        MessageConsumer consumer = s.createConsumer(q);
        consumer.setMessageListener(m -> {
            if (m instanceof TextMessage) {
                System.out.println("Transformed: " + ((TextMessage)m).getText());
            }
        });
        Thread.sleep(5000);
        c.close();
    }
}
