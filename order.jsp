<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>Order Confirmation – The Golden Oven</title>
<!-- Fonts & Icons -->
<link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
  /* ----- RESET & BASE (light & airy, reference image style) ----- */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    background: #fef7e8;   /* soft warm cream like bakery paper */
    font-family: 'Inter', sans-serif;
    padding: 2rem 1rem;
    min-height: 100vh;
    color: #2c1a0c;
  }

  /* main card container - similar to the reference minimal but elevated */
  .confirmation-wrapper {
    max-width: 720px;
    margin: 0 auto;
  }

  /* clean white card, soft shadows, no heavy gradients — matches reference simplicity */
  .order-card {
    background: #ffffff;
    border-radius: 32px;
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.05), 0 0 0 1px rgba(224, 192, 148, 0.2);
    overflow: hidden;
    transition: all 0.2s ease;
  }

  /* header — minimal gold/brown line, light & elegant */
  .order-header {
    padding: 2rem 2rem 1.5rem;
    text-align: center;
    border-bottom: 2px solid #f3e1c0;
    background: #ffffff;
  }

  .success-icon {
    font-size: 3.2rem;
    color: #2b7a3e;
    background: #e8f3e6;
    width: 72px;
    height: 72px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 60px;
    margin: 0 auto 1rem;
    box-shadow: 0 4px 8px rgba(0,0,0,0.02);
  }

  .order-header h1 {
    font-family: 'Playfair Display', serif;
    font-size: 1.8rem;
    font-weight: 600;
    color: #3a2416;
    letter-spacing: -0.2px;
    margin-bottom: 0.3rem;
  }

  .thank-text {
    font-size: 0.9rem;
    color: #9b7b5c;
    margin-bottom: 1rem;
  }

  .order-id-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: #fcf6ed;
    padding: 0.5rem 1.2rem;
    border-radius: 60px;
    font-size: 0.85rem;
    font-weight: 500;
    color: #b45f2b;
    border: 1px solid #f0dfc6;
    font-family: monospace;
    letter-spacing: 0.3px;
  }

  .order-id-badge i {
    font-size: 0.9rem;
    color: #d9892b;
  }

  /* content area - clean spacing */
  .order-content {
    padding: 1.8rem 2rem 1.2rem;
  }

  /* customer info panel — like reference card style */
  .info-panel {
    background: #fefaf4;
    border-radius: 24px;
    padding: 1.2rem;
    margin-bottom: 1.5rem;
    border: 1px solid #f1e2cf;
  }

  .info-row {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: baseline;
    padding: 0.6rem 0;
    border-bottom: 1px dashed #f0e0cb;
  }

  .info-row:last-child {
    border-bottom: none;
  }

  .info-label {
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #b87a48;
    display: flex;
    align-items: center;
    gap: 0.4rem;
    min-width: 110px;
  }

  .info-value {
    font-weight: 500;
    color: #2e241d;
    text-align: right;
    word-break: break-word;
    max-width: 65%;
    font-size: 0.9rem;
  }

  /* divider line */
  .soft-divider {
    height: 2px;
    background: linear-gradient(90deg, #f3e1c0, #e9cfaa, #f3e1c0);
    margin: 1.2rem 0 1.2rem;
  }

  /* order summary minimalist */
  .summary-title {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-weight: 600;
    font-size: 1rem;
    color: #5c3c22;
    margin-bottom: 0.8rem;
    letter-spacing: -0.2px;
  }
  .summary-title i {
    color: #cb8b42;
    font-size: 1.1rem;
  }

  .items-preview {
    background: #ffffff;
    border: 1px solid #efe0ce;
    border-radius: 20px;
    padding: 1rem 1.2rem;
    margin-bottom: 1.2rem;
  }

  .items-text {
    font-size: 0.9rem;
    line-height: 1.45;
    color: #3f2c1c;
    font-weight: 500;
  }

  .qty-text {
    font-size: 0.8rem;
    color: #b27642;
    margin-top: 6px;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  /* price table clean */
  .price-list {
    background: #fefaf4;
    border-radius: 20px;
    padding: 0.2rem 0;
    margin: 1rem 0;
  }

  .price-item {
    display: flex;
    justify-content: space-between;
    padding: 0.7rem 1rem;
    font-size: 0.9rem;
    color: #4c351f;
  }

  .price-item.total-row {
    border-top: 2px solid #eedbbc;
    margin-top: 0.2rem;
    font-weight: 700;
    font-size: 1rem;
    color: #3a2416;
  }

  .total-amount {
    font-weight: 800;
    color: #ce7e2e;
    font-size: 1.2rem;
  }

  .payment-method-chip {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: #eef4ea;
    padding: 0.4rem 1rem;
    border-radius: 60px;
    font-size: 0.75rem;
    font-weight: 500;
    color: #2f6b3c;
  }

  .delivery-estimate {
    font-size: 0.7rem;
    color: #b98f63;
    display: flex;
    align-items: center;
    gap: 5px;
  }

  .footer-actions {
    background: #ffffff;
    border-top: 1px solid #f0e2d2;
    padding: 1.4rem 2rem 2rem;
    text-align: center;
  }

  .btn-group {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    gap: 0.6rem;
    padding: 0.7rem 1.6rem;
    border-radius: 40px;
    font-weight: 500;
    font-size: 0.85rem;
    text-decoration: none;
    transition: 0.2s;
    cursor: pointer;
    border: none;
    background: transparent;
  }

  .btn-primary {
    background: #3a2416;
    color: white;
    box-shadow: 0 2px 6px rgba(58,36,22,0.1);
  }
  .btn-primary:hover {
    background: #5c3c22;
    transform: translateY(-1px);
  }

  .btn-outline {
    border: 1.5px solid #dbbc97;
    color: #5c3c22;
    background: white;
  }
  .btn-outline:hover {
    background: #fdf3e6;
    border-color: #b87a48;
  }

  /* error state with same clean aesthetic */
  .error-card {
    background: white;
    border-radius: 32px;
    padding: 2.5rem 2rem;
    text-align: center;
    box-shadow: 0 8px 20px rgba(0,0,0,0.05);
    border: 1px solid #f2dfcb;
  }
  .error-icon {
    font-size: 3rem;
    color: #c45a3b;
    background: #fdf0e8;
    width: 70px;
    height: 70px;
    border-radius: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 1rem;
  }
  .error-card h2 {
    font-family: 'Playfair Display', serif;
    color: #bc6f3c;
    margin-bottom: 0.5rem;
  }
  .error-detail {
    background: #fff7f0;
    border-radius: 20px;
    padding: 0.8rem;
    font-size: 0.75rem;
    font-family: monospace;
    word-break: break-all;
    margin: 1.2rem 0;
  }

  @media (max-width: 550px) {
    .order-content {
      padding: 1.2rem;
    }
    .info-row {
      flex-direction: column;
      align-items: flex-start;
      gap: 0.2rem;
    }
    .info-value {
      text-align: left;
      max-width: 100%;
    }
    .btn-group {
      flex-direction: column;
    }
    .btn {
      justify-content: center;
    }
    .order-header h1 {
      font-size: 1.5rem;
    }
  }

  @media print {
    body {
      background: white;
      padding: 0.5rem;
    }
    .btn-group, .footer-actions .btn-group {
      display: none;
    }
    .order-card {
      box-shadow: none;
      border: 1px solid #ddd;
    }
    .info-panel {
      background: #fafaf5;
    }
  }
</style>
</head>
<body>

<div class="confirmation-wrapper">
<%-- ====================== BACKEND (JSP) LOGIC ====================== --%>
<%
// 1. Receive all form parameters (from checkout/cart)
String firstName = request.getParameter("firstName");
String lastName  = request.getParameter("lastName");
String email     = request.getParameter("email");
String phone     = request.getParameter("phone");
String address   = request.getParameter("address");
String city      = request.getParameter("city");
String pincode   = request.getParameter("pincode");
String paymentMethod = request.getParameter("paymentMethod");

String productNames = request.getParameter("productNames");
String productQtys  = request.getParameter("productQtys");
String subtotalStr  = request.getParameter("subtotal");
String deliveryStr  = request.getParameter("deliveryCharge");
String totalStr     = request.getParameter("totalAmount");

// default fallback
if(firstName == null || firstName.trim().isEmpty()) firstName = "";
if(lastName == null) lastName = "";
if(email == null) email = "";
if(phone == null) phone = "";
if(address == null) address = "";
if(city == null) city = "";
if(pincode == null) pincode = "";
if(paymentMethod == null) paymentMethod = "COD";

if(productNames == null) productNames = "Fresh Baked Goods";
if(productQtys == null) productQtys = "1";
if(subtotalStr == null) subtotalStr = "0";
if(deliveryStr == null) deliveryStr = "0";
if(totalStr == null) totalStr = "0";

// sanitize numbers (remove non-digits)
int subtotal = 0, delivery = 0, total = 0;
try {
    subtotal = Integer.parseInt(subtotalStr.replaceAll("[^0-9]", ""));
    delivery = Integer.parseInt(deliveryStr.replaceAll("[^0-9]", ""));
    total    = Integer.parseInt(totalStr.replaceAll("[^0-9]", ""));
} catch(Exception e) { /* keep 0 */ }

// generate order ID (GO-XXXXXX)
String orderId = "GO-" + (int)(Math.random() * 900000 + 100000);
java.time.LocalDateTime now = java.time.LocalDateTime.now();
java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String orderTime = now.format(dtf);

// summary for logs / DB
String orderSummary = productNames + " (Qty: " + productQtys + ")";

// ========== DATABASE INSERT (MySQL) ==========
boolean dbSuccess = false;
String dbErrorMsg = "";

String DB_URL  = "jdbc:mysql://localhost:3306/golden_oven_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
String DB_USER = "root";
String DB_PASS = "root123";

String insertSQL = "INSERT INTO orders (" +
    "order_id, first_name, last_name, email, phone, address, city, pincode, notes, " +
    "payment_method, order_summary, product_names, product_quantities, subtotal, delivery_charge, " +
    "total_amount, order_time) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    ps = conn.prepareStatement(insertSQL);
    
    ps.setString(1, orderId);
    ps.setString(2, firstName);
    ps.setString(3, lastName);
    ps.setString(4, email);
    ps.setString(5, phone);
    ps.setString(6, address);
    ps.setString(7, city);
    ps.setString(8, pincode);
    ps.setString(9, "");   // notes empty
    ps.setString(10, paymentMethod);
    ps.setString(11, orderSummary);
    ps.setString(12, productNames);
    ps.setString(13, productQtys);
    ps.setInt(14, subtotal);
    ps.setInt(15, delivery);
    ps.setInt(16, total);
    ps.setString(17, orderTime);
    
    int rows = ps.executeUpdate();
    if(rows > 0) dbSuccess = true;
    
} catch(Exception e) {
    dbSuccess = false;
    dbErrorMsg = e.getMessage();
    if(dbErrorMsg == null) dbErrorMsg = "Database connection error";
} finally {
    // Clean up resources
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(conn != null) conn.close(); } catch(Exception e) {}
}
%>

<%-- ========== DISPLAY BASED ON SUCCESS ========== --%>
<% if(!dbSuccess) { %>
    <!-- ERROR DISPLAY (clean & friendly) -->
    <div class="error-card">
        <div class="error-icon">
            <i class="fa-regular fa-circle-xmark"></i>
        </div>
        <h2>Order could not be placed</h2>
        <p style="color:#aa6f46; margin-bottom:0.8rem;">We're sorry, something went wrong on our side.</p>
        <div class="error-detail">
            <i class="fa-regular fa-database"></i> <strong>System note:</strong> <%= dbErrorMsg.length() > 100 ? dbErrorMsg.substring(0,100)+"..." : dbErrorMsg %>
        </div>
        <div class="btn-group" style="margin-top: 1.2rem;">
            <a href="javascript:history.back()" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Back to Cart</a>
            <a href="index.html" class="btn btn-outline"><i class="fa-regular fa-house"></i> Homepage</a>
        </div>
    </div>
<% } else { %>
    <!-- ========== SUCCESS CONFIRMATION CARD - REFERENCE STYLE (simple, airy, bakery vibe) ========== -->
    <div class="order-card">
        <div class="order-header">
            <div class="success-icon">
                <i class="fa-regular fa-circle-check fa-2x"></i>
            </div>
            <h1>Order Placed! 🍞</h1>
            <div class="thank-text">Thank you! We'll start baking right away and deliver to you soon.</div>
            <div class="order-id-badge">
                <i class="fa-regular fa-receipt"></i> Order ID: <%= orderId %>
            </div>
        </div>
        
        <div class="order-content">
            <!-- customer info panel -->
            <div class="info-panel">
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-user"></i> Full name</span>
                    <span class="info-value"><%= firstName %> <%= lastName %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-envelope"></i> Email</span>
                    <span class="info-value"><%= email %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-phone"></i> Phone</span>
                    <span class="info-value"><%= phone %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-location-dot"></i> Delivery address</span>
                    <span class="info-value"><%= address %>, <%= city %> - <%= pincode %></span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-clock"></i> Order time</span>
                    <span class="info-value"><%= orderTime %></span>
                </div>
            </div>
            
            <div class="soft-divider"></div>
            
            <!-- order summary section (simple) -->
            <div class="summary-title">
                <i class="fa-regular fa-bag-shopping"></i> Your Order
            </div>
            <div class="items-preview">
                <div class="items-text">
                    <i class="fa-regular fa-cookie-bite" style="margin-right: 8px; color:#c2813a;"></i>
                    <%= productNames.length() > 80 ? productNames.substring(0,80)+"..." : productNames %>
                </div>
                <div class="qty-text">
                    <i class="fa-regular fa-cubes"></i> Quantity details: <%= productQtys %>
                </div>
            </div>
            
            <!-- pricing breakdown (clean) -->
            <div class="price-list">
                <div class="price-item">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%,d", subtotal) %></span>
                </div>
                <div class="price-item">
                    <span>Delivery charge</span>
                    <span><% if(delivery == 0) { %><span style="color:#2b7a3e;">FREE</span><% } else { %>₹<%= String.format("%,d", delivery) %><% } %></span>
                </div>
                <div class="price-item total-row">
                    <span>Total amount</span>
                    <span class="total-amount">₹<%= String.format("%,d", total) %></span>
                </div>
            </div>
            
            <!-- payment + eta row -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; margin: 0.5rem 0 0.2rem;">
                <div class="payment-method-chip">
                    <i class="fa-regular fa-credit-card"></i> 
                    <% if("COD".equalsIgnoreCase(paymentMethod)) { %>
                        💵 Cash on Delivery
                    <% } else if("UPI".equalsIgnoreCase(paymentMethod)) { %>
                        📱 UPI / Google Pay
                    <% } else { %>
                        💳 Card Payment
                    <% } %>
                </div>
                <div class="delivery-estimate">
                    <i class="fa-regular fa-clock"></i> Est. delivery: 45–60 min
                </div>
            </div>
        </div>
        
        <div class="footer-actions">
            <div class="btn-group">
                <a href="index.html" class="btn btn-primary"><i class="fa-regular fa-house-chimney"></i> Back to Home</a>
                <a href="javascript:window.print()" class="btn btn-outline"><i class="fa-regular fa-print"></i> Print Receipt</a>
            </div>
            <p style="font-size: 0.7rem; color: #b28b64; margin-top: 1.5rem;">
                <i class="fa-regular fa-heart"></i> A confirmation email has been sent to your inbox. Thanks for baking with us!
            </p>
        </div>
    </div>
<% } %>
</div>

</body>
</html>