/*
 * Copyright © 2025 Devin B. Royal.
 * All Rights Reserved.
 */
package com.devinroyal.veritas;

import java.sql.*;

public class VeritasAudit {
    public static void main(String[] args) throws Exception {
        String url = System.getenv("ORACLE_URL") != null ? System.getenv("ORACLE_URL") : "jdbc:oracle:thin:@localhost:1521:XE";
        Connection c = DriverManager.getConnection(url, "audit_user", "securepass");
        c.setReadOnly(true);
        PreparedStatement ps = c.prepareStatement("SELECT license_count FROM v_license_usage WHERE metric = ?");
        ps.setString(1, "named_user");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) System.out.println("Oracle license: " + rs.getInt(1) + " users");
        c.close();
    }
}
